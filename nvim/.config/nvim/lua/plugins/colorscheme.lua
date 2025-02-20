return {
    {
        "sainnhe/gruvbox-material",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_background = "soft"
            vim.cmd.colorscheme("gruvbox-material")

            function ColorMyPencils(color)
                color = color or "gruvbox-material"
                vim.cmd.colorscheme(color)

                vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
                vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
                vim.api.nvim_set_hl(0, "@comment.todo.comment", { fg = "#FFC0CB", bg = "none" })
                vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
                vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })
                vim.api.nvim_set_hl(0, "NeoTreeFloat", { bg = "none" })
                vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
                vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
            end

            ColorMyPencils()
        end,
    },
}
