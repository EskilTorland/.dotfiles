require("trouble").setup({
	modes = {
		preview_float = {
			mode = "diagnostics",
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				position = { 0, -2 },
				size = { width = 0.3, height = 0.3 },
				zindex = 200,
			},
		},
		test = {
			mode = "diagnostics",
			preview = {
				type = "split",
				relative = "win",
				position = "right",
				size = 0.3,
			},
		},
	},
})
--vim.keymap.set("n", "<leader>t", "<cmd>Trouble diagnostics toggle<cr>", { silent = true })
vim.keymap.set("n", "<leader>t", function()
	require("trouble").toggle({ mode = "preview_float" })
end, { silent = true, desc = "Toggle Trouble diagnostics" })
