return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>pv", "<cmd>Oil<cr>", desc = "Open Oil", silent = true },
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory", silent = true },
		},
		opts = {
			default_file_explorer = true,
			delete_to_trash = true,
			watch_for_changes = true,
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name)
					return name == ".git" or name == ".DS_Store"
				end,
			},
		},
	},
}
