return {
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gread", "Gwrite" },
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
			vim.keymap.set("n", "gb", ":Git blame<CR>", { desc = "Git blame" })
		end,
	},
}
