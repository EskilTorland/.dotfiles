require("copilot").setup({
	suggestion = {
		auto_trigger = true,
	},
})
vim.keymap.set("i", "<C-l>", "<Cmd>Copilot suggestion accept<CR>", { silent = true })
