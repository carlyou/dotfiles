local wezterm = require("wezterm")
local wezterm_open_url = require("wezterm_open_url")

local config = wezterm.config_builder()

config.font = wezterm.font("Monaco Nerd Font", { weight = "Bold" })
--config.dpi = 76
config.font_size = 12
--config.freetype_load_target = "Normal"
--config.freetype_render_target = "HorizontalLcd"
--config.freetype_render_target = "VerticalLcd"

config.enable_tab_bar = false
config.initial_rows = 40
config.initial_cols = 160

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20

-- Change opacity when window loses/gains focus
wezterm.on("window-focus-changed", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if window:is_focused() then
		overrides.window_background_opacity = 0.9
	else
		overrides.window_background_opacity = 0.6
	end
	window:set_config_overrides(overrides)
end)

config.mouse_bindings = {
	-- Disable regular click on hyperlinks (override default behavior)
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.Nop,
	},
	-- Open URLs/files with CMD+Click only
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

config.hyperlink_rules = wezterm_open_url.hyperlink_rules

config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.SendKey({ key = "RightArrow" }),
	},
}

config.color_scheme = "tokyonight_moon"
--config.color_scheme = "Cobalt2"

config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = 0,
}

return config
