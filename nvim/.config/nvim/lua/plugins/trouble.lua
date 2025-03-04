return {
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {
            modes = {
                lsp = {
                    win = { position = "right" },
                },
            },
        },
        keys = {
            { "<leader>t",  "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (Trouble)" },
            { "<leader>tf", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>ts", "<cmd>Trouble symbols toggle<cr>",                  desc = "Symbols (Trouble)" },
            { "<leader>tt", "<cmd>Trouble lsp toggle<cr>",                      desc = "LSP references/definitions/... (Trouble)" },
            { "<leader>tl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location List (Trouble)" },
            { "<leader>tq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix List (Trouble)" },

        },
    }
}
