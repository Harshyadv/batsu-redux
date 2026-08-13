# 🍱 Batsu Redux

> My dotfiles collection for Linux & Windows.

![Homescreen](screenshot/homescreen.png)

## 🚀 Quick Start & Installation

Run the cross-platform installer script (`install.py`) to automatically deploy configurations for your OS:

```bash
python3 install.py
```
*(On Windows, run `python install.py` in PowerShell or Command Prompt).*

### 🔗 What gets deployed:
- **Linux / Unix**: Creates symlinks for **Bash** (`~/.bashrc`), **Fastfetch** (`~/.config/fastfetch/config.jsonc`), **WezTerm** (`~/.wezterm.lua`), **Fish** (`~/.config/fish`), and **Neovim** (`~/.config/nvim`).
- **Windows**: Creates hardlinks for files (**Fastfetch**, **WezTerm**) and junctions for folders (**Nushell**, **Neovim**).

---

## 📁 What's Included

| Component | Description |
| :--- | :--- |
| **Terminal** | [WezTerm](wezterm/) |
| **Prompt** | [Oh My Posh](oh-my-posh/) |
| **Shells** | [Fish](fish/), [Bash](bash/) & [Nushell](nushell/) |
| **Editor** | [Neovim](nvim/) |
| **File Manager** | [Yazi](yazi/) |
| **Fetch Tool** | [Fastfetch](fastfetch/) |
| **Display Manager** | [sddm](sddm/) |
| **Color Schemes** | [Color Presets](colors/) |
| **Browser** | [Homepage Configs](browser-homepages/) |
| **Wallpapers** | [Wallpapers & Fetch Art](wallpaper-and-fetch-art/) |

---

## 📸 Gallery

<details>
<summary>Click to view screenshots</summary>
<br>

| Fastfetch | WezTerm |
| :---: | :---: |
| ![Fastfetch](screenshot/fastfetch.png) | ![Yazi](screenshot/yazi-and-ohmyposh-in-wezterm.png) |

| sddm Theme | Waterfox |
| :---: | :---: |
| ![sddm](screenshot/sddm.png) | ![Waterfox](screenshot/waterfox.png) |

</details>

---

> [!NOTE]
> Please verify and update file paths in the config files to match your local setup environment.
> All of this was possible via `Antigravity CLI`
