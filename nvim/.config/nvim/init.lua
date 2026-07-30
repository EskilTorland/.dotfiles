-- Disable netrw (neo-tree handles directories)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- Set leader key before lazy setup
vim.g.mapleader = " "

require("set")
require("remap")
-- Initialize lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
})
