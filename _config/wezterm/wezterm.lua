local wezterm = require("wezterm")
local wezterm_open_url = require("wezterm_open_url")

local config = wezterm.config_builder()
local act = wezterm.action

config.font = wezterm.font("Monaco Nerd Font", { weight = "Bold" })
--config.dpi = 76
if wezterm.target_triple:find("linux") then
	config.font_size = 10
else
	config.font_size = 12
end
--config.freetype_load_target = "Normal"
--config.freetype_render_target = "HorizontalLcd"
--config.freetype_render_target = "VerticalLcd"

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false -- Use integrated title bar

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#222436"
	local foreground = "#c8d3f5"

	if tab.is_active then
		background = "#82aaff"
		foreground = "#1e2030"
	elseif hover then
		background = "#2d3f76"
		foreground = "#c8d3f5"
	else
		background = "#1e2030"
		foreground = "#828bb8"
	end

	local text = tab.active_pane.title
	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. text .. " " },
	}
end)

config.initial_rows = 40
config.initial_cols = 160

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.9
config.macos_window_background_blur = 20
config.inactive_pane_hsb = {
	saturation = 0.5,
	brightness = 0.7,
}

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
		action = act.SendKey({ key = "RightArrow" }),
	},
	{
		key = "=",
		mods = "CTRL",
		action = act.SendKey({ key = "=", mods = "CTRL" }),
	},
	{
		key = "-",
		mods = "CTRL",
		action = act.SendKey({ key = "-", mods = "CTRL" }),
	},
	{
		key = "|",
		mods = "CTRL|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "_",
		mods = "CTRL|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "x",
		mods = "CTRL|SHIFT",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
	{
		key = "[",
		mods = "CTRL|SHIFT",
		action = act.ActivateCopyMode,
	},
	{
		key = "9",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
}

local copy_mode = wezterm.gui.default_key_tables().copy_mode
table.insert(copy_mode, {
	key = "y",
	mods = "NONE",
	action = act.Multiple({
		act.CopyTo("ClipboardAndPrimarySelection"),
		act.CopyMode("Close"),
	}),
})
table.insert(copy_mode, {
	key = "y",
	mods = "SHIFT",
	action = act.Multiple({
		-- select cursor line
		act.SelectTextAtMouseCursor("Line"),
		act.CopyTo("ClipboardAndPrimarySelection"),
		act.CopyMode("Close"),
	}),
})
config.key_tables = {
	copy_mode = copy_mode,
}

--config.color_scheme = "Solarized Light (Gogh)"
config.color_scheme = "Tokyo Night Moon"
--config.color_scheme = "Cobalt2"

config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = 0,
}

return config
