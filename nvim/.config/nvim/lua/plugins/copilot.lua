return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			"giuxtaposition/blink-cmp-copilot",
		},
		opts = {
			panel = { enabled = false },
			-- suggestion = {
			-- 	auto_trigger = true,
			-- 	keymap = {
			-- 		accept = false,
			-- 		accept_word = "<M-w>",
			-- 		accept_line = "<M-l>",
			-- 		next = "<M-n>",
			-- 		prev = "<M-p>",
			-- 		dismiss = "/",
			-- 	},
			-- },
			suggestion = { enabled = false },
			filetypes = { markdown = true },
		},
	config = function(_, opts)
		require("copilot").setup(opts)

		-- vim.api.nvim_create_autocmd("User", {
		-- 	pattern = "BlinkCmpMenuOpen",
		-- 	callback = function()
		-- 		require("copilot.suggestion").dismiss()
		-- 		vim.b.copilot_suggestion_hidden = true
		-- 	end,
		-- })
		-- vim.api.nvim_create_autocmd("User", {
		-- 	pattern = "BlinkCmpMenuClose",
		-- 	callback = function()
		-- 		vim.b.copilot_suggestion_hidden = false
		-- 	end,
		-- })
	end,
	},
}
