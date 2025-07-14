return {
	{
		"seblj/roslyn.nvim",
		ft = { "cs", "vb" },
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {},
		--		vim.lsp.config("roslyn", {
		--			cmd = {
		--				"dotnet",
		--				vim.fs.joinpath(
		--					vim.fn.stdpath("data") --[[@as string]],
		--					"roslyn",
		--					"Microsoft.CodeAnalysis.LanguageServer.dll"
		--				),
		--				"--logLevel=Information",
		--				"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
		--				"--stdio",
		--			},
		--}),
		--		config = function()
		--			-- Add this variable to track CodeLens state
		--			local codelens_enabled = true
		--
		--			-- Add this function to toggle CodeLens
		--			local function toggle_codelens()
		--				codelens_enabled = not codelens_enabled
		--				if codelens_enabled then
		--					vim.lsp.codelens.refresh()
		--				else
		--					-- Clear existing CodeLens
		--					vim.lsp.codelens.clear()
		--				end
		--				print("CodeLens " .. (codelens_enabled and "enabled" or "disabled"))
		--			end
		--
		--			vim.lsp.config("roslyn", {
		--				config = {
		--					settings = {
		--						["csharp|codelens"] = {
		--							dotnet_enable_references_code_lens = true,
		--						},
		--					},
		--				},
		--				exe = {
		--					"dotnet",
		--					vim.fs.joinpath(
		--						vim.fn.stdpath("data") --[[@as string]],
		--						"roslyn",
		--						"Microsoft.CodeAnalysis.LanguageServer.dll"
		--					),
		--				},
		--				filewatching = "auto",
		--			})
		--			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
		--				callback = function()
		--					if codelens_enabled then
		--						vim.lsp.codelens.refresh()
		--					end
		--				end,
		--			})
		--			vim.keymap.set("n", "<leader>l", toggle_codelens, { desc = "Toggle CodeLens" })
		--		end,
	},
}
