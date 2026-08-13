#!/usr/bin/env python3
import os
import platform
import shutil
import sys
from pathlib import Path

if platform.system() == "Windows" or os.name == "nt":
    import _winapi


def install_configs():
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8")

    repo_dir = Path(__file__).resolve().parent
    is_windows = platform.system() == "Windows" or os.name == "nt"
    os_name = "Windows" if is_windows else "Unix/Linux"

    print(f"=== Batsu Redux Config Installer ===")
    print(f"Detected OS: {os_name}\n")

    home = Path.home()
    config_dir = home / ".config"

    if is_windows:
        appdata_env = os.environ.get("APPDATA")
        appdata = Path(appdata_env) if appdata_env else home / "AppData" / "Roaming"

        localappdata_env = os.environ.get("LOCALAPPDATA")
        localappdata = Path(localappdata_env) if localappdata_env else home / "AppData" / "Local"

        configs = [
            {
                "name": "Fastfetch",
                "type": "file",
                "source": repo_dir / "fastfetch" / "config-windows.jsonc",
                "targets": [
                    config_dir / "fastfetch" / "config.jsonc",
                ],
            },
            {
                "name": "WezTerm",
                "type": "file",
                "source": repo_dir / "wezterm" / ".wezterm-windows.lua",
                "targets": [
                    home / ".wezterm.lua",
                ],
            },
            {
                "name": "Nushell",
                "type": "dir",
                "source": repo_dir / "nushell",
                "targets": [
                    appdata / "nushell",
                ],
            },
            {
                "name": "Neovim",
                "type": "dir",
                "source": repo_dir / "nvim",
                "targets": [
                    localappdata / "nvim",
                ],
            },
        ]
    else:
        configs = [
            {
                "name": "Fastfetch",
                "type": "file",
                "source": repo_dir / "fastfetch" / "config-unix.jsonc",
                "targets": [
                    config_dir / "fastfetch" / "config.jsonc",
                ],
            },
            {
                "name": "WezTerm",
                "type": "file",
                "source": repo_dir / "wezterm" / ".wezterm-unix.lua",
                "targets": [
                    config_dir / "wezterm" / "wezterm.lua",
                    home / ".wezterm.lua",
                ],
            },
            {
                "name": "Nushell",
                "type": "dir",
                "source": repo_dir / "nushell",
                "targets": [
                    config_dir / "nushell",
                ],
            },
            {
                "name": "Neovim",
                "type": "dir",
                "source": repo_dir / "nvim",
                "targets": [
                    config_dir / "nvim",
                ],
            },
        ]

    for item in configs:
        name = item["name"]
        item_type = item["type"]
        source = item["source"]

        if not source.exists():
            print(f"❌ [ERROR] Source file/folder not found: {source}")
            continue

        for target in item["targets"]:
            # Ensure parent folder exists
            target.parent.mkdir(parents=True, exist_ok=True)

            # Cleanup existing target
            if target.exists() or target.is_symlink():
                if target.is_dir() and not target.is_symlink():
                    try:
                        os.rmdir(target)
                    except OSError:
                        shutil.rmtree(target)
                else:
                    target.unlink()

            if is_windows:
                if item_type == "dir":
                    _winapi.CreateJunction(str(source), str(target))
                    print(f"🔗 [{name}] Junction: '{source.relative_to(repo_dir)}' -> '{target}'")
                else:
                    os.link(source, target)
                    print(f"🔗 [{name}] Hardlinked: '{source.relative_to(repo_dir)}' -> '{target}'")
            else:
                target.symlink_to(source)
                print(f"🔗 [{name}] Symlinked: '{source.relative_to(repo_dir)}' -> '{target}'")

    print("\n🎉 All configurations deployed successfully!")


if __name__ == "__main__":
    install_configs()

