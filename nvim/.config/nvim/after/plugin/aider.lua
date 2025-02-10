require("aider").setup({
	vim = true,
	-- only necessary if you want to change the default keybindings. <Leader>C is not a particularly good choice. It's just shown as an example.
	vim.api.nvim_set_keymap("n", "<leader>a", ":AiderOpen --no-auto-commits<CR>", { noremap = true, silent = true }),
})
