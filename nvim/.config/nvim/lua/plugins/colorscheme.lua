return {
	--	{
	--		"sainnhe/gruvbox-material",
	--		lazy = false,
	--		priority = 1000,
	--		config = function()
	--			vim.g.gruvbox_material_enable_italic = true
	--			vim.g.gruvbox_material_background = "soft"
	--			vim.cmd.colorscheme("gruvbox-material")
	--
	--			function ColorMyPencils(color)
	--				color = color or "gruvbox-material"
	--				vim.cmd.colorscheme(color)
	--
	--				local function clear_bg(name)
	--					local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
	--					hl.bg = nil
	--					vim.api.nvim_set_hl(0, name, hl)
	--				end
	--
	--				clear_bg("Normal")
	--				clear_bg("NormalFloat")
	--				clear_bg("NormalNC")
	--				clear_bg("NeoTreeNormal")
	--				clear_bg("NeoTreeNormalNC")
	--				clear_bg("NeoTreeEndOfBuffer")
	--				clear_bg("NeoTreeFloat")
	--				clear_bg("Pmenu")
	--				clear_bg("FloatBorder")
	--				clear_bg("ColorColumn")
	--				vim.api.nvim_set_hl(0, "@comment.todo.comment", { fg = "#FFC0CB" })
	--
	--				-- Old config (replaced to preserve fg when clearing bg for snacks.gh compat):
	--				-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "@comment.todo.comment", { fg = "#FFC0CB", bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "NeoTreeFloat", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
	--				-- vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
	--			end
	--
	--			ColorMyPencils()
	--		end,
	--	},
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				theme = "dragon",
				transparent = false,
				overrides = function()
					return {
						LineNr = { bg = "none" },
						SignColumn = { bg = "none" },
						MiniDiffSignAdd = { bg = "none" },
						MiniDiffSignChange = { bg = "none" },
						MiniDiffSignDelete = { bg = "none" },
						GitSignsAdd = { bg = "none" },
						GitSignsChange = { bg = "none" },
						GitSignsDelete = { bg = "none" },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa-dragon")

			function ColorMyPencils(color)
				color = color or "kanagawa-dragon"
				vim.cmd.colorscheme(color)

				local function clear_bg(name)
					local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
					hl.bg = nil
					vim.api.nvim_set_hl(0, name, hl)
				end

				clear_bg("Normal")
				clear_bg("NormalFloat")
				clear_bg("NormalNC")
				clear_bg("NeoTreeNormal")
				clear_bg("NeoTreeNormalNC")
				clear_bg("NeoTreeEndOfBuffer")
				clear_bg("NeoTreeFloat")
				clear_bg("Pmenu")
				clear_bg("FloatBorder")
				clear_bg("ColorColumn")
				vim.api.nvim_set_hl(0, "@comment.todo.comment", { fg = "#FFC0CB" })

				-- Old config (replaced to preserve fg when clearing bg for snacks.gh compat):
				-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "@comment.todo.comment", { fg = "#FFC0CB", bg = "none" })
				-- vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "NeoTreeFloat", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
				-- vim.api.nvim_set_hl(0, "ColorColumn", { bg = "none" })
			end

			ColorMyPencils()
		end,
	},
}
