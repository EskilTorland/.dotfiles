return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			"giuxtaposition/blink-cmp-copilot",
		},
		opts = {
			-- I don't find the panel useful.
			panel = { enabled = false },
			suggestion = {
				auto_trigger = true,
				-- Use alt to interact with Copilot.
				keymap = {
					-- Disable the built-in mapping, we'll configure it in nvim-cmp.
					accept = false,
					accept_word = "<M-w>",
					accept_line = "<M-l>",
					next = "<M-n>",
					prev = "<M-p>",
					dismiss = "/",
				},
			},
			filetypes = { markdown = true },
		},
	config = function(_, opts)
		require("copilot").setup(opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuOpen",
			callback = function()
				require("copilot.suggestion").dismiss()
				vim.b.copilot_suggestion_hidden = true
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			pattern = "BlinkCmpMenuClose",
			callback = function()
				vim.b.copilot_suggestion_hidden = false
			end,
		})
	end,
	},
}
