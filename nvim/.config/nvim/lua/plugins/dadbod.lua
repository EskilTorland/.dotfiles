return {
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "BbxRefresh" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_force_echo_notifications = 1
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
		end,
		config = function()
			-- Bruktbilx2 PostgreSQL Flexible Servers. Private network — requires VPN.
			-- Two roles per env: migration_user (default app role) and admin (ownership ops).
			-- Passwords pulled from each env's Key Vault on demand via :BbxRefresh,
			-- never persisted, never committed.
			local envs = {
				{ env = "dev", sub = "62cafa44-5482-49ee-a5db-fcc0d0940815" },
				{ env = "test", sub = "2815f732-de94-432e-b6b3-2d93d7000df2" },
				{ env = "stage", sub = "329eb232-440e-4b28-a3a8-701cc69a62a7" },
				{ env = "prod", sub = "d34643ef-7b1a-42d7-8110-bdb7d582d8d1" },
			}
			local roles = {
				{ suffix = "", user = "psqlmigration_user", secret = "psqlmigration-password" },
				{ suffix = "_admin", user = "psqladmin", secret = "psqladmin-password" },
			}

			-- RFC 3986 percent-encode for the userinfo/password component of a URI.
			local function urlencode(s)
				return (s:gsub("[^%w%-_.~]", function(c)
					return string.format("%%%02X", string.byte(c))
				end))
			end

			vim.api.nvim_create_user_command("BbxRefresh", function()
				local dbs = {}
				local count = 0
				for _, e in ipairs(envs) do
					for _, r in ipairs(roles) do
						local pw = vim.fn.trim(vim.fn.system({
							"az", "keyvault", "secret", "show",
							"--subscription", e.sub,
							"--vault-name", "weu-" .. e.env .. "-bruktbilx2-kv",
							"--name", r.secret,
							"--query", "value", "-o", "tsv",
						}))
						if vim.v.shell_error == 0 and pw ~= "" then
							dbs["bbx2_" .. e.env .. r.suffix] = string.format(
								"postgres://%s:%s@weu-%s-bbx2-flex-psql.postgres.database.azure.com/moller-weu-%s-bruktbilx2-db?sslmode=require",
								r.user, urlencode(pw), e.env, e.env
							)
							count = count + 1
						else
							vim.notify("BbxRefresh: failed to fetch " .. e.env .. "/" .. r.secret, vim.log.levels.WARN)
						end
					end
				end
				vim.g.dbs = dbs
				vim.notify("BbxRefresh: " .. count .. " connections loaded", vim.log.levels.INFO)
			end, { desc = "Refresh Bruktbilx2 DB passwords from Key Vault" })

			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "sql", "mysql", "plsql" },
				callback = function()
					require("blink.cmp").add_filetype_source("sql", "dadbod")
				end,
			})
		end,
		keys = {
			{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
			{ "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
			{ "<leader>Dr", "<cmd>BbxRefresh<cr>", desc = "Refresh Bruktbilx2 DB tokens" },
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
