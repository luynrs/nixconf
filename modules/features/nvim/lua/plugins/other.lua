local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		prompt_prefix = " > ",
		selection_caret = "> ",
		entry_prefix = "  ",
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				prompt_position = "top",
			},
			width = 0.90,
			height = 0.85,
		},
		path_display = { "filename_first", "truncate" },
		winblend = 0,
		border = true,
		preview = false,
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
			},
			n = {
				["q"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
		live_grep = {
			additional_args = function()
				return { "--hidden" }
			end,
		},
	},
})

vim.api.nvim_set_hl(0, "TelescopeNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "TelescopePromptNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "TelescopeResultsNormal", { link = "NormalFloat" })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { link = "FloatBorder" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { reverse = true })
vim.api.nvim_set_hl(0, "TelescopeMatching", { bold = false, italic = false })

local k = vim.keymap.set
k("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
k("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
k("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")
k("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

require("nvim-treesitter").setup({
	highlight = { enable = true },
	indent = { enable = true },
})

require("plugins.lsp")
