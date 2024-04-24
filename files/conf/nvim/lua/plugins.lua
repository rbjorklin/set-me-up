local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	{ -- nvim-tree file explorer
        "nvim-tree/nvim-tree.lua",
        tag = "nvim-tree-v1.3.0",
    },

    { -- File explorer in a normal buffer
        "stevearc/oil.nvim",
        tag = "v2.8.0",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

	{ -- lsp config
        "neovim/nvim-lspconfig",
        tag = "v0.1.7",
    },

	{ -- snippet manager
        "L3MON4D3/LuaSnip",
        tag = "v2.3.0",
        build = "make install_jsregexp"
    },

	{ -- auto-complete
        "hrsh7th/nvim-cmp",
        commit = "8f3c541407e691af6163e2447f3af1bd6e17f9a3",
		dependencies = {
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
	},

    {  -- Better diagnostics
        "folke/trouble.nvim",
        tag = "v2.10.0",
        lazy = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    { -- colorscheme
        "rktjmp/lush.nvim",
        commit = "bc12f010b34cfeefac35720656eb777753b165d9"
    },
	{
        "loganswartz/selenized.nvim",
        commit = "6f31b954da7e15190c2af1d550ce2f22bf675d97",
		dependencies = {
			{ "rktjmp/lush.nvim" }
        }
    },

    {  -- Easier block commenting
        "numToStr/Comment.nvim",
        tag = "v0.8.0",
    },

    { -- symbol outline
        'stevearc/aerial.nvim',
        tag = "v1.6.0",
        opts = {},
        -- Optional dependencies
        dependencies = {
           "nvim-treesitter/nvim-treesitter",
           "nvim-tree/nvim-web-devicons"
        },
    },

	{ -- bufferline
        "akinsho/bufferline.nvim",
        tag = "v4.5.3",
        dependencies = {'nvim-tree/nvim-web-devicons'},
    },

	{ -- git conflict resolution
        "akinsho/git-conflict.nvim",
		tag = "v1.3.0",
		config = true,
	},

	{ -- statusbar
        "nvim-lualine/lualine.nvim",
        commit = "0a5a66803c7407767b799067986b4dc3036e1983",
    },

	{ -- fuzzy search
        "nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{ -- Diagnostics, Code Actions, Auto formating & more
        "nvimtools/none-ls.nvim",
        commit = "88821b67e6007041f43b802f58e3d9fa9bfce684",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{ -- Git information in gutter
        "lewis6991/gitsigns.nvim",
        tag = "v0.8.0"
    },

	{ -- Git blame information in-line
        "f-person/git-blame.nvim",
        commit = "ad1d1365c9189d89797fe8d559677d5f55dc2830",
    },

    { -- Surrond word with parentheses, quotes etc.
        "tpope/vim-surround",
        commit = "3d188ed2113431cf8dac77be61b842acb64433d9",
    },

    { -- Git plugin for vim
        "tpope/vim-fugitive",
        commit = "dac8e5c2d85926df92672bf2afb4fc48656d96c7",
    },

	{ -- Treesitter
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.9.2",
		build = ":TSUpdate",
	},

	{ -- provide context when scrolling
        "nvim-treesitter/nvim-treesitter-context",
        commit = "4fe0a54e86859744968e1a5c7867b49c86855774",
    },

	{ -- better matching
		"andymass/vim-matchup",
        commit = "6c8909b682803d8c3a054259079f158a73a0e30f",
	},

    { -- Debug using DAP
        "mfussenegger/nvim-dap",
        tag = "0.7.0",
		lazy = true,
		cmd = {
			"DapToggleBreakpoint",
			"DapContinue",
			"DapStepOver",
			"DapStepInto",
			"DapToggleRepl",
		},
    },

    -- Inspiration from: https://www.youtube.com/watch?v=i04sSQjd-qo
	{ -- Go
        "ray-x/go.nvim",
        commit = "ae078b8da431f264ab488d6d4e14201761dbfdbc",
    },

    { -- Debug neovim
        "jbyuki/one-small-step-for-vimkind",
        commit = "93af151b02d2952977fd3db20b07d2a5d23b60f6",
    },

    { -- indentation guides
        "lukas-reineke/indent-blankline.nvim",
        tag = "v3.5.4",
    },
})
