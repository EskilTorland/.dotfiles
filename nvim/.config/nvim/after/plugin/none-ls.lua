local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.stylua,
		require("none-ls.diagnostics.eslint"),
		require("none-ls.code_actions.eslint"),
	},
})

vim.cmd([[
  augroup LspFormatting
    autocmd!
    autocmd BufWritePre * lua vim.lsp.buf.format({})
  augroup END
]])
