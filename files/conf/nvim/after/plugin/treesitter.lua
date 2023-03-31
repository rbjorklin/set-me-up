local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
    highlight = {
        enable = true,
        disable = {},

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
        disable = {},
    },
    ensure_installed = {
        "bash",
        "comment",
        "diff",
        "dockerfile",
        "go", 
        "json",
        "lua",
        "make",
        "ocaml",
        "ocaml_interface",
        "python",
        "rst",
        "rust",
        "sql",
        "toml",
        "yaml",
    },
    sync_install = false,
    autotag = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
    autopairs = {
        enable = true,
    }
}
