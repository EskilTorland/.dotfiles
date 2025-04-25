return {
	{
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		config = function()
			require("claude-code").setup({
				window = {
					position = "vertical", -- Make Claude use a vertical split
					split_ratio = 0.3, -- Width ratio for the vertical split
				},
				keymaps = {
					toggle = {
						normal = "<leader>ac", -- Leader+ac in normal mode
						terminal = "<C-,>", -- Ctrl+comma in terminal mode
					},
					window_navigation = true, -- Enable window navigation keymaps
					scrolling = true, -- Enable scrolling keymaps
				},
			})
		end,
	},
}
