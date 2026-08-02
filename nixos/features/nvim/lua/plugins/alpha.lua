local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local header = {
	"                      ,",
	" ,-.       _,---._ __  / \\",
	"/  )    .-'       `./ /   \\",
	"(  (   ,'            `/    /|",
	" \\  `-\"             \\ '\\  / |",
	"  `.              ,  \\ \\ /  |",
	"   /`.          ,'-`----Y   |",
	"  (            ;        |   '",
	"  |  ,-.    ,-'         |  /",
	"  |  | (   |    luynar  | /",
	"  )  |  \\  `.___________|/",
	"  `--'   `--'",
}

local buttons = {
	dashboard.button("f", "󰷊  Find file", ":Telescope find_files<CR>"),
	dashboard.button("r", "󰤘  Recent files", ":Telescope oldfiles<CR>"),
	dashboard.button("n", "󰝒  New file", ":ene<CR>"),
}

local date = {
	type = "text",
	val = "  " .. os.date("%A, %d %B %Y"),
	opts = { position = "center", hl = "Comment" },
}

local quit = {
	type = "group",
	val = { dashboard.button("q", "  Quit", ":qa<CR>") },
	opts = { position = "center" },
}

dashboard.section.header.val = header
dashboard.section.header.opts = { position = "center", hl = "Type" }

dashboard.section.buttons.val = buttons
dashboard.section.buttons.opts = { position = "center", spacing = 0 }

local function centered_layout()
	local layout = {
		dashboard.section.header,
		{ type = "padding", val = 1 },
		date,
		{ type = "padding", val = 1 },
		dashboard.section.buttons,
		{ type = "padding", val = 1 },
		quit,
	}

	local h = vim.fn.winheight(0)
	local content = #header + #buttons + 5
	local top = math.max(0, math.floor((h - content) / 2))

	table.insert(layout, 1, { type = "padding", val = top })
	return layout
end

alpha.setup({ layout = centered_layout() })
