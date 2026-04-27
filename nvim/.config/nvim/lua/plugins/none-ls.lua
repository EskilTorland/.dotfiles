return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local null_ls = require("null-ls")

			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.prettier.with({
						command = "./node_modules/.bin/prettier",
						filetypes = {
							"javascript",
							"typescript",
							"css",
							"html",
							"json",
							"javascriptreact",
							"typescriptreact",
						},
					}),
					null_ls.builtins.formatting.stylua,
					require("none-ls.diagnostics.eslint"),
					require("none-ls.code_actions.eslint"),

					--YAML
					--	null_ls.builtins.formatting.prettier.with({
					--		filetypes = { "yaml" },
					--		extra_args = { "--tab-width", "2" },
					--	}),

					--Liquid
					null_ls.builtins.formatting.prettier.with({
						filetypes = { "liquid" },
						command = "prettier",
						args = {
							"--stdin-filepath",
							"$FILENAME", -- Provides the file path to Prettier
							"--plugin",
							"@shopify/prettier-plugin-liquid", -- Uses the Liquid plugin
						},
					}),

					-- null_ls.builtins.formatting.csharpier,
				},
			})
		end,
	},
}
