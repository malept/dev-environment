local wezterm = require("wezterm")

return {
	automatically_reload_config = true,
	color_scheme = "Gruvbox Dark",
	font = wezterm.font_with_fallback({
		"Fira Code",
		"Symbols Nerd Font Mono",
	}),
	font_size = 10.0,
	launch_menu = {
		{
			args = { "htop" },
		},
		{
			label = "Nushell",
			args = { "nu", "--login" },
		},
	},
	term = "wezterm",
}
