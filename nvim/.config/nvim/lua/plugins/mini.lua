return {
	{
		"echasnovski/mini.nvim",
		version = false,
		event = "VeryLazy",
	config = function()
		require("mini.ai").setup({
			custom_textobjects = {
				f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				F = require("mini.ai").gen_spec.function_call(),
			},
		})
		require("mini.pairs").setup()
			require("mini.surround").setup()
			require("mini.diff").setup()
			require("mini.hipatterns").setup({
				highlighters = {
					fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
					hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
					todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
					note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
					hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
				},
			})
		end,
	},
}
