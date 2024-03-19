local wezterm = require 'wezterm'
local config = wezterm.config_builder()

function table.merge(to, from)
  for _, v in ipairs(from) do
     table.insert(to, v)
  end
  return to
end

function collect_vpn_service_names()
  if wezterm.GLOBAL.os ~= "macos" then
    return {}
  end
  local service_names = {}
  local _success, stdout, _stderr = wezterm.run_child_process {"/usr/sbin/scutil", "--nc", "list"}
  local lines = wezterm.split_by_newlines(stdout)
  for _, l in ipairs(lines) do
    local _from, _to, service_name = string.find(l, '"(%S+)"')
    if service_name then
      table.insert(service_names, service_name)
    end
  end
  return service_names
end

wezterm.GLOBAL.os = wezterm.GLOBAL.os or
  string.find(wezterm.target_triple, '-windows-') and 'windows' or
  string.find(wezterm.target_triple, '-apple-') and 'macos' or
  string.find(wezterm.target_triple, '-linux-') and 'linux' or
  error('Unsupported Operating System')

if wezterm.GLOBAL.os == 'windows' then
  config.default_domain = 'WSL:Ubuntu-22.04'
end

if wezterm.GLOBAL.os == 'macos' then
  local _success, stdout, _stderr = wezterm.run_child_process {"/usr/sbin/sysctl",  "-n",  "hw.ncpu"}
  wezterm.GLOBAL.ncpu = tonumber(stdout)
end

-- https://www.nordtheme.com/docs/colors-and-palettes
wezterm.GLOBAL.nord = wezterm.GLOBAL.nord or {
  -- polar night
  nord0 = '#2E3440', nord1 = '#3B4252', nord2 = '#434C5E', nord3 = '#4C566A',
  -- snow storm
  nord4 = '#D8DEE9', nord5 = '#E5E9F0', nord6 = '#ECEFF4',
  -- frost
  nord7 = '#8FBCBB', nord8 = '#88C0D0', nord9 = '#81A1C1', nord10 = '#5E81AC',
  -- aurora
  nord11 = '#BF616A', nord12 = '#D08770', nord13 = '#EBCB8B', nord14 = '#A3BE8C', nord15 = '#B48EAD',
}

wezterm.GLOBAL.vpn_service_names = wezterm.GLOBAL.vpn_service_names or collect_vpn_service_names()

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local process_name = pane.user_vars.WEZTERM_PROG or ""
  local background_color = tab.is_active and wezterm.GLOBAL.nord.nord8 or wezterm.GLOBAL.nord.nord9

  return {
    { Background = { Color = background_color } },
    { Foreground = { Color = wezterm.GLOBAL.nord.nord6 } },
    { Text = process_name },
  }
end)

local format_status = function(icon_name, icon_color, status_text)
  return {
    { Foreground = { Color = icon_color } },
    { Text = ' ' .. wezterm.nerdfonts[icon_name] },
    { Foreground = { Color = wezterm.GLOBAL.nord.nord6 } },
    { Text = ' ' .. status_text },
  }
end

local volume_status = function()
  if wezterm.GLOBAL.os ~= "macos" then
    return {}
  end

  local _success, stdout, _stderr = wezterm.run_child_process {"osascript", "-e", "get volume settings"}

  local _, _, volume = string.find(stdout, "output volume:(%d+)")
  volume = tonumber(volume)
  local _, _, muted = string.find(stdout, "output muted:(%S+)")
  muted = muted == "true"

  local icon, icon_color, status_text

  if muted then
    icon = "md_volume_variant_off"
    icon_color = wezterm.GLOBAL.nord.nord4
    status_text = ""
  else
    if volume < 1 * (100/3) then
      icon = "md_volume_low"
    elseif volume < 2 * (100/3) then
      icon = "md_volume_medium"
    else
      icon = "md_volume_high"
    end
    icon_color = wezterm.GLOBAL.nord.nord14
    status_text = volume
  end
  return format_status(icon, icon_color, status_text)
end

local wifi_status = function()
  if wezterm.GLOBAL.os ~= "macos" then
    return {}
  end

  local _success, stdout, _stderr = wezterm.run_child_process {"sudo",  "wdutil", "info"}

  local wifi = string.find(stdout, "WIFI")
  if not wifi then
    return {}
  end

  local off = string.find(stdout, "Power%s-:%s-Off", wifi)
  if off then
    return format_status('fa_wifi', wezterm.GLOBAL.nord.nord4, "---")
  end

  local _, _, strength = string.find(stdout, "RSSI.-: (-%d+) dBm", wifi)
  strength = tonumber(strength)
  local _, _, ssid = string.find(stdout, "SSID.-: ([^\n]+)", wifi)
  return format_status('fa_wifi', wezterm.GLOBAL.nord.nord7, ssid)
end

