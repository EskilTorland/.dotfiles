vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	once = true,
	callback = function()
		-- Configure gopls for Go development
		vim.lsp.config("gopls", {
		on_attach = function(client)
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

		-- Ensure Go tools are installed via Mason
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

	vim.lsp.enable("gopls")

	vim.keymap.set("n", "<leader>gt", function()
		local struct = vim.fn.expand("<cword>")
		local file = vim.api.nvim_buf_get_name(0)
		vim.system(
			{ "gomodifytags", "-file", file, "-struct", struct, "-add-tags", "json", "-w" },
			{},
			vim.schedule_wrap(function(result)
				if result.code == 0 then
					vim.cmd("edit!")
				else
					vim.notify("gomodifytags failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
				end
			end)
		)
	end, { desc = "Go: Add json tags to struct", buffer = true })

	vim.keymap.set("n", "<leader>gT", function()
		local struct = vim.fn.expand("<cword>")
		local file = vim.api.nvim_buf_get_name(0)
		vim.system(
			{ "gomodifytags", "-file", file, "-struct", struct, "-remove-tags", "json", "-w" },
			{},
			vim.schedule_wrap(function(result)
				if result.code == 0 then
					vim.cmd("edit!")
				else
					vim.notify("gomodifytags failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
				end
			end)
		)
	end, { desc = "Go: Remove json tags from struct", buffer = true })

	vim.keymap.set("n", "<leader>gi", function()
		local type_name = vim.fn.expand("<cword>")
		local iface = vim.fn.input("Interface: ")
		if iface == "" then
			return
		end
		vim.system(
			{ "impl", type_name, iface },
			{},
			vim.schedule_wrap(function(result)
				if result.code == 0 then
					local lines = vim.split(result.stdout, "\n", { trimempty = true })
					local row = vim.api.nvim_win_get_cursor(0)[1]
					vim.api.nvim_buf_set_lines(0, row, row, false, lines)
				else
					vim.notify("impl failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
				end
			end)
		)
	end, { desc = "Go: Implement interface", buffer = true })
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
