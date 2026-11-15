"""append_devices_to_prompt: devices written as a list or as a single string can both be appended to the prompt.

The config.yaml example and the mobile control console provide a list, which used to raise
can only concatenate str (not "list") to str; the device list never reached the prompt and the model could only guess the entity_id.
"""
import pytest

import plugins_func.functions.hass_state  # noqa: F401  registers the hass_state module and fills module_func_map
from plugins_func.functions.hass_init import append_devices_to_prompt

HEADER = "\nBelow is the list of smart devices in my home (location, device name, entity_id), which can be controlled through homeassistant\n"
BASE_PROMPT = "You are Xiaozhi."


class FakeDialogue:
    def __init__(self):
        self.system_messages = []

    def update_system_message(self, prompt):
        self.system_messages.append(prompt)


class FakeConn:
    def __init__(self, plugin, source="home_assistant", functions=("hass_get_state", "hass_set_state")):
        self.intent_type = "function_call"
        self.config = {
            "selected_module": {"Intent": "function_call"},
            "Intent": {"function_call": {"functions": list(functions)}},
            "plugins": {source: plugin},
        }
        self.prompt = BASE_PROMPT
        self.dialogue = FakeDialogue()


def _plugin(**extra):
    return {"base_url": "http://homeassistant.local:8123", "api_key": "test-token", **extra}


def test_list_devices_one_per_line():
    conn = FakeConn(_plugin(devices=[
        "Living room,Toy lamp,switch.toy_lamp",
        " Bedroom,Desk lamp,switch.desk_lamp ",
        "",
    ]))
    append_devices_to_prompt(conn)
    expected = BASE_PROMPT + HEADER + "Living room,Toy lamp,switch.toy_lamp\nBedroom,Desk lamp,switch.desk_lamp\n"
    assert conn.prompt == expected
    assert conn.dialogue.system_messages == [expected]


def test_string_devices_kept_as_is():
    # The web control console and the HA integration docs provide a single string
    devices = "Living room,Toy lamp,switch.toy_lamp;\nBedroom,Desk lamp,switch.desk_lamp;"
    conn = FakeConn(_plugin(devices=devices))
    append_devices_to_prompt(conn)
    assert conn.prompt == BASE_PROMPT + HEADER + devices + "\n"


def test_mobile_console_hass_state_list():
    # The plugin config key delivered by the control console is hass_state; the mobile app splits the array field into a list by line
    conn = FakeConn(_plugin(devices=["Living room,Toy lamp,switch.toy_lamp"]), source="hass_state")
    append_devices_to_prompt(conn)
    assert conn.prompt.endswith(HEADER + "Living room,Toy lamp,switch.toy_lamp\n")


def test_module_name_in_functions():
    # functions lists the module name hass_state (as written in the config.yaml comment); it should match after expansion
    conn = FakeConn(_plugin(devices=["Living room,Toy lamp,switch.toy_lamp"]), functions=("hass_state",))
    append_devices_to_prompt(conn)
    assert conn.prompt.endswith(HEADER + "Living room,Toy lamp,switch.toy_lamp\n")


@pytest.mark.parametrize("plugin", [_plugin(), _plugin(devices=None), _plugin(devices=[])])
def test_missing_or_empty_devices_does_not_raise(plugin):
    conn = FakeConn(plugin)
    append_devices_to_prompt(conn)
    assert conn.prompt == BASE_PROMPT + HEADER + "\n"


def test_without_hass_functions_prompt_unchanged():
    conn = FakeConn(_plugin(devices=["Living room,Toy lamp,switch.toy_lamp"]), functions=("get_weather",))
    append_devices_to_prompt(conn)
    assert conn.prompt == BASE_PROMPT
    assert conn.dialogue.system_messages == []
