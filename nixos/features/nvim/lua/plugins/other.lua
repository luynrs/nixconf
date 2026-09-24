local telescope = require("telescope")
local actions = require("telescope.actions")
local tree = require("nvim-tree")
local tree_api = require("nvim-tree.api")

tree.setup({
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
		highlight_git = "name",
	},
	filters = {
		dotfiles = false,
	},
	actions = {
		open_file = {
			quit_on_open = false,
			resize_window = false,
		},
	},
	update_focused_file = {
		enable = true,
		update_root = true,
	},
})

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
k("n", "<leader>e", function()
	if tree_api.tree.is_visible() then
		tree_api.tree.close()
	else
		tree_api.tree.open()
	end
end)
k("n", "<leader>E", function()
	tree_api.tree.find_file({ open = true, focus = true })
end)
k("n", "<leader>bb", "<cmd>buffer #<cr>")
k("n", "<leader>bd", "<cmd>bdelete<cr>")
k("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
k("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
k("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")
k("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"bash",
		"sh",
		"c",
		"cpp",
		"css",
		"go",
		"html",
		"javascript",
		"javascriptreact",
		"json",
		"lua",
		"markdown",
		"nix",
		"python",
		"rust",
		"toml",
		"typescript",
		"typescriptreact",
		"vim",
		"help",
		"yaml",
	},
	callback = function()
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

require("plugins.lsp")
