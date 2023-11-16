local wezterm = require 'wezterm'
local config = wezterm.config_builder()

function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = basename(pane.foreground_process_name)
      .. ' '
      .. pane.pane_id
    local color = '#8FBCBB'
    if tab.is_active then
      color = '#5E81AC'
    end
    return {
      { Background = { Color = color } },
      { Text = ' ' .. title .. ' ' },
    }
  end
)

-- Tab stuff
config.show_new_tab_button_in_tab_bar = false

-- Colors
config.color_scheme = 'Nord (Gogh)'
config.window_background_opacity = 0.94
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.5,
}

-- Font
config.font = wezterm.font('Cica')
config.font_size = 24.0

-- Bell
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 50,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 50
}
config.colors = { visual_bell = '#ffffff' }

-- Key bindings
config.leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = 't',   mods = 'LEADER|CTRL',  action = wezterm.action.SendKey { key = 't', mods = 'CTRL' } },
  { key = 'c',   mods = 'LEADER',       action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = '|',   mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-',   mods = 'LEADER',       action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'z',   mods = 'LEADER',       action = wezterm.action.TogglePaneZoomState },
  -- pane traversal
  { key = 'h',   mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'j',   mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Down' },
  { key = 'k',   mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'l',   mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'Tab', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Next' },
  { key = 'Tab', mods = 'LEADER|SHIFT', action = wezterm.action.ActivatePaneDirection 'Prev' },
  -- tab traversal
  { key = ']',   mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(1) },
  { key = '[',   mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(-1) },
}

return config
