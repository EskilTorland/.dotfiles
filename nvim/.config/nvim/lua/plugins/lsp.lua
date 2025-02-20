--TODO: Look over keybinds for best practices, add gutter signs, figure out minidiff
--add snacks.nvim look at defaults for inspo eg lazy, mini etc
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
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
					--	vim.keymap.set("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				end,
			})

			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = require("blink.cmp").get_lsp_capabilities(lspconfig_defaults.capabilities)

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
		end,
	},
}
