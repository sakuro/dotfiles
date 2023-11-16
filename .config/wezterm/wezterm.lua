-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Nord (Gogh)'

config.font = wezterm.font('Cica')
config.font_size = 24.0

config.window_background_opacity = 0.9
config.enable_tab_bar = false

config.audible_bell = 'Disabled'
config.visual_bell = {
    fade_in_function = 'EaseIn',
    fade_in_duration_ms = 50,
    fade_out_function = 'EaseOut',
    fade_out_duration_ms = 50
}
config.colors = {
    visual_bell = '#ffffff'
}

return config
