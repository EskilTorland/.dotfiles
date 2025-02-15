require("neo-tree").setup({
    close_if_last_window = false,
    enable_git_status = true,
    enable_diagnostics = true,
    popup_border_style = "single",
    default_component_configs = {
        indent = {
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            indent_size = 2,
        },
    },
    window = {
        position = "left",
        width = 30,
        mapping_options = {
            noremap = true,
            nowait = true,
        },
        mappings = {
            ["<space>"] = { 
                "toggle_node",
                nowait = false,
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["l"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = "add",
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
        }
    },
    filesystem = {
        filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true,
        },
        follow_current_file = {
            enabled = true,
        },
        hijack_netrw_behavior = "open_default",
    }
})

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true })
