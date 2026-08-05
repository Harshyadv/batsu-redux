-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28
config.use_fancy_tab_bar = false

-- Tab name format
wezterm.on('format-tab-title', function(tab)
  local p = tab.active_pane
  local proc = (p.foreground_process_name or p.title):match('([^/\\]+)$')
  return string.format(' %s ', proc)
end)

-- or, changing the font size and color scheme.
config.font = wezterm.font 'CaskaydiaCove Nerd Font Mono'
config.font_size = 10
config.color_scheme = 'GruvboxDarkHard'

-- Finally, return the configuration to wezterm:
return config
