-- Pull in the wezterm API
local wezterm = require 'wezterm'


-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = 'Catppuccin Frappe'
config.window_padding = {
	left = 2,
	right = 2,
	top = 2,
	bottom = 2,
}
config.scrollback_lines = 3500
config.enable_scroll_bar = true
config.window_background_opacity = 0.85
config.font = wezterm.font("Fira Code")
config.font_size = 12.0
config.harfbuzz_features = { "zero", "ss01", "cv05" }
config.use_fancy_tab_bar = false
config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"
config.disable_default_key_bindings = true
config.keys = {
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action { PasteFrom = "Clipboard" } },
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action { CopyTo = "Clipboard" } },
	{ key = "=", mods = "CTRL",       action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL",       action = wezterm.action.DecreaseFontSize },
	{
		key = 'F11',
		action = wezterm.action.ToggleFullScreen,
	},
}
config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = '\\((\\w+://\\S+)\\)',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = '\\[(\\w+://\\S+)\\]',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = '\\{(\\w+://\\S+)\\}',
		format = '$1',
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = '<(\\w+://\\S+)>',
		format = '$1',
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		-- Before
		--regex = '\\b\\w+://\\S+[)/a-zA-Z0-9-]+',
		--format = '$0',
		-- After
		regex = '[^(]\\b(\\w+://\\S+[)/a-zA-Z0-9-]+)',
		format = '$1',
		highlight = 1,
	},
	-- implicit mailto link
	{
		regex = '\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b',
		format = 'mailto:$0',
	},
}
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://github.com/$1/$3",
})
return config
