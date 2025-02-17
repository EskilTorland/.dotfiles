require("neo-tree").setup({
	close_if_last_window = false,
	enable_git_status = true,
	enable_diagnostics = true,
	-- highlight_background = false,
	-- window = {
	-- 	position = "left",
	-- 	width = 30,
	-- 	mapping_options = {
	-- 		noremap = true,
	-- 		nowait = true,
	-- 	},
	-- 	mappings = {
	-- 		["<space>"] = {
	-- 			"toggle_node",
	-- 			nowait = false,
	-- 		},
	-- 		["<2-LeftMouse>"] = "open",
	-- 		["<cr>"] = "open",
	-- 		["l"] = "open",
	-- 		["S"] = "open_split",
	-- 		["s"] = "open_vsplit",
	-- 		["C"] = "close_node",
	-- 		["z"] = "close_all_nodes",
	-- 		["a"] = "add",
	-- 		["A"] = "add_directory",
	-- 		["d"] = "delete",
	-- 		["r"] = "rename",
	-- 		["y"] = "copy_to_clipboard",
	-- 		["x"] = "cut_to_clipboard",
	-- 		["p"] = "paste_from_clipboard",
	-- 		["c"] = "copy",
	-- 		["m"] = "move",
	-- 		["q"] = "close_window",
	-- 		["R"] = "refresh",
	-- 		["?"] = "show_help",
	-- 	},
	-- },
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

vim.cmd([[                                     
    hi NeoTreeNormal guibg=NONE ctermbg=NONE    
    hi NeoTreeNormalNC guibg=NONE ctermbg=NONE  
    hi NeoTreeEndOfBuffer guibg=NONE ctermbg=NONE 
    hi NeoTreeFloat guibg=NONE ctermbg=NONE     
 ]])
