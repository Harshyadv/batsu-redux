-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 1. Performance & Hardware Acceleration
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.max_fps = 120
config.prefer_egl = true

-- 2. Geometry, Window & Padding Settings
config.initial_cols = 120
config.initial_rows = 28
config.window_decorations = 'RESIZE'
config.adjust_window_size_when_changing_font_size = false

-- 3. Typography & Font Fallback Configuration
config.font = wezterm.font_with_fallback {
  'BlexMono Nerd Font Mono',
  'CaskaydiaCove Nerd Font Mono'
}
config.font_size = 11.0
config.line_height = 1.05

-- 4. Theme & Color Scheme
config.color_scheme = 'Gruvbox Dark (Gogh)'
-- config.window_background_opacity = 0.93

-- 5. Terminal Emulation & ConPTY Fixes (Windows Specific)
-- Forces standard xterm identity to prevent ConPTY line wrapping issues
config.term = 'xterm-256color'
-- Disables native Windows ConPTY title reporting that causes line-jumping
config.enable_csi_u_key_encoding = true
-- Disable Win32 backdrop for maximum rendering speed and stability
config.win32_system_backdrop = 'Disable'
-- Increase scrollback buffer size
config.scrollback_lines = 10000

-- 6. Default Shell & Directory Setup
config.default_cwd = 'D:/Documents'
config.default_prog = { 'nu.exe' }

-- Return the optimized configuration to WezTerm
return config
