-- References:
-- https://wezterm.org/config/lua/config/hyperlink_rules.html
-- https://gist.github.com/letieu/ac0034c2452ef41f967eca3cca44bc08

local wezterm = require("wezterm")
local server_id_file = "/tmp/nvim-focuslost"

wezterm.on("open-uri", function(window, pane, uri)
	-- Get current working directory
	local cwd = pane:get_current_working_dir()
	local cwd_path = cwd and cwd.file_path or os.getenv("HOME")

	-- Resolve relative paths to absolute paths
	local resolved_uri = uri
	if uri:match("^~/") then
		-- Expand ~ to home directory
		resolved_uri = os.getenv("HOME") .. uri:sub(2)
	elseif uri:match("^%./") then
		-- Resolve ./ relative to current working directory
		resolved_uri = cwd_path .. "/" .. uri:sub(3)
	elseif uri:match("^%.%./") then
		-- Resolve ../ relative to parent of current working directory
		local parent_dir = cwd_path:match("^(.*)/[^/]+$") or cwd_path
		resolved_uri = parent_dir .. "/" .. uri:sub(4)
	elseif not uri:match("^/") and not uri:match("^https?://") and not uri:match("^file://") then
		-- Relative path without ./ prefix - resolve relative to cwd
		resolved_uri = cwd_path .. "/" .. uri
	end

	-- Check if URI has line number and handle accordingly
	local line_number = resolved_uri:match(":(%d+)$")
	if line_number then
		-- Remove line number from path for file operations
		local file_path = resolved_uri:gsub(":(%d+)$", "")
		-- Open with vim at specific line
		wezterm.run_child_process({ "/opt/homebrew/bin/neovide", "--fork", "+" .. line_number, file_path })
	else
		-- Open normally with system default
		wezterm.run_child_process({ "open", resolved_uri })
	end
	--wezterm.run_child_process({ "/opt/homebrew/bin/neovide", "--fork", full_path })
	return false
end)

hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(hyperlink_rules, {
	regex = "\\bfile://\\S*\\b",
	format = "$0",
})

-- File paths with extensions (including line numbers)
table.insert(hyperlink_rules, {
	regex = "[~./]?[A-Za-z0-9._/-]+\\.[A-Za-z0-9]+(:\\d+)*",
	format = "$0",
})

-- Absolute paths
table.insert(hyperlink_rules, {
	regex = "/[A-Za-z0-9._/-]+",
	format = "$0",
})

-- Home directory paths
table.insert(hyperlink_rules, {
	regex = "~/[A-Za-z0-9._/-]+",
	format = "$0",
})

return {
	hyperlink_rules = hyperlink_rules,
}
