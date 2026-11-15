import httpx
import openai
from openai.types import CompletionUsage
from config.logger import setup_logging
from core.utils.util import check_model_key
from core.providers.llm.base import LLMProviderBase
from urllib.parse import urlparse

TAG = __name__
logger = setup_logging()

# Platform domains that need thinking mode disabled, with their parameters (thinking mode is off by default)
THINKING_DISABLED_DOMAINS = {
    "aliyuncs.com": {"enable_thinking": False},
    "deepseek.com": {"thinking": {"type": "disabled"}},
    "bigmodel.cn": {"thinking": {"type": "disabled"}},
    "moonshot.cn": {"thinking": {"type": "disabled"}},
    "volces.com": {"thinking": {"type": "disabled"}},
    "modelarts-maas.com": {"thinking": {"type": "disabled"}},
}

# Model-name exemptions from the domain rules: forced-thinking models reject this injected parameter (e.g. MaaS glm-5.3 always returns 400 when thinking is passed)
THINKING_DISABLED_MODEL_EXCLUSIONS = {
    "modelarts-maas.com": ("glm-5.3",),
}


class LLMProvider(LLMProviderBase):
    def __init__(self, config):
        self.model_name = config.get("model_name")
        # Optional per-instance thinking effort: off/disabled/none/disable | low/medium/high | empty/other = domain default
        self.thinking_mode = str(config.get("thinking") or "").strip().lower()
        self.api_key = config.get("api_key")
        if "base_url" in config:
            self.base_url = config.get("base_url")
        else:
            self.base_url = config.get("url")
        
        timeout_config = config.get("timeout")
        if isinstance(timeout_config, dict):
            # Fine-grained timeout configuration
            custom_timeout = httpx.Timeout(
                pool=timeout_config.get("pool", 2.0),
                connect=timeout_config.get("connect", 3.0),
                write=timeout_config.get("write", 5.0),
                read=timeout_config.get("read", 60.0)
            )
        elif isinstance(timeout_config, (int, float)) and timeout_config > 0:
            # Backward compatible with the old single timeout setting (int or float)
            custom_timeout = httpx.Timeout(timeout_config)
        else:
            # Not configured or invalid; use the defaults
            custom_timeout = httpx.Timeout(300)

        param_defaults = {
            "max_tokens": int,
            "temperature": lambda x: round(float(x), 1),
            "top_p": lambda x: round(float(x), 1),
            "frequency_penalty": lambda x: round(float(x), 1),
        }

        for param, converter in param_defaults.items():
            value = config.get(param)
            try:
                setattr(
                    self,
                    param,
                    converter(value) if value not in (None, "") else None,
                )
            except (ValueError, TypeError):
                setattr(self, param, None)

        logger.debug(
            f"Intent recognition parameters initialized: {self.temperature}, {self.max_tokens}, {self.top_p}, {self.frequency_penalty}"
        )

        model_key_msg = check_model_key("LLM", self.api_key)
        if model_key_msg:
            logger.bind(tag=TAG).error(model_key_msg)
        self.client = openai.OpenAI(api_key=self.api_key, base_url=self.base_url, timeout=custom_timeout)

    @staticmethod
    def normalize_dialogue(dialogue):
        """Automatically fix messages in dialogue that are missing content"""
        for msg in dialogue:
            if "role" in msg and "content" not in msg:
                msg["content"] = ""
        return dialogue

    def _apply_thinking_disabled(self, request_params: dict):
        """Thinking mode control: instance config (thinking) takes precedence, otherwise the domain default table"""
        mode = getattr(self, "thinking_mode", "")
        if mode in ("keep", "passthrough", "default"):
            # No intervention: neither send the thinking parameter nor consult the domain table (for models that force thinking or reject the parameter, e.g. MaaS glm-5.3)
            return
        if mode in ("off", "disabled", "none", "disable"):
            request_params.setdefault("extra_body", {}).update({"thinking": {"type": "disabled"}})
            logger.bind(tag=TAG).info("Thinking effort=off: thinking mode disabled (instance config)")
            return
        if mode in ("low", "medium", "high"):
            request_params.setdefault("extra_body", {}).update(
                {"reasoning_effort": mode, "thinking": {"type": "enabled"}})
            logger.bind(tag=TAG).info(f"Thinking effort={mode}: reasoning_effort set (instance config)")
            return
        parsed_url = urlparse(self.base_url)
        domain = parsed_url.netloc
        model_name = (self.model_name or "").lower()
        for disabled_domain, params in THINKING_DISABLED_DOMAINS.items():
            if disabled_domain not in domain:
                continue
            exclusions = THINKING_DISABLED_MODEL_EXCLUSIONS.get(disabled_domain, ())
            if any(ex in model_name for ex in exclusions):
                logger.bind(tag=TAG).info(
                    f"Domain {domain} matches the disable-thinking rule, but model {self.model_name} forces thinking and rejects the parameter; skipping injection")
                break
            request_params.setdefault("extra_body", {}).update(params)
            logger.bind(tag=TAG).info(f"Disabled thinking mode for domain {domain}, parameters: {params}")
            break

    def response(self, session_id, dialogue, **kwargs):
        dialogue = self.normalize_dialogue(dialogue)

        request_params = {
            "model": self.model_name,
            "messages": dialogue,
            "stream": True,
        }

        # Add optional parameters only when they are not None
        optional_params = {
            "max_tokens": kwargs.get("max_tokens", self.max_tokens),
            "temperature": kwargs.get("temperature", self.temperature),
            "top_p": kwargs.get("top_p", self.top_p),
            "frequency_penalty": kwargs.get("frequency_penalty", self.frequency_penalty),
        }

        for key, value in optional_params.items():
            if value is not None:
                request_params[key] = value

        # Disable thinking mode
        self._apply_thinking_disabled(request_params)

        responses = self.client.chat.completions.create(**request_params)

        is_active = True
        try:            
            for chunk in responses:
                try:
                    delta = chunk.choices[0].delta if getattr(chunk, "choices", None) else None
                    content = getattr(delta, "content", "") if delta else ""
                except IndexError:
                    content = ""
                if content:
                    if "<think>" in content:
                        is_active = False
                        content = content.split("<think>")[0]
                    if "</think>" in content:
                        is_active = True
                        content = content.split("</think>")[-1]
                    if is_active:
                        yield content
        finally:
            responses.close()

    def response_with_functions(self, session_id, dialogue, functions=None, **kwargs):
        dialogue = self.normalize_dialogue(dialogue)

        request_params = {
            "model": self.model_name,
            "messages": dialogue,
            "stream": True,
            "tools": functions,
        }

        optional_params = {
            "max_tokens": kwargs.get("max_tokens", self.max_tokens),
            "temperature": kwargs.get("temperature", self.temperature),
            "top_p": kwargs.get("top_p", self.top_p),
            "frequency_penalty": kwargs.get("frequency_penalty", self.frequency_penalty),
        }

        for key, value in optional_params.items():
            if value is not None:
                request_params[key] = value

        # Disable thinking mode
        self._apply_thinking_disabled(request_params)

        stream = self.client.chat.completions.create(**request_params)

        try:
            for chunk in stream:
                if getattr(chunk, "choices", None):
                    delta = chunk.choices[0].delta
                    content = getattr(delta, "content", "")
                    tool_calls = getattr(delta, "tool_calls", None)
                    yield content, tool_calls
                elif isinstance(getattr(chunk, "usage", None), CompletionUsage):
                    usage_info = getattr(chunk, "usage", None)
                    logger.bind(tag=TAG).info(
                        f"Token usage: input {getattr(usage_info, 'prompt_tokens', 'unknown')}, "
                        f"output {getattr(usage_info, 'completion_tokens', 'unknown')}, "
                        f"total {getattr(usage_info, 'total_tokens', 'unknown')}"
                    )
        finally:
            stream.close()
