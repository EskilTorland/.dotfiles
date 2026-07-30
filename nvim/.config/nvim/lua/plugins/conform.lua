return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "n",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				liquid = { "prettier_liquid" },
				go = { "goimports", "gofumpt" },
				terraform = { "terraform_fmt" },
				["terraform-vars"] = { "terraform_fmt" },
				cs = { "csharpier" },
			},
		format_on_save = {
			timeout_ms = 3000,
			lsp_format = "fallback",
		},
			formatters = {
				prettier = {
					command = "./node_modules/.bin/prettier",
					require_cwd = true,
				},
				prettier_liquid = {
					command = "prettier",
					args = {
						"--stdin-filepath",
						"$FILENAME",
						"--plugin",
						"@shopify/prettier-plugin-liquid",
					},
				},
				csharpier = {
					command = "dotnet",
					args = { "csharpier", "format", "--write-stdout", "--stdin-path", "$FILENAME" },
					stdin = true,
					condition = function(_, ctx)
						local manifest = vim.fs.find(".config/dotnet-tools.json", {
							path = ctx.dirname,
							upward = true,
						})[1]
						if not manifest then
							return false
						end
						local content = vim.fn.readfile(manifest)
						return vim.fn.join(content, ""):find("csharpier") ~= nil
					end,
				},
			},
		},
	},
}
