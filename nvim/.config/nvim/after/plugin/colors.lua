function ColorMyPencils(color)
	color = color or "gruvbox-material"
	--	color = color or "tokyonight"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	vim.api.nvim_set_hl(0, "@comment.todo.comment", { fg = "#FFC0CB", bg = "none" })
end

ColorMyPencils()
