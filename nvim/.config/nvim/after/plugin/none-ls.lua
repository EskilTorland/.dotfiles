local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier.with({ command = "./node_modules/.bin/prettier" }),
		null_ls.builtins.formatting.stylua,
		require("none-ls.diagnostics.eslint"),
		require("none-ls.code_actions.eslint"),

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
	},
})

vim.cmd([[
  augroup LspFormatting
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.format({})
  augroup END
]])
