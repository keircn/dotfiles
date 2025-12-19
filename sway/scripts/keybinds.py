#!/usr/bin/env python3

import os
import re
import subprocess


def parse_sway_config(config_path):
    if not os.path.exists(config_path):
        return []

    variables = {}
    binds = []
    set_re = re.compile(r"^\s*set\s+(\$\w+)\s+(.+)")
    bind_re = re.compile(r"^\s*bindsym\s+(?:--\S+\s+)*(\S+)\s+(.+)")

    with open(config_path, "r") as f:
        lines = f.readlines()

    for line in lines:
        line = line.strip()
        if not line or line.startswith("#"):
            continue

        set_match = set_re.match(line)
        if set_match:
            var_name, var_value = set_match.groups()
            variables[var_name] = var_value
            continue

        bind_match = bind_re.match(line)
        if bind_match:
            combo, action = bind_match.groups()

            if "XF86" in combo:
                continue

            for var_name, var_value in variables.items():
                combo = combo.replace(var_name, var_value)
                action = action.replace(var_name, var_value)

            binds.append((combo, action))

    if not binds:
        return []

    max_len = min(max(len(b[0]) for b in binds), 30)
    formatted_binds = [f"{combo:<{max_len}} │ {action}" for combo, action in binds]

    return formatted_binds


def main():
    config_path = os.path.expanduser("~/.config/sway/config")
    if not os.path.exists(config_path):
        config_path = os.path.expanduser("/home/kc/.dotfiles/sway/config")

    binds = parse_sway_config(config_path)

    if not binds:
        print("No keybinds found.")
        return

    input_str = "\n".join(binds)

    try:
        subprocess.run(
            ["fuzzel", "-d", "-p", "Keybinds: ", "--width", "80"],
            input=input_str.encode(),
            check=True,
        )
    except FileNotFoundError:
        print("fuzzel not found. Printing to stdout:")
        print(input_str)
    except subprocess.CalledProcessError:
        pass


if __name__ == "__main__":
    main()
