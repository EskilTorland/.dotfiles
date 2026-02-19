return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		build = ":TSUpdate",

		config = function()
			require("nvim-treesitter.configs").setup({

				ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "c_sharp", "markdown", "markdown_inline" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
