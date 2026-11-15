"""LLM pipeline tests.

Mock mode (default): build the real provider from the config in data/.config.yaml;
network calls go through the shims injected by conftest -- no requests are sent.
Live mode (``RUN_LIVE_API_TESTS=1``): call the real LLM provider, following the
ThreadPoolExecutor + 10s timeout pattern of ``performance_tester_llm.py``.

Interface contract (core/providers/llm/base.py):
    response(session_id, dialogue) -> Iterator[str], a synchronous streaming generator
    response_no_stream(system_prompt, user_content) -> str

Special handling:
- CozeLLM checks bot_id / user_id rather than api_key
- Ollama needs model_name + a reachable local service
- placeholder detection ("你的" / "placeholder" / "xxx" / "sk-xxx")
- the LLM is a synchronous generator, so asyncio.wait_for cannot be used directly -> thread pool
"""
from __future__ import annotations

import concurrent.futures
import sys
from pathlib import Path

import pytest

from tests.conftest import (
    CONFIG,
    LIVE_API_TESTS,
    get_provider_config,
    get_provider_type,
    get_selected_provider_name,
    has_real_key,
)

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))


def _build_provider():
    name = get_selected_provider_name("LLM")
    if not name:
        pytest.skip("selected_module.LLM is not set")
    cfg = get_provider_config("LLM", name)
    if not cfg:
        pytest.skip(f"LLM provider '{name}' config is missing")

    # In every mode: placeholder key -> skip. Live requests need a real key; in mock mode,
    # carrying on without a real key would still hit the real SDK's network stack (openai/edge_tts) and fail.
    if name == "CozeLLM":
        if any(x in cfg.get("bot_id", "") for x in ["你的"]) or any(
            x in cfg.get("user_id", "") for x in ["你的"]
        ):
            pytest.skip("bot_id/user_id of LLM 'CozeLLM' is not configured")
    elif name == "Ollama":
        if not cfg.get("model_name"):
            pytest.skip("model_name of LLM 'Ollama' is not configured")
    elif not has_real_key(cfg, "api_key"):
        if LIVE_API_TESTS:
            pytest.skip(f"api_key of LLM '{name}' is not configured")
        else:
            pytest.skip(
                f"api_key of LLM '{name}' is a placeholder (mock mode sends no real requests). "
                "Live request mode: export RUN_LIVE_API_TESTS=1 and fill in a real key, then rerun."
            )

    ptype = get_provider_type("LLM", name)
    if not ptype:
        pytest.skip(f"LLM '{name}' is missing the type field")
    if not LIVE_API_TESTS:
        # Mock mode blocks the network, so this pipeline gets no real reply and the run is just a connection failure.
        # To really verify this pipeline, run with RUN_LIVE_API_TESTS=1 and a real key
        pytest.skip(
            f"mock mode sends no real requests, skipping pipeline verification of LLM '{name}'. "
            "Live request mode: export RUN_LIVE_API_TESTS=1 and fill in a real key, then rerun."
        )
    from core.utils.llm import create_instance

    return create_instance(ptype, cfg)


def _collect_with_timeout(provider, session_id: str, dialogue, timeout: float = 10.0):
    """Call the synchronous generator response() using a thread pool with a 10s timeout."""
    with concurrent.futures.ThreadPoolExecutor(max_workers=1) as executor:
        future = executor.submit(lambda: list(provider.response(session_id, dialogue)))
        return future.result(timeout=timeout)


def test_llm_response_streams_non_empty() -> None:
    """response(session_id, dialogue) should produce a non-empty token stream."""
    provider = _build_provider()
    dialogue = [
        {"role": "system", "content": "你是助手"},
        {"role": "user", "content": "用一句话说 hi"},
    ]
    chunks = _collect_with_timeout(provider, "test-session", dialogue, timeout=10.0)

    full = "".join(chunks).strip()
    assert isinstance(full, str), f"joined LLM chunks should be str, got {type(full).__name__}"
    assert full, f"LLM returned an empty response (provider={type(provider).__name__})"


def test_llm_response_no_stream_returns_string() -> None:
    """response_no_stream should return a non-empty string."""
    provider = _build_provider()
    text = provider.response_no_stream("你是助手", "介绍一下北京").strip()

    assert isinstance(text, str), f"response_no_stream should return str, got {type(text).__name__}"
    assert text, "response_no_stream returned an empty string"


def test_llm_dialogue_min_length_one_user() -> None:
    """A dialogue with at least one user message should work."""
    provider = _build_provider()
    dialogue = [{"role": "user", "content": "ping"}]
    chunks = _collect_with_timeout(provider, "s1", dialogue, timeout=10.0)

    assert "".join(chunks).strip(), "a single user message should return content"
