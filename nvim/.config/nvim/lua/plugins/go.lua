-- Configure gopls for Go development
vim.lsp.config("gopls", {
	on_attach = function(client)
		-- Disable formatting in favor of goimports + gofumpt via none-ls
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end,
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
})

-- Workaround for gopls not supporting semanticTokensProvider
-- https://github.com/golang/go/issues/54531#issuecomment-1464982242
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client or client.name ~= "gopls" then
			return
		end
		if not client.server_capabilities.semanticTokensProvider then
			local semantic = client.config.capabilities.textDocument.semanticTokens
			if semantic then
				client.server_capabilities.semanticTokensProvider = {
					full = true,
					legend = {
						tokenTypes = semantic.tokenTypes,
						tokenModifiers = semantic.tokenModifiers,
					},
					range = true,
				}
			end
		end
	end,
})

-- Ensure Go tools are installed via Mason on first Go file open
vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	once = true,
	callback = function()
		local ensure_installed = { "gopls", "goimports", "gofumpt", "gomodifytags", "impl", "golangci-lint", "delve" }
		local registry = require("mason-registry")
		registry.refresh(function()
			for _, name in ipairs(ensure_installed) do
				local ok, pkg = pcall(registry.get_package, name)
				if ok and not pkg:is_installed() then
					pkg:install()
				end
			end
		end)
	end,
})

return {
	-- Go debugging with Delve
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "go",
		opts = {},
		keys = {
			{
				"<leader>dgt",
				function()
					require("dap-go").debug_test()
				end,
				desc = "Debug Go Test",
			},
			{
				"<leader>dgl",
				function()
					require("dap-go").debug_last_test()
				end,
				desc = "Debug Last Go Test",
			},
		},
	},
}
