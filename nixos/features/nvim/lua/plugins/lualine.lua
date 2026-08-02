require("lualine").setup({
	options = {
		theme = "auto",
		globalstatus = true,
		section_separators = { left = "", right = "" },
		component_separators = "",
	},
	sections = {
		lualine_a = {
			{
				function()
					return ""
				end,
				padding = { left = 1, right = 1 },
			},
			{ "mode" },
		},
		lualine_b = { "branch", "diff" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "diagnostics" },
		lualine_y = { "filetype" },
		lualine_z = { "location" },
	},
})
