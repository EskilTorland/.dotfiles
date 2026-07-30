return {
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "BbxRefresh", "BbsRefresh" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
			-- Cap column width in the horizontal result table so a single wide
			-- text column doesn't blow out the layout. Use <Leader>R in the
			-- dbout buffer to toggle expanded (vertical) layout for full values.
			vim.g.dbout_list_max_column_width = 80
		end,
		config = function()
			-- PostgreSQL Flexible Servers. Private network — requires VPN.
			-- Passwords pulled from each env's Key Vault on demand,
			-- never persisted, never committed.

			-- RFC 3986 percent-encode for the userinfo/password component of a URI.
			local function urlencode(s)
				return (s:gsub("[^%w%-_.~]", function(c)
					return string.format("%%%02X", string.byte(c))
				end))
			end

			-- Build a refresh command that merges its connections into vim.g.dbs.
			-- Each call only replaces its own prefixed keys, so multiple projects coexist.
			local function make_refresh(cmd_name, prefix, envs, vault_for, build_url, desc)
				vim.api.nvim_create_user_command(cmd_name, function()
					local dbs = vim.g.dbs or {}
					-- Drop prior entries owned by this project
					for k in pairs(dbs) do
						if k:sub(1, #prefix + 1) == prefix .. "_" then
							dbs[k] = nil
						end
					end
					local count = 0
					for _, e in ipairs(envs) do
						for _, r in ipairs(e.roles) do
							local pw = vim.fn.trim(vim.fn.system({
								"az", "keyvault", "secret", "show",
								"--subscription", e.sub,
								"--vault-name", vault_for(e),
								"--name", r.secret,
								"--query", "value", "-o", "tsv",
							}))
							if vim.v.shell_error == 0 and pw ~= "" then
								local key = prefix .. "_" .. e.env .. (r.suffix or "")
								dbs[key] = build_url(e, r, urlencode(pw))
								count = count + 1
							else
								vim.notify(
									cmd_name .. ": failed to fetch " .. e.env .. "/" .. r.secret,
									vim.log.levels.WARN
								)
							end
						end
					end
					vim.g.dbs = dbs
					vim.notify(cmd_name .. ": " .. count .. " connections loaded", vim.log.levels.INFO)
				end, { desc = desc })
			end

			-- Bruktbilx2: two roles per env (migration_user is the default app role; admin for ownership ops).
			local bbx2_roles = {
				{ suffix = "", user = "psqlmigration_user", secret = "psqlmigration-password" },
				{ suffix = "_admin", user = "psqladmin", secret = "psqladmin-password" },
			}
			make_refresh("BbxRefresh", "bbx2", {
				{ env = "dev", sub = "62cafa44-5482-49ee-a5db-fcc0d0940815", roles = bbx2_roles },
				{ env = "test", sub = "2815f732-de94-432e-b6b3-2d93d7000df2", roles = bbx2_roles },
				{ env = "stage", sub = "329eb232-440e-4b28-a3a8-701cc69a62a7", roles = bbx2_roles },
				{ env = "prod", sub = "d34643ef-7b1a-42d7-8110-bdb7d582d8d1", roles = bbx2_roles },
			}, function(e)
				return "weu-" .. e.env .. "-bruktbilx2-kv"
			end, function(e, r, pw)
				return string.format(
					"postgres://%s:%s@weu-%s-bbx2-flex-psql.postgres.database.azure.com/moller-weu-%s-bruktbilx2-db?sslmode=require",
					r.user, pw, e.env, e.env
				)
			end, "Refresh Bruktbilx2 DB passwords from Key Vault")

			-- Bruktbilsalg: migration_user only (the default app role).
			-- See bruktbilsalg-argo-cd/base/bruktbilsalg-backend/deployment.yaml for the full role -> secret mapping.
			local bbs_roles = {
				{ suffix = "", user = "bruktbilsalg_db_migration_user", secret = "postgresql-bruktbilsalg-migration-password" },
			}
			make_refresh("BbsRefresh", "bbs", {
				{ env = "dev", sub = "92e12b8d-3bcb-4dde-b186-5f27c22b2766", roles = bbs_roles },
				{ env = "test", sub = "2da290ba-4a65-498d-85e9-8212c5d97e2b", roles = bbs_roles },
				{ env = "stage", sub = "0599c260-bc1f-40e7-bee3-dac33149f236", roles = bbs_roles },
				{ env = "prod", sub = "ca830dcf-eaec-44aa-a4dd-bb070138cd28", roles = bbs_roles },
			}, function(e)
				return "weu-" .. e.env .. "-bruktbil-kv"
			end, function(e, r, pw)
				return string.format(
					"postgres://%s:%s@weu-%s-bruktbilsalg-flex-psql.postgres.database.azure.com/weu-%s-bruktbilsalg-db?sslmode=require",
					r.user, pw, e.env, e.env
				)
			end, "Refresh Bruktbilsalg DB passwords from Key Vault")

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					require("blink.cmp").add_filetype_source("sql", "dadbod")
				end,
			})

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dbout",
				callback = function()
					vim.opt_local.wrap = true
					vim.opt_local.linebreak = true
				end,
			})
		end,
		keys = {
			{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
			{ "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
			{ "<leader>Dr", "<cmd>BbxRefresh<cr>", desc = "Refresh Bruktbilx2 DB tokens" },
			{ "<leader>Ds", "<cmd>BbsRefresh<cr>", desc = "Refresh Bruktbilsalg DB tokens" },
		},
	},
	{
		"saghen/blink.cmp",
		opts = {
			sources = {
				providers = {
					dadbod = {
						name = "Dadbod",
						module = "vim_dadbod_completion.blink",
					},
				},
			},
		},
	},
}
