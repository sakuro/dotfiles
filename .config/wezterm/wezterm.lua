-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Nord (Gogh)'

config.font = wezterm.font('Cica')
config.font_size = 24

config.window_background_opacity = 0.9

return config
