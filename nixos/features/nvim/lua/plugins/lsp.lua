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

local caps = require("cmp_nvim_lsp").default_capabilities()
for _, s in ipairs(servers) do
	vim.lsp.config(s, { capabilities = caps })
	vim.lsp.enable(s)
end

local cmp = require("cmp")
local snip = require("luasnip")

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.pumheight = 10

cmp.setup({
	preselect = cmp.PreselectMode.None,
	performance = { max_view_entries = 10 },

	snippet = { expand = function(a) snip.lsp_expand(a.body) end },

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
		["<Tab>"] = function(f)
			if cmp.visible() then
				cmp.select_next_item()
			elseif snip.expand_or_jumpable() then
				snip.expand_or_jump()
			else
				f()
			end
		end,
		["<S-Tab>"] = function(f)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif snip.jumpable(-1) then
				snip.jump(-1)
			else
				f()
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

local ok, ap = pcall(require, "nvim-autopairs.completion.cmp")
if ok then
	cmp.event:on("confirm_done", ap.on_confirm_done())
end
