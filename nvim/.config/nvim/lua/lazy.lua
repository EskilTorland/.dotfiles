local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup({
	-- -- Editing Support
	-- {
	-- 	"windwp/nvim-autopairs",
	-- 	event = "InsertEnter",
	-- 	config = true,
	-- },
	-- {
	-- 	"L3MON4D3/LuaSnip",
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 		"rafamadriz/friendly-snippets",
	-- 	},
	-- },
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	event = "InsertEnter",
	-- },
	--
	-- {
	-- 	"folke/snacks.nvim",
	-- 	priority = 1000,
	-- 	lazy = false,
	-- },

	spec = { {
		import = "plugins",
	} },

	-- AI and Code Assistance
	-- {
	-- 	"olimorris/codecompanion.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"hrsh7th/nvim-cmp",
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"echasnovski/mini.nvim",
	-- 		{ "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
	-- 		{ "stevearc/dressing.nvim", opts = {} },
	-- 	},
	-- 	config = true,
	-- },
})
