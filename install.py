#!/usr/bin/env python3
import os
import platform
import shutil
import sys
from pathlib import Path


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

    # Select OS-specific source files
    fastfetch_src = (
        repo_dir / "fastfetch" / ("config-windows.jsonc" if is_windows else "config-unix.jsonc")
    )
    wezterm_src = (
        repo_dir / "wezterm" / (".wezterm-windows.lua" if is_windows else ".wezterm-unix.lua")
    )

    # Explicit symlink targets requested
    configs = [
        {
            "name": "Bash",
            "source": repo_dir / "bash" / ".bashrc",
            "target": home / ".bashrc",
        },
        {
            "name": "Fastfetch",
            "source": fastfetch_src,
            "target": config_dir / "fastfetch" / "config.jsonc",
        },
        {
            "name": "WezTerm",
            "source": wezterm_src,
            "target": home / ".wezterm.lua",
        },
        {
            "name": "Neovim",
            "source": repo_dir / "nvim",
            "target": config_dir / "nvim",
        },
    ]

    # DO NOT TOUCH LIST: oh-my-posh, sddm, yazi (strictly ignored)

    for item in configs:
        name = item["name"]
        source = item["source"]
        target = item["target"]

        if not source.exists():
            print(f"❌ [ERROR] Source not found: {source}")
            continue

        # Ensure parent folder exists
        target.parent.mkdir(parents=True, exist_ok=True)

        # Cleanup existing target file / link / directory before linking
        if target.exists() or target.is_symlink():
            if target.is_dir() and not target.is_symlink():
                try:
                    os.rmdir(target)
                except OSError:
                    shutil.rmtree(target)
            else:
                target.unlink()

        target_is_dir = source.is_dir()
        try:
            target.symlink_to(source, target_is_directory=target_is_dir)
            print(f"🔗 [{name}] Symlinked: '{source.relative_to(repo_dir)}' -> '{target}'")
        except Exception as e:
            print(f"❌ [{name}] Failed to symlink '{source.relative_to(repo_dir)}' -> '{target}': {e}")

    print("\n🎉 All specified configurations symlinked successfully!")


if __name__ == "__main__":
    install_configs()
