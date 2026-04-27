return {
	{
		"hat0uma/csvview.nvim",
		ft = { "csv", "tsv", "dbout" },
		opts = {
			parser = { comments = { "--" } },
			view = { display_mode = "border" },
		},
		config = function(_, opts)
			require("csvview").setup(opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "dbout",
				callback = function(args)
					-- vim-dadbod renders psql output as pipe-separated values
					require("csvview").enable(args.buf, {
						parser = { delimiter = "|" },
						view = { display_mode = "border" },
					})
					vim.opt_local.wrap = false
				end,
			})
		end,
	},
}
