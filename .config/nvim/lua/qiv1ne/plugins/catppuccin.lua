return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	integrations = {
		treesitter = true,
		mini = {
			enabled = true,
			indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
		},
		dashboard = true,
		gitsigns = true,
		mason = true,
		cmp = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
				ok = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
				ok = { "underline" },
			},
			inlay_hints = {
				background = true,
			},
		},
		telescope = {
			enabled = true,
			-- style = "nvchad"
		},
		lsp_trouble = true,
		which_key = true,
	},
}
