local wezterm = require 'wezterm'
local config = wezterm.config_builder()

function table.merge(to, from)
  for _, v in ipairs(from) do
     table.insert(to, v)
  end
  return to
end

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

local format_status = function(icon_name, icon_color, status_text)
  return {
    { Foreground = { Color = icon_color } },
    { Text = ' ' .. wezterm.nerdfonts[icon_name] },
    { Foreground = { Color = nord.nord6 } },
    { Text = ' ' .. status_text },
  }
end

local spacer = function()
  return {
    { Text = ' ' }
  }
end

local read_command_output = function(command)
  local process = io.popen(command)
  return process:read("*a")
end

local volume_status = function()
  if os ~= "macos" then
    return {}
  end

  local content = read_command_output("osascript -e 'get volume settings'")

  local _, _, volume = string.find(content, "output volume:(%d+)")
  volume = tonumber(volume)
  local _, _, muted = string.find(content, "output muted:(%S+)")
  muted = muted == "true"

  local icon

  if muted then
    icon = "md_volume_variant_off"
  else
    if volume < 34 then
      icon = "md_volume_low"
    elseif volume < 68 then
      icon = "md_volume_medium"
    else
      icon = "md_volume_high"
    end
  end
  return format_status(icon, muted and nord.nord4 or nord.nord14, muted and "" or volume)
end

local wifi_status = function()
  if os ~= "macos" then
    return {}
  end

  local content = read_command_output("/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I")

  local off = string.find(content, "AirPort: Off")
  if off then
    return format_status('fa_wifi', nord.nord4, "---")
  end

  local _, _, strength = string.find(content, "agrCtlRSSI: (-%d+)")
  strength = tonumber(strength)
  local _, _, ssid = string.find(content, " SSID: (%S+)")
  return format_status('fa_wifi', nord.nord7, ssid)
end

local battery_status = function()
  if os ~= "macos" then
    return {}
  end

  local icon = "md_battery"

  local content = read_command_output("pmset -g ps")
  local _, _, percentage = string.find(content, "(%d+)%%")
  percentage = tonumber(percentage)
  icon = charging_state ~= "discharging" and icon .. "_charging" or icon
  local _, _, charging_state = string.find(content, "; +(.+charg%S+);")
  icon = percentage < 100 and icon .. "_" .. math.floor(percentage / 10) .. "0" or icon

  return format_status(icon, nord.nord13, percentage .. "%")
end

local load_average_status = function()
  if os == "macos" then
    local content = read_command_output("/usr/sbin/sysctl -n vm.loadavg")
    local _, _, min1, _, _ = string.find(content, "%{ (%d+%.%d+) (%d+%.%d+) (%d+%.%d+) %}")
    local content = read_command_output("/usr/sbin/sysctl -n hw.ncpu")
    local ncpu = tonumber(content)

    local la = tonumber(min1) / ncpu
    if la < 0.1 then
      icon = "md_speedometer"
    elseif la < 0.3 then
      icon = "md_speedometer_medium"
    else
      icon = "md_speedometer_slow"
    end

    return format_status(icon, nord.nord12, min1)
  end
end

local clock_status = function()
  return format_status("fa_calendar", nord.nord9, wezterm.strftime '%Y/%m/%d %H:%M:%S')
end

local leader_status = function(window)
  return format_status("md_keyboard_variant", window:leader_is_active() and nord.nord15 or nord.nord1, "")
end

wezterm.on('update-right-status', function(window, pane)
  status = {}

  table.merge(status, wifi_status())
  table.merge(status, spacer())
  table.merge(status, volume_status())
  table.merge(status, spacer())
  table.merge(status, battery_status())
  table.merge(status, spacer())
  table.merge(status, load_average_status())
  table.merge(status, spacer())
  table.merge(status, clock_status())
  table.merge(status, spacer())
  table.merge(status, leader_status(window))

  window:set_right_status(wezterm.format(status))
end)

-- Tab stuff
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
  font_size = 16.0,
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
