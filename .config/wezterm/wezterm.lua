local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local os =
  string.find(wezterm.target_triple, '-windows-') and 'windows' or
  string.find(wezterm.target_triple, '-apple-') and 'macos' or
  string.find(wezterm.target_triple, '-linux-') and 'linux' or
  error('Unsupported Operating System')

-- https://www.nordtheme.com/docs/colors-and-palettes
local nord = {
  -- polar night
  nord0 = '#2E3440', nord1 = '#3B4252', nord2 = '#434C5E', nord3 = '#4C566A',
  -- snow storm
  nord4 = '#D8DEE9', nord5 = '#E5E9F0', nord6 = '#ECEFF4',
  -- frost
  nord7 = '#8FBCBB', nord8 = '#88C0D0', nord9 = '#81A1C1', nord10 = '#5E81AC',
  -- aurora
  nord11 = '#BF616A', nord12 = '#D08770', nord13 = '#EBCB8B', nord14 = '#A3BE8C', nord15 = '#B48EAD',
}

if os == 'windows' then
  config.default_domain = 'WSL:Ubuntu-22.04'
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local process_name = pane.user_vars.WEZTERM_PROG or ""

  return {
    { Background = { Color = tab.is_active and nord.nord8 or nord.nord9 } },
    { Foreground = { Color = nord.nord6 } },
    { Text = process_name },
  }
end)

wezterm.on('update-right-status', function(window, pane)
  local separator = { Text = ' ' }

  local battery_info = wezterm.battery_info()[1]
  local state_of_charge = battery_info.state_of_charge
  local battery_icon = state_of_charge < 1 and "md_battery_" .. math.floor(state_of_charge * 10) .. "0" or "md_battery"
  local charged_percentage = string.format("%.0f%%", state_of_charge * 100)

  local date = wezterm.strftime '%Y/%m/%d %H:%M:%S'

  window:set_right_status(wezterm.format {
    { Background = { Color = nord.nord1 } },

    { Foreground = { Color = nord.nord13 } },
    { Text = wezterm.nerdfonts[battery_icon] },
    { Foreground = { Color = nord.nord6 } },
    { Text = charged_percentage },
    separator,
    { Foreground = { Color = nord.nord10 } },
    { Text = wezterm.nerdfonts.fa_clock_o },
    { Foreground = { Color = nord.nord6 } },
    { Text = date },
    separator,

    { Foreground = { Color = window:leader_is_active() and nord.nord15 or nord.nord1 } },
    { Text = wezterm.nerdfonts.md_keyboard_variant },
  })
end)

-- Tab stuff
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
  font_size = 14.0,
  active_titlebar_bg = nord.nord1,
  inactive_titlebar_bg = nord.nord1,
}

-- Colors
config.color_scheme = 'Nord (Gogh)'
config.colors = {
  visual_bell = nord.nord6,
  compose_cursor = nord.nord15
}
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

-- Key bindings
-- CMD(macOS) or ALT(other)
local mod = os == 'macos' and 'CMD' or 'ALT'

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
  { key = 'n',   mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p',   mods = 'LEADER',       action = wezterm.action.ActivateTabRelative(-1) },
  { key = '}',   mods = 'LEADER',       action = wezterm.action.MoveTabRelative(1) },
  { key = '{',   mods = 'LEADER',       action = wezterm.action.MoveTabRelative(-1) },
  { key = '1',   mods = 'LEADER',       action = wezterm.action.ActivateTab(0) },
  { key = '2',   mods = 'LEADER',       action = wezterm.action.ActivateTab(1) },
  { key = '3',   mods = 'LEADER',       action = wezterm.action.ActivateTab(2) },
  { key = '4',   mods = 'LEADER',       action = wezterm.action.ActivateTab(3) },
  { key = '5',   mods = 'LEADER',       action = wezterm.action.ActivateTab(4) },
  { key = '6',   mods = 'LEADER',       action = wezterm.action.ActivateTab(5) },
  { key = '7',   mods = 'LEADER',       action = wezterm.action.ActivateTab(6) },
  { key = '8',   mods = 'LEADER',       action = wezterm.action.ActivateTab(7) },
  { key = '9',   mods = 'LEADER',       action = wezterm.action.ActivateTab(8) },
  { key = '0',   mods = 'LEADER',       action = wezterm.action.ActivateTab(9) },
  { key = '$',   mods = 'LEADER|SHIFT', action = wezterm.action.ActivateTab(-1) },
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
  { key = 'v',   mods = mod,            action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'c',   mods = mod,            action = wezterm.action.CopyTo    'Clipboard' },
  -- font size
  { key = '+',   mods = mod..'|SHIFT',  action = wezterm.action.IncreaseFontSize },
  { key = '-',   mods = mod,            action = wezterm.action.DecreaseFontSize },
  { key = '0',   mods = mod,            action = wezterm.action.ResetFontSize },
  -- restore some default bindings
  { key = 'p',   mods = 'CTRL|SHIFT',   action = wezterm.action.ActivateCommandPalette },
  { key = 'l',   mods = 'CTRL|SHIFT',   action = wezterm.action.ShowDebugOverlay },
  -- other
  { key = 's',   mods = 'LEADER|SHIFT', action = wezterm.action.ReloadConfiguration },
}

return config
