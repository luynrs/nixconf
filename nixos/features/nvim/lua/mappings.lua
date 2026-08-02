local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("v", "<Tab>", ">>gv", opts)
keymap("v", "<S-Tab>", "<<gv", opts)

keymap({ "n", "v", "o" }, "р", "h", opts)
keymap({ "n", "v", "o" }, "о", "j", opts)
keymap({ "n", "v", "o" }, "л", "k", opts)
keymap({ "n", "v", "o" }, "д", "l", opts)

keymap({ "n", "v", "o" }, "ц", "w", opts)
keymap({ "n", "v", "o" }, "и", "b", opts)

keymap({ "n", "v", "o" }, "ж", "0", opts)
keymap({ "n", "v", "o" }, "э", "$", opts)

keymap({ "n", "v", "o" }, "а", "f", opts)
keymap({ "n", "v", "o" }, "е", "t", opts)

keymap({ "n", "v" }, "с", "c", opts)
keymap({ "n", "v" }, "в", "d", opts)
keymap({ "n", "v" }, "н", "y", opts)

keymap({ "n", "v" }, "з", "p", opts)

keymap("n", "г", "u", opts)
keymap("n", "<C-г>", "<C-r>", opts)

keymap("n", "т", "n", opts)
keymap("n", "Т", "N", opts)