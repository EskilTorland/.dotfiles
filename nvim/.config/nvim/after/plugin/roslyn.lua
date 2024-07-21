require("roslyn").setup({
	exe = vim.fs.joinpath(
		vim.fn.stdpath("data") --[[@as string]],
		"roslyn",
		"Microsoft.CodeAnalysis.LanguageServer.dll"
	),

	filewatching = true,
})
