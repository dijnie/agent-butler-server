import os
import asyncio
from config.config_loader import read_config, get_project_dir, load_config


default_config_file = "config.yaml"
config_file_valid = False


def check_config_file():
    global config_file_valid
    if config_file_valid:
        return
    """
    Simplified config check that only tells the user how the config file is being used
    """
    custom_config_file = get_project_dir() + "data/." + default_config_file
    if not os.path.exists(custom_config_file):
        raise FileNotFoundError(
            "Cannot find the data/.config.yaml file, please follow the tutorial to confirm that this config file exists"
        )

    # Check whether the config is read from the API
    config = asyncio.run(load_config())
    if config.get("read_config_from_api", False):
        print("Reading config from the API")
        old_config_origin = read_config(custom_config_file)
        if old_config_origin.get("selected_module") is not None:
            error_msg = "Your config file seems to contain both control console config and local config:\n"
            error_msg += "\nSuggestions:\n"
            error_msg += "1. Copy config_from_api.yaml from the root directory into data and rename it to .config.yaml\n"
            error_msg += "2. Configure the API address and secret according to the tutorial\n"
            raise ValueError(error_msg)
    config_file_valid = True
