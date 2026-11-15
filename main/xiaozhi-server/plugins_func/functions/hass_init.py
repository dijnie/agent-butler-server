from config.logger import setup_logging
from core.utils.util import check_model_key
from plugins_func.register import module_func_map

TAG = __name__
logger = setup_logging()


def _expand_module_names(funcs):
    """Expand module names in the functions list (e.g. hass_state) into concrete function names, consistent with how tools are loaded."""
    expanded = []
    for name in funcs:
        expanded.extend(module_func_map.get(name, [name]))
    return expanded


def _devices_text(devices) -> str:
    """Convert the devices config into text to be appended to the prompt.

    The config.yaml example and the mobile control console provide a list, one "location,device name,entity_id" per item; here they are joined one per line;
    the web control console and the HA integration docs provide a single string, used as is; anything else (e.g. None) is treated as empty.
    """
    if isinstance(devices, (list, tuple)):
        return "\n".join(
            str(d).strip() for d in devices if d is not None and str(d).strip()
        )
    return devices if isinstance(devices, str) else ""


def _hass_plugin_config(plugins_config: dict) -> dict:
    """Get the HA plugin config: prefer home_assistant from the local config.yaml, then hass_state pushed from the control console."""
    for key in ("home_assistant", "hass_state"):
        cfg = plugins_config.get(key)
        if cfg:
            return cfg
    return {}


def append_devices_to_prompt(conn):
    if conn.intent_type == "function_call":
        funcs = _expand_module_names(
            conn.config["Intent"][conn.config["selected_module"]["Intent"]].get(
                "functions", []
            )
        )

        if "hass_get_state" in funcs or "hass_set_state" in funcs:
            prompt = "\nBelow is the list of smart devices in my home (location, device name, entity_id), which can be controlled through homeassistant\n"
            plugin_config = _hass_plugin_config(conn.config.get("plugins", {}))
            deviceStr = _devices_text(plugin_config.get("devices", ""))
            conn.prompt += prompt + deviceStr + "\n"
            # Update the prompt
            conn.dialogue.update_system_message(conn.prompt)


def initialize_hass_handler(conn):
    ha_config = {}
    if not conn.load_function_plugin:
        return ha_config

    plugin_config = _hass_plugin_config(conn.config.get("plugins", {}))
    if not plugin_config:
        return ha_config

    ha_config["base_url"] = plugin_config.get("base_url")
    ha_config["api_key"] = plugin_config.get("api_key")

    # Check the API key in one place
    model_key_msg = check_model_key("home_assistant", ha_config.get("api_key"))
    if model_key_msg:
        logger.bind(tag=TAG).error(model_key_msg)

    return ha_config
