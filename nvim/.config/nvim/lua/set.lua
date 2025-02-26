vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.showmode = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.spell = true
vim.opt.spelllang = "en_us"

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.colorcolumn = ""

vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		vim.opt.expandtab = true -- or any other specific settings
	end,
})

vim.g.netrw_preview = 1

-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "netrw",
--     callback = function()
--         local map_opts ={noremap = true,
--         silent = true,
--         buffer = true}
-- })
