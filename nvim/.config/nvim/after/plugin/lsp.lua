local lsp = require("lsp-zero")

lsp.on_attach(function(client, bufnr)
	if vim.bo[bufnr].filetype == "terraform" then
		client.server_capabilities.semanticTokensProvider = nil
	end

	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "<leader>h", function()
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end, opts)
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "<leader>gi", function()
		vim.lsp.buf.implementation()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
	end, opts)
	vim.keymap.set("n", "<leader>ca", function()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "<leader>gr", function()
		vim.lsp.buf.references()
	end, opts)
	vim.keymap.set("n", "<leader>rn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)
	vim.keymap.set("n", "<leader>vws", function()
		vim.lsp.buf.workspace_symbol()
	end, opts)
	vim.keymap.set("n", "<leader>vd", function()
		vim.diagnostic.open_float()
	end, opts)
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_prev()
	end, opts)
end)

require("mason").setup({})
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,

		ts_ls = function()
			require("lspconfig").ts_ls.setup({
				init_options = {
					preferences = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
						importModuleSpecifierPreference = "non-relative",
					},
					plugins = {
						{
							name = "@styled/typescript-styled-plugin",
							location = "/usr/local/lib/node_modules/@styled/typescript-styled-plugin",
						},
					},
				},
			})
		end,

		yamlls = function()
			require("lspconfig").yamlls.setup({
				settings = {
					yaml = {
						schemas = {
							kubernetes = "/*.yaml",
						},
					},
				},
			})
		end,

		shopify_theme_ls = function()
			require("lspconfig").shopify_theme_ls.setup({
				root_dir = function(fname)
					return vim.loop.cwd() -- Use the current working directory as the root
				end,
			})
		end,
	},
})

local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

local cmp_action = lsp.cmp_action()

require("luasnip.loaders.from_vscode").lazy_load()
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
		{ name = "path" },
	}),
	window = {
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<Enter>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
	}),
	formatting = lsp.cmp_format({ details = false }),
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
	virtual_text = {
		prefix = function(diagnostic)
			if diagnostic.severity == vim.diagnostic.severity.ERROR then
				return ""
			elseif diagnostic.severity == vim.diagnostic.severity.WARN then
				return ""
			elseif diagnostic.severity == vim.diagnostic.severity.INFO then
				return ""
			elseif diagnostic.severity == vim.diagnostic.severity.HINT then
				return ""
			end
			return "■"
		end,
	},
	signs = true,
	update_in_insert = true,
})
