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
config.macos_window_background_blur = 50
config.inactive_pane_hsb = {
	saturation = 0.7,
	brightness = 0.7,
}

-- Change opacity when window loses/gains focus
wezterm.on("window-focus-changed", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if window:is_focused() then
		overrides.window_background_opacity = 0.9
	else
		overrides.window_background_opacity = 0.8
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
		key = "u",
		mods = "CTRL|SHIFT",
		action = act.SendKey({ key = "PageUp" }),
	},
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = act.SendKey({ key = "PageDown" }),
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
		act.CopyMode("ClearSelectionMode"),
	}),
})
table.insert(copy_mode, {
	key = "y",
	mods = "SHIFT",
	action = act.Multiple({
		-- select cursor line
		act.SelectTextAtMouseCursor("Line"),
		act.CopyTo("ClipboardAndPrimarySelection"),
		act.CopyMode("ClearSelectionMode"),
	}),
})
-- Jump between shell prompts/outputs (semantic zones) like vim's { and }.
-- Requires shell integration (OSC 133) to be active in your shell.
table.insert(copy_mode, {
	key = "{",
	mods = "SHIFT",
	action = act.CopyMode("MoveBackwardSemanticZone"),
})
table.insert(copy_mode, {
	key = "}",
	mods = "SHIFT",
	action = act.CopyMode("MoveForwardSemanticZone"),
})
-- Vim-style search: / to start, n/N to cycle matches from copy mode.
-- Start case-insensitive (vim-ish); Ctrl+R cycles case-sensitive/regex.
table.insert(copy_mode, {
	key = "/",
	mods = "NONE",
	action = act.Search({ CaseInSensitiveString = "" }),
})
table.insert(copy_mode, {
	key = "n",
	mods = "NONE",
	action = act.CopyMode("NextMatch"),
})
table.insert(copy_mode, {
	key = "N",
	mods = "SHIFT",
	action = act.CopyMode("PriorMatch"),
})

-- i exits copy mode (vim: normal -> insert; here, back to the live terminal).
table.insert(copy_mode, {
	key = "i",
	mods = "NONE",
	action = act.CopyMode("Close"),
})

-- Vim-style Esc: clear search highlights / selection but stay in copy mode.
-- Use i or Ctrl+C to actually exit copy mode. (Overrides the default Close;
-- later bindings for the same key win.)
table.insert(copy_mode, {
	key = "Escape",
	mods = "NONE",
	action = act.Multiple({
		act.CopyMode("ClearPattern"),
		act.CopyMode("ClearSelectionMode"),
	}),
})

-- search_mode tweaks (appended overrides; last binding for a key wins):
--   Enter  -> commit the pattern and drop back to copy-mode navigation
--             (default jumps to prior match while staying in search).
--   Escape -> cancel the search and return to copy mode, without exiting it
--             (default Close exits copy mode entirely).
local search_mode = wezterm.gui.default_key_tables().search_mode
table.insert(search_mode, {
	key = "Enter",
	mods = "NONE",
	action = act.CopyMode("AcceptPattern"),
})
table.insert(search_mode, {
	key = "Escape",
	mods = "NONE",
	action = act.Multiple({
		act.CopyMode("ClearPattern"),
		act.CopyMode("AcceptPattern"),
	}),
})
config.key_tables = {
	copy_mode = copy_mode,
	search_mode = search_mode,
}

config.color_scheme = "Tokyo Night Moon"
--config.color_scheme = "Cobalt2"
--config.color_scheme = "Rosé Pine Moon (Gogh)"
--config.color_scheme = "Rosé Pine Dawn (Gogh)"
--config.color_scheme = "Everforest Light (Gogh)"
--config.color_scheme = "Everforest (Gogh)"

config.window_padding = {
	left = "0.5cell",
	right = "0.5cell",
	top = "0.5cell",
	bottom = 0,
}

return config
