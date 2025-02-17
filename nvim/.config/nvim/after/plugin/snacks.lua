require("snacks").setup({
	-- animate = { enabled = false },
	-- bigfile = { enabled = false },
	-- bufdelete = { enabled = false },
	-- dashboard = { enabled = true },
	-- debug = { enabled = true },
	-- dim = { enabled = false },
	-- explorer = { enabled = false },
	-- git = { enabled = false },
	-- gitbrowse = { enabled = false },
	-- image = { enabled = false },
	-- indent = { enabled = false },
	-- input = { enabled = false },
	-- layout = { enabled = false },
	-- lazygit = { enabled = false },
	-- notifier = {
	-- 	enabled = false,
	-- 	timeout = 3000,
	-- },
	-- notify = { enabled = false },
	-- picker = { enabled = false },
	-- profiler = { enabled = false },
	-- quickfile = { enabled = false },
	--	rename = { enabled = false },
	-- scope = { enabled = false },
	-- scratch = { enabled = false },
	-- scroll = { enabled = false },
	-- statuscolumn = { enabled = false },
	-- terminal = { enabled = false },
	-- toggle = { enabled = false },
	-- util = { enabled = false },
	-- win = { enabled = false },
	-- words = { enabled = false },
	-- zen = { enabled = false },
})

-- Keymaps
-- vim.keymap.set("n", "<leader>RN", function()
-- 	require("snacks").rename.rename_file()
-- end, { desc = "Rename File" })
--
local Snacks = require("snacks")

-- Setup debug globals
_G.dd = function(...)
	Snacks.debug.inspect(...)
end
_G.bt = function()
	Snacks.debug.backtrace()
end
vim.print = _G.dd

-- Debug keymaps
vim.keymap.set("n", "<leader>db", function()
	Snacks.debug.backtrace()
end, { desc = "Show Backtrace" })
vim.keymap.set("n", "<leader>di", function()
	Snacks.debug.inspect(vim.fn.expand("<cword>"))
end, { desc = "Inspect Word Under Cursor" })
vim.keymap.set("n", "<leader>dr", function()
	Snacks.debug.run()
end, { desc = "Run Current Buffer" })
vim.keymap.set("v", "<leader>dr", function()
	Snacks.debug.run()
end, { desc = "Run Selected Lines" })
vim.keymap.set("n", "<leader>dl", function()
	Snacks.debug.log(vim.fn.expand("<cword>"))
end, { desc = "Log Word Under Cursor" })
vim.keymap.set("n", "<leader>dm", function()
	Snacks.debug.metrics()
end, { desc = "Show Debug Metrics" })
vim.keymap.set("n", "<leader>dp", function()
	Snacks.debug.profile(function()
		-- Replace this with the function you want to profile
		print("Profiling...")
	end, { count = 100, flush = true })
end, { desc = "Profile Function" })
