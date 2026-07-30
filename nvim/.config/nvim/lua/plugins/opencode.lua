return {
	{
		"sudo-tee/opencode.nvim",
		event = "VeryLazy",
		config = function()
			require("opencode").setup({
				default_mode = "plan",
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
				opts = {
					anti_conceal = { enabled = false },
					file_types = { "markdown", "opencode_output" },
					code = {
						language_border = " ",
					},
				},
				ft = { "markdown", "opencode_output" },
			},
			"saghen/blink.cmp",
			"folke/snacks.nvim",
		},
	},
}
