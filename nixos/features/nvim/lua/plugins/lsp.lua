local servers = {
	"lua_ls",
	"ts_ls",
	"pyright",
	"rust_analyzer",
	"clangd",
	"jsonls",
	"html",
	"cssls",
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()
for _, server in ipairs(servers) do
	vim.lsp.config(server, { capabilities = capabilities })
	vim.lsp.enable(server)
end

local cmp = require("cmp")
local snippets = require("luasnip")

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10

cmp.setup({
	preselect = cmp.PreselectMode.None,
	performance = { max_view_entries = 10 },

	snippet = {
		expand = function(args)
			snippets.lsp_expand(args.body)
		end,
	},

	window = {
		completion = cmp.config.window.bordered({ scrollbar = false, max_height = 10, max_width = 48 }),
		documentation = cmp.config.window.bordered({ max_height = 12, max_width = 60 }),
	},

	formatting = {
		fields = { "kind", "abbr" },
		format = require("lspkind").cmp_format({
			mode = "symbol",
			maxwidth = 48,
			ellipsis_char = "…",
		}),
	},

	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif snippets.expand_or_jumpable() then
				snippets.expand_or_jump()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif snippets.jumpable(-1) then
				snippets.jump(-1)
			else
				fallback()
			end
		end,
	}),

	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer", keyword_length = 3 },
	},
})

require("lazydev").setup()

require("nvim-autopairs").setup({ check_ts = true })

cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
