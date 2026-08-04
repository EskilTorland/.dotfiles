return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			delay = 200,
			spec = {
				{ "<leader>c", group = "Code" },
				{ "<leader>d", group = "Debug" },
				{ "<leader>D", group = "Database" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git/Go" },
				{ "<leader>r", group = "Refactor" },
				{ "<leader>s", group = "Symbols/Search" },
				{ "<leader>t", group = "Test" },
				{ "<leader>u", group = "UI Toggles" },
				{ "<leader>x", group = "Trouble" },
				{ "<leader>b", group = "Buffer" },
				{ "<leader>p", group = "Project" },

				{ "g", group = "Goto/Git" },
				{ "gd", desc = "Definition" },
				{ "gD", desc = "Declaration" },
				{ "gr", desc = "References" },
				{ "gi", desc = "Implementation" },
				{ "gy", desc = "Type definition" },
				{ "gb", desc = "Git blame" },

				{ "]", group = "Next (æ)" },
				{ "[", group = "Prev (ø)" },
				{ "]m", desc = "Next function start" },
				{ "]M", desc = "Next function end" },
				{ "]c", desc = "Next class start" },
				{ "]C", desc = "Next class end" },
				{ "]a", desc = "Next argument" },
				{ "]b", desc = "Next buffer" },
				{ "]d", desc = "Next diagnostic" },
				{ "[m", desc = "Prev function start" },
				{ "[M", desc = "Prev function end" },
				{ "[c", desc = "Prev class start" },
				{ "[C", desc = "Prev class end" },
				{ "[a", desc = "Prev argument" },
				{ "[b", desc = "Prev buffer" },
				{ "[d", desc = "Prev diagnostic" },

				{ "s", desc = "Flash jump", mode = { "n", "x", "o" } },
				{ "S", desc = "Flash treesitter", mode = { "n", "x", "o" } },
				{ "r", desc = "Remote Flash", mode = "o" },

				{ "sa", desc = "Surround add", mode = { "n", "v" } },
				{ "sd", desc = "Surround delete" },
				{ "sr", desc = "Surround replace" },
				{ "sf", desc = "Surround find right" },
				{ "sF", desc = "Surround find left" },
				{ "sh", desc = "Surround highlight" },
				{ "sn", desc = "Surround update count" },

			{ "a", group = "Around", mode = { "o", "x" } },
			{ "i", group = "Inside", mode = { "o", "x" } },

			-- Treesitter textobjects
			{ "af", desc = "Around function", mode = { "o", "x" } },
			{ "if", desc = "Inside function", mode = { "o", "x" } },
			{ "ac", desc = "Around class", mode = { "o", "x" } },
			{ "ic", desc = "Inside class", mode = { "o", "x" } },
			{ "aa", desc = "Around argument", mode = { "o", "x" } },
			{ "ia", desc = "Inside argument", mode = { "o", "x" } },
			{ "ai", desc = "Around conditional", mode = { "o", "x" } },
			{ "ii", desc = "Inside conditional", mode = { "o", "x" } },
			{ "al", desc = "Around loop", mode = { "o", "x" } },
			{ "il", desc = "Inside loop", mode = { "o", "x" } },

			-- mini.ai textobjects
			{ "aF", desc = "Around function call", mode = { "o", "x" } },
			{ "iF", desc = "Inside function call", mode = { "o", "x" } },
			{ "ab", desc = "Around brackets", mode = { "o", "x" } },
			{ "ib", desc = "Inside brackets", mode = { "o", "x" } },
			{ "aq", desc = "Around quotes", mode = { "o", "x" } },
			{ "iq", desc = "Inside quotes", mode = { "o", "x" } },
			{ "at", desc = "Around tag", mode = { "o", "x" } },
			{ "it", desc = "Inside tag", mode = { "o", "x" } },

			{ "gh", desc = "Diff hunk", mode = { "o", "x" } },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps",
			},
		},
	},
}
