-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28
config.window_decorations = "RESIZE"

-- or, changing the font size and color scheme.
config.font = wezterm.font 'BlexMono Nerd Font Mono'
config.font_size = 11
config.color_scheme = 'Dark+'
-- config.window_background_opacity = 0.93

-- Default directory and shell
config.default_cwd = "D://Documents"
config.default_prog = {'elvish'}

-- Finally, return the configuration to wezterm:
return config
