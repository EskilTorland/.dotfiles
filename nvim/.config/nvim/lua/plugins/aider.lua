return {
	{
		"joshuavial/aider.nvim",
		config = function()
			-- Set up window size for Aider console
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "AiderConsole",
				callback = function()
					-- Adjust the size to 25% of screen width
					vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.25))
				end,
			})

			require("aider").setup({
				auto_manage_context = true,
				default_bindings = true,
				debug = false,
			})

			-- Set up custom keybinding that opens aider in a vertical split
			vim.api.nvim_set_keymap("n", "<leader>ao", ":AiderOpen<CR>", { noremap = true, silent = true })
		end,
	},
}
