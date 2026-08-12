#!/usr/bin/env python3
import os
import platform
import shutil
import sys
from pathlib import Path


def install_configs():
    repo_dir = Path(__file__).resolve().parent
    is_windows = platform.system() == "Windows" or os.name == "nt"
    os_name = "Windows" if is_windows else "Unix/Linux"

    print(f"=== Batsu Redux Config Installer ===")
    print(f"Detected OS: {os_name}\n")

    home = Path.home()
    config_dir = home / ".config"

    if is_windows:
        appdata_str = os.environ.get("APPDATA")
        appdata = Path(appdata_str) if appdata_str else home / "AppData" / "Roaming"

        configs = [
            {
                "name": "Fastfetch",
                "source": repo_dir / "fastfetch" / "config-windows.jsonc",
                "targets": [
                    appdata / "fastfetch" / "config.jsonc",
                    config_dir / "fastfetch" / "config.jsonc",
                ],
            },
            {
                "name": "WezTerm",
                "source": repo_dir / "wezterm" / ".wezterm-windows.lua",
                "targets": [
                    home / ".wezterm.lua",
                    appdata / "wezterm" / "wezterm.lua",
                    config_dir / "wezterm" / "wezterm.lua",
                ],
            },
        ]
    else:
        configs = [
            {
                "name": "Fastfetch",
                "source": repo_dir / "fastfetch" / "config-unix.jsonc",
                "targets": [
                    config_dir / "fastfetch" / "config.jsonc",
                ],
            },
            {
                "name": "WezTerm",
                "source": repo_dir / "wezterm" / ".wezterm-unix.lua",
                "targets": [
                    config_dir / "wezterm" / "wezterm.lua",
                    home / ".wezterm.lua",
                ],
            },
        ]

    for item in configs:
        name = item["name"]
        source = item["source"]

        if not source.exists():
            print(f"❌ [ERROR] Source file not found: {source}")
            continue

        for target in item["targets"]:
            target_dir = target.parent
            if not target_dir.exists():
                print(f"📁 Creating target directory: {target_dir}")
                target_dir.mkdir(parents=True, exist_ok=True)

            shutil.copy2(source, target)
            print(f"✅ [{name}] Copied '{source.relative_to(repo_dir)}' -> '{target}'")

    print("\n🎉 All configurations deployed successfully!")


if __name__ == "__main__":
    install_configs()
