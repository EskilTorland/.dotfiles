return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
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
					vim.keymap.set(
						"n",
						"<leader>ca",
						vim.lsp.buf.code_action,
						{ buffer = event.buf, desc = "Code action" }
					)
					--vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
					vim.keymap.set(
						"n",
						"<leader>rn",
						vim.lsp.buf.rename,
						{ buffer = event.buf, desc = "Rename symbol" }
					)
					--	vim.keymap.set("n", "<C-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					local slow_fold_servers = { "terraformls" }
					if
						client:supports_method("textDocument/foldingRange")
						and not vim.tbl_contains(slow_fold_servers, client.name)
					then
						local win = vim.api.nvim_get_current_win()
						vim.wo[win][0].foldmethod = "expr"
						vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
					end
				end,
			})

			local lspconfig_defaults = require("lspconfig").util.default_config
			lspconfig_defaults.capabilities = require("blink.cmp").get_lsp_capabilities(lspconfig_defaults.capabilities)
			vim.lsp.config("*", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			})

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

			vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })

			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:Crashdummyy/mason-registry",
				},
			})
			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = { "terraformls" },
				},
				ensure_installed = { "eslint" },
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

			vim.lsp.config("terraformls", {
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				on_attach = function(client)
					client.server_capabilities.semanticTokensProvider = nil
				end,
				settings = {
					["terraform-ls"] = {
						indexing = {
							ignoreDirectoryNames = { ".terraform" },
						},
					},
				},
			}),

				vim.lsp.config("vtsls", {
					on_attach = function(client, bufnr)
						client.server_capabilities.documentFormattingProvider = false
					end,
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
					settings = {
						yaml = {
							format = {
								enable = true,
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

				vim.lsp.config("jsonls", {
					settings = {
						json = {
							format = { enable = true },
							validate = { enable = true },
						},
					},
				}),

				vim.lsp.config("pyright", {
					before_init = function(_, config)
						local venv_path = vim.fs.find({ ".venv", "venv" }, {
							path = config.root_dir,
							type = "directory",
							upward = false,
						})[1]
						if venv_path then
							config.settings = config.settings or {}
							config.settings.python = config.settings.python or {}
							config.settings.python.pythonPath = vim.fs.joinpath(venv_path, "bin", "python")
						end
					end,
					settings = {
						python = {
							analysis = {
								autoSearchPaths = true,
								useLibraryCodeForTypes = true,
							},
						},
					},
				}),

				vim.lsp.config("roslyn", {
					cmd = {
						vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "mason", "bin", "roslyn"),
						"--logLevel=Information",
						"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
						"--stdio",
					},
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
						return vim.uv.cwd()
					end,
				}),
			})

			-- Deferred terraform-ls: start after buffer is rendered to avoid freeze
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "terraform", "terraform-vars" },
				callback = function(ev)
					vim.defer_fn(function()
						if vim.api.nvim_buf_is_valid(ev.buf) then
							vim.lsp.enable("terraformls")
						end
					end, 100)
				end,
			})
		end,
	},
}
