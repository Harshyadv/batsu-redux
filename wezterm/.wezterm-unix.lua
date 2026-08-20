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

-- Helper: map resolved symlink paths in $HOME back to their logical symlink paths
local symlink_dirs = {}
local home = os.getenv('HOME')
if home then
  local cmd = string.format([[sh -c 'for link in "%s"/*; do if [ -L "$link" ] && [ -d "$link" ]; then target=$(readlink -f "$link"); printf "%%s\t%%s\n" "$target" "$link"; fi; done']], home)
  local handle = io.popen(cmd)
  if handle then
    for line in handle:lines() do
      local target, link = line:match('^(.-)\t(.-)$')
      if target and link then
        table.insert(symlink_dirs, { target = target, link = link })
      end
    end
    handle:close()
  end
end

local function get_logical_cwd(pane)
  local cwd_uri = pane:get_current_working_dir()
  if not cwd_uri then
    return nil
  end
  local path = type(cwd_uri) == 'userdata' and cwd_uri.file_path or (cwd_uri.file_path or tostring(cwd_uri))
  if not path then
    return nil
  end

  -- Strip file:// URI schema and hostname if present
  path = path:gsub('^file://[^/]*', '')

  for _, item in ipairs(symlink_dirs) do
    if path == item.target then
      return item.link
    elseif path:sub(1, #item.target + 1) == item.target .. '/' then
      return item.link .. path:sub(#item.target + 1)
    end
  end
  return path
end

local spawn_tab_in_logical_cwd = wezterm.action_callback(function(window, pane)
  local cwd = get_logical_cwd(pane)
  local spawn_args = {}
  if cwd then
    spawn_args.cwd = cwd
    spawn_args.set_environment_variables = {
      PWD = cwd,
    }
  end
  window:perform_action(wezterm.action.SpawnCommandInNewTab(spawn_args), pane)
end)

-- Keybindings
config.keys = {
  { key = 't', mods = 'CTRL|SHIFT', action = spawn_tab_in_logical_cwd },
  { key = 'T', mods = 'CTRL|SHIFT', action = spawn_tab_in_logical_cwd },
}

-- Tab bar new button click handler
wezterm.on('new-tab-button-click', function(window, pane, button, default_action)
  if button == 'Left' then
    local cwd = get_logical_cwd(pane)
    local spawn_args = {}
    if cwd then
      spawn_args.cwd = cwd
      spawn_args.set_environment_variables = {
        PWD = cwd,
      }
    end
    window:perform_action(wezterm.action.SpawnCommandInNewTab(spawn_args), pane)
    return false
  end
  return true
end)

-- Finally, return the configuration to wezterm:
return config
