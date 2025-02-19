return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(event)
					local opts = { buffer = event.buf }
					vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
					vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
					vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					vim.keymap.set("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				end,
			})

			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = vim.tbl_deep_extend(
				"force",
				lspconfig_defaults.capabilities,
				require("cmp_nvim_lsp").default_capabilities()
			)

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

			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				snippet = {
					expand = function(args)
						-- You need Neovim v0.10 to use vim.snippet
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({}),
			})
		end,
	},
}
