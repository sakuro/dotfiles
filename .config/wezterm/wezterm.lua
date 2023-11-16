local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Nord (Gogh)'

config.font = wezterm.font('Cica')
config.font_size = 24.0

config.window_background_opacity = 0.94

config.audible_bell = 'Disabled'
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 50,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 50
}
config.colors = { visual_bell = '#ffffff' }

config.leader = { key = 't', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    { key = 't', mods = 'LEADER|CTRL',  action = wezterm.action.SendKey { key = 't', mods = 'CTRL' } },
    { key = '|', mods = 'LEADER|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '-', mods = 'LEADER',       action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'h', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'j', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER',       action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'l',  mods = 'LEADER',      action = wezterm.action.ActivatePaneDirection 'Right' },
}

return config
