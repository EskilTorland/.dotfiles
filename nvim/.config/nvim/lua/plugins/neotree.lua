--TODO: Remove for oil.nvim
return {
	{

		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
				enable_git_status = true,
				enable_diagnostics = true,
				filesystem = {
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_hidden = false,
					},
					follow_current_file = {
						enabled = true,
					},
					hijack_netrw_behavior = "open_current",
				},
			})
			vim.keymap.set("n", "<leader>pv", ":Neotree position=current toggle<CR>", { silent = true })
		end,
	},
}
