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
					--vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
					--vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
					vim.keymap.set("n", "ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
					--vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
					--	vim.keymap.set("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				end,
			})

			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = require("blink.cmp").get_lsp_capabilities(lspconfig_defaults.capabilities)

			local border = "rounded"

			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end

			vim.diagnostic.config({
				virtual_text = {
					prefix = function(diagnostic)
						if diagnostic.severity == vim.diagnostic.severity.ERROR then
							return ""
						elseif diagnostic.severity == vim.diagnostic.severity.WARN then
							return ""
						elseif diagnostic.severity == vim.diagnostic.severity.INFO then
							return ""
						elseif diagnostic.severity == vim.diagnostic.severity.HINT then
							return ""
						end
						return "■"
					end,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.INFO] = " ",
						[vim.diagnostic.severity.HINT] = " ",
					},
				},
				update_in_insert = true,
				severity_sort = true,
			})

			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff6b6b", italic = true })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#feca57", italic = true })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#48cae4", italic = true })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#95e1d3", italic = true })

			vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = {},
				--   vim.lsp.config("ts_ls", {
				--       init_options = {
				--           preferences = {
				--               importModuleSpecifierPreference = "non-relative",
				--           },
				--           plugins = {
				--               {
				--                   name = "@styled/typescript-styled-plugin",
				--                   location = "/usr/local/lib/node_modules/@styled/typescript-styled-plugin",
				--               },
				--           },
				--       },
				--   }),

				vim.lsp.config("vtsls", {
					settings = {
						vtsls = {
							tsserver = {
								globalPlugins = {
									{
										name = "@styled/typescript-styled-plugin",
										location = "/usr/local/lib/node_modules/@styled/typescript-styled-plugin",
										enableForWorkspaceTypeScriptVersions = true,
									},
								},
							},
						},
						typescript = {
							preferences = {
								importModuleSpecifierPreference = "non-relative",
							},
						},
					},
				}),

				vim.lsp.config("yamlls", {
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
					end,
					settings = {
						yaml = {
							format = {
								enable = false,
							},
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
							schemas = {
								-- kubernetes = "/*.yaml",
								--	["https://spec.openapis.org/oas/3.0/schema/2024-10-18"] = "*.yaml",
							},
						},
					},
				}),

				vim.lsp.config("roslyn", {
					settings = {
						["csharp|completion"] = {
							dotnet_provide_regex_completions = true,
							dotnet_show_completion_items_from_unimported_namespaces = true,
							dotnet_show_name_completion_suggestions = true,
						},
						["csharp|background_analysis"] = {
							dotnet_analyzer_diagnostics_scope = "fullSolution",
							dotnet_compiler_diagnostics_scope = "fullSolution",
						},
					},
				}),

				vim.lsp.config("shopify_theme_ls", {
					root_dir = function()
						return vim.loop.cwd() -- Use the current working directory as the root
					end,
				}),
			})
		end,
	},
}
