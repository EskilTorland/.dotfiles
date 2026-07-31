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
	--
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
				theme = "wave",
				transparent = true,
				background = {
					dark = "wave",
					light = "none",
				},
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
						BlinkCmpMenuBorder = { bg = "none" },
					}
				end,
			})
			vim.cmd.colorscheme("kanagawa-wave")

			function ColorMyPencils(color)
				color = color or "kanagawa-wave"
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
			end

			ColorMyPencils()
		end,
	},
}
