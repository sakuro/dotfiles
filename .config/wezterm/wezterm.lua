local wezterm = require 'wezterm'
local config = wezterm.config_builder()

if string.find(wezterm.target_triple, 'windows') then
  config.default_domain = 'WSL:Ubuntu-22.04'
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local process_name = pane.user_vars.WEZTERM_PROG or ""

    return {
      { Background = { Color = tab.is_active and '#81A1C1' or '#5E81AC' } },
      { Foreground = { Color = '#ECEFF4' } },
      { Text = process_name },
    }
  end)

wezterm.on(
  'update-right-status',
  function(window, pane)
    local date = wezterm.strftime '%Y/%m/%d %H:%M'
    window:set_right_status(wezterm.format {
      { Foreground = { AnsiColor = 'Teal' } },
      { Text = wezterm.nerdfonts.fa_clock_o .. ' ' .. date },
      { Foreground = { AnsiColor = 'Navy' } },
    })
  end)

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

config.disable_default_key_bindings = true
-- leader is a WezTerm's term used for so-called prefix key
config.leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 1000 }

local MoveToNewTab = wezterm.action_callback(function(window, pane)
  local tab, window = pane:move_to_new_tab()
  tab:activate()
end)

config.keys = {
  { key = 't',   mods = 'LEADER|CTRL',  action = wezterm.action.SendKey { key = 't', mods = 'CTRL' } },
  -- tab management
  { key = 'c',   mods = 'LEADER',       action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = '!',   mods = 'LEADER',       action = MoveToNewTab },
  -- tab traversal
  { key = ']',   mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(1) },
  { key = '[',   mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(-1) },
  { key = '}',   mods = 'LEADER',       action = wezterm.action.MoveTabRelative(1) },
  { key = '{',   mods = 'LEADER',       action = wezterm.action.MoveTabRelative(-1) },
  -- pane management
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
  -- clipboard
  { key = 'v',   mods = 'LEADER|CTRL',  action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'c',   mods = 'LEADER|CTRL',  action = wezterm.action.CopyTo    'Clipboard' },
  -- font size
  { key = '+',   mods = 'LEADER|SHIFT', action = wezterm.action.IncreaseFontSize },
  { key = '-',   mods = 'LEADER',       action = wezterm.action.DecreaseFontSize },
  { key = '0',   mods = 'LEADER',       action = wezterm.action.ResetFontSize },
  -- other
  { key = 's',   mods = 'LEADER|SHIFT', action = wezterm.action.ReloadConfiguration },
  -- restore some default bindings
  { key = 'p',   mods = 'CTRL|SHIFT',   action = wezterm.action.ActivateCommandPalette },
  { key = 'l',   mods = 'CTRL|SHIFT',   action = wezterm.action.ShowDebugOverlay },
}

return config
