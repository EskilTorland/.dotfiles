--#TODO: vise fullstending sti, lage dashbord, fikse tmux ui, mer snacks
return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = {
				sections = {
					{ section = "header" },
					{
						pane = 2,
						section = "terminal",
						cmd = "colorscript -e square",
						height = 5,
						padding = 1,
					},
					{ section = "keys", gap = 1, padding = 1 },
					{
						pane = 2,
						icon = " ",
						desc = "Browse Repo",
						padding = 1,
						key = "b",
						action = function()
							Snacks.gitbrowse()
						end,
					},
					function()
						local in_git = Snacks.git.get_root() ~= nil
						local cmds = {
							{
								icon = " ",
								title = "Open PRs",
								cmd = "COLUMNS=120 PAGER=cat gh pr list",
								key = "P",
								action = function()
									vim.fn.jobstart("gh pr list --web", { detach = true })
								end,
								width = 120,
								height = 14,
							},
							{
								icon = " ",
								title = "Git Status",
								cmd = "git --no-pager diff --stat -B -M -C",
								height = 10,
							},
						}
						return vim.tbl_map(function(cmd)
							return vim.tbl_extend("force", {
								pane = 2,
								section = "terminal",
								enabled = in_git,
								padding = 1,
								ttl = 5 * 60,
								indent = 3,
							}, cmd)
						end, cmds)
					end,
					{ section = "startup" },
				},
			},
			notifier = { enabled = true },
			picker = {
				enabled = true,
				formatters = {
					file = {
						truncate = 60,
					},
				},
			},
			gitbrowse = {},
		},
		keys = {
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>fs",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>n",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification History",
			},
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Goto Declaration",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gi",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Symbols",
			},
			{
				"<leader>sS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "LSP Workspace Symbols",
			},
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>go",
				function()
					Snacks.gitbrowse()
				end,
				desc = "Github file",
			},
		},
	},
}
