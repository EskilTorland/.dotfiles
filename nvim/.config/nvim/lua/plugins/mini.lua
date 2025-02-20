return {
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			require("mini.ai").setup()
			require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.comment").setup()
			require("mini.diff").setup()
			require("mini.hipatterns").setup()
		end,
	},
}