local battery_status = function()
  if wezterm.GLOBAL.os ~= "macos" then
    return {}
  end

  local battery_info = wezterm.battery_info()
  if #battery_info == 0 then
    return
  end
  battery_info = battery_info[1]
  local percentage = battery_info.state_of_charge * 100

  local icon
  local state = battery_info.state -- "Charging", "Discharging", "Empty", "Full", "Unknown"
  if state == "Charging" then
    icon = percentage < 100 and "md_battery_charging_" .. math.floor(percentage / 10) .. "0" or "md_battery_charging"
  elseif state == "Empty" then
    icon = "md_battery_outline"
  elseif state == "Full" then
    icon = "md_battery"
  elseif state == "Discharging" or "Unknown" then
    icon = percentage < 100 and "md_battery_" .. math.floor(percentage / 10) .. "0" or "md_battery"
  end

  return format_status(icon, wezterm.GLOBAL.nord.nord13, string.format("%.1f%%", percentage))
end

local load_average_status = function()
  if wezterm.GLOBAL.os == "macos" then
    local _success, stdout, _stderr = wezterm.run_child_process {"/usr/sbin/sysctl", "-n", "vm.loadavg"}
    local _, _, min1, _, _ = string.find(stdout, "%{ (%d+%.%d+) (%d+%.%d+) (%d+%.%d+) %}")

    local la = tonumber(min1) / wezterm.GLOBAL.ncpu
    if la < 1 then
      icon = "md_speedometer"
    elseif la < 2 then
      icon = "md_speedometer_medium"
    else
      icon = "md_speedometer_slow"
    end

    return format_status(icon, wezterm.GLOBAL.nord.nord12, string.format("%.2f", la))
  else
    return {}
  end
end

local clock_status = function()
  return format_status("fa_calendar", wezterm.GLOBAL.nord.nord9, wezterm.strftime '%Y/%m/%d %H:%M:%S')
end

local leader_status = function(window)
  local color = window:leader_is_active() and wezterm.GLOBAL.nord.nord15 or wezterm.GLOBAL.nord.nord4
  return format_status("md_keyboard_variant", color, "")
end

local vpn_status = function(service_name)
  local _success, stdout, _stderr = wezterm.run_child_process {"/usr/sbin/scutil", "--nc", "status", service_name}
  local _from, _to, status = string.find(stdout, "^([A-Z][a-z]+)")

  if status == "Connected" then
    return format_status("md_lock", wezterm.GLOBAL.nord.nord12, service_name)
  else
    return {}
  end
end

wezterm.on('update-right-status', function(window, pane)
  local status = {}
  local spacer = { { Text = ' ' } }

  local add_status = function(add)
    if #status == 0 then
      table.merge(status, { { Background = { Color = wezterm.GLOBAL.nord.nord1 } } })
    else
      table.merge(status, spacer)
    end
    table.merge(status, add)
  end

  if #wezterm.GLOBAL.vpn_service_names > 0 then
    for _, service_name in ipairs(wezterm.GLOBAL.vpn_service_names) do
      add_status(vpn_status(service_name))
    end
  end

  add_status(wifi_status())
  add_status(volume_status())
  add_status(battery_status())
  add_status(load_average_status())
  add_status(clock_status())
  add_status(leader_status(window))

  window:set_right_status(wezterm.format(status))
end)

-- Tab stuff
config.show_new_tab_button_in_tab_bar = false
config.window_frame = {
  font_size = 16.0,
  active_titlebar_bg = wezterm.GLOBAL.nord.nord1,
  inactive_titlebar_bg = wezterm.GLOBAL.nord.nord1,
}

-- Colors
config.color_scheme = 'Nord (Gogh)'
config.colors = {
  visual_bell = wezterm.GLOBAL.nord.nord6,
  compose_cursor = wezterm.GLOBAL.nord.nord15,
  tab_bar = {
    background = wezterm.GLOBAL.nord.nord1
  }
}
config.window_background_opacity = 0.94
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.5,
}

-- Font
config.font = wezterm.font('Cica')
config.font_size = 20.0

-- Bell
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 50,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 50
}

-- Key bindings
config.disable_default_key_bindings = true
-- leader is a WezTerm's term used for so-called prefix key
config.leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 1000 }

local MoveToNewTab = wezterm.action_callback(function(window, pane)
  local tab, window = pane:move_to_new_tab()
  tab:activate()
end)

local copyPasteMods
if wezterm.GLOBAL.os == 'macos' then
  copyPasteMods = 'CMD'
else
  copyPasteMods = 'CTRL|SHIFT'
end

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
  { key = '$',   mods = 'LEADER',       action = wezterm.action.ActivateTab(-1) },
  -- pane management
  { key = '|',   mods = 'LEADER',       action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
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
  { key = 'v',   mods = copyPasteMods,  action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'c',   mods = copyPasteMods,  action = wezterm.action.CopyTo    'Clipboard' },
  -- font size
  { key = ']',   mods = 'LEADER|CTRL',  action = wezterm.action.IncreaseFontSize },
  { key = '[',   mods = 'LEADER|CTRL',  action = wezterm.action.DecreaseFontSize },
  { key = '=',   mods = 'LEADER|CTRL',  action = wezterm.action.ResetFontSize },
  -- restore some default bindings
  { key = 'P',   mods = 'CTRL',         action = wezterm.action.ActivateCommandPalette },
  { key = 'L',   mods = 'CTRL',         action = wezterm.action.ShowDebugOverlay },
  -- other
  { key = 'S',   mods = 'LEADER',       action = wezterm.action.ReloadConfiguration },
}

return config
