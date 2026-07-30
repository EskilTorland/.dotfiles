--vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])


--vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.opt.langmap = "ø[,æ],Ø{,Æ}"

vim.keymap.set({ "x", "o" }, "iæ", "i]", { remap = true, desc = "Inside []" })
vim.keymap.set({ "x", "o" }, "aæ", "a]", { remap = true, desc = "Around []" })
vim.keymap.set({ "x", "o" }, "iø", "i[", { remap = true, desc = "Inside []" })
vim.keymap.set({ "x", "o" }, "aø", "a[", { remap = true, desc = "Around []" })
vim.keymap.set({ "x", "o" }, "iÆ", "i}", { remap = true, desc = "Inside {}" })
vim.keymap.set({ "x", "o" }, "aÆ", "a}", { remap = true, desc = "Around {}" })
vim.keymap.set({ "x", "o" }, "iØ", "i{", { remap = true, desc = "Inside {}" })
vim.keymap.set({ "x", "o" }, "aØ", "a{", { remap = true, desc = "Around {}" })

-- Exit terminal mode with Escape key
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Prev diagnostic" })
