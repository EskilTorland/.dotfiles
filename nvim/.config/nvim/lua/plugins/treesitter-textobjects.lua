return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = { query = "@function.outer", desc = "Around function" },
							["if"] = { query = "@function.inner", desc = "Inside function" },
							["ac"] = { query = "@class.outer", desc = "Around class" },
							["ic"] = { query = "@class.inner", desc = "Inside class" },
							["aa"] = { query = "@parameter.outer", desc = "Around argument" },
							["ia"] = { query = "@parameter.inner", desc = "Inside argument" },
							["ai"] = { query = "@conditional.outer", desc = "Around conditional" },
							["ii"] = { query = "@conditional.inner", desc = "Inside conditional" },
							["al"] = { query = "@loop.outer", desc = "Around loop" },
							["il"] = { query = "@loop.inner", desc = "Inside loop" },
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						-- These work via æ/ø remaps (æm = ]m, øm = [m)
						goto_next_start = {
							["]m"] = { query = "@function.outer", desc = "Next function start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
							["]a"] = { query = "@parameter.outer", desc = "Next argument" },
						},
						goto_next_end = {
							["]M"] = { query = "@function.outer", desc = "Next function end" },
							["]C"] = { query = "@class.outer", desc = "Next class end" },
						},
						goto_previous_start = {
							["[m"] = { query = "@function.outer", desc = "Prev function start" },
							["[c"] = { query = "@class.outer", desc = "Prev class start" },
							["[a"] = { query = "@parameter.outer", desc = "Prev argument" },
						},
						goto_previous_end = {
							["[M"] = { query = "@function.outer", desc = "Prev function end" },
							["[C"] = { query = "@class.outer", desc = "Prev class end" },
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = { query = "@parameter.inner", desc = "Swap with next argument" },
						},
						swap_previous = {
							["<leader>A"] = { query = "@parameter.inner", desc = "Swap with prev argument" },
						},
					},
			},
		})
	end,
	},
}
