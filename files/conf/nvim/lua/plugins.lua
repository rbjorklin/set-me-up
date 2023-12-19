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
        "nvim-tree/nvim-tree.lua"
    },

    { -- File explorer in a normal buffer
        "stevearc/oil.nvim",
        tag = "v2.4.1",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },


	{ -- lsp config
        "neovim/nvim-lspconfig",
        tag = "v0.1.7",
    },

	{ -- snippet manager
        "L3MON4D3/LuaSnip",
        tag = "v2.1.1",
        build = "make install_jsregexp"
    },

	{ -- auto-complete
        "hrsh7th/nvim-cmp",
        commit = "0b751f6beef40fd47375eaf53d3057e0bfa317e4",
		dependencies = {
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
	},

	-- colorscheme
    {"maxmx03/solarized.nvim", tag = "v1.4.0"},

    {"numToStr/Comment.nvim", tag = "v0.8.0"},

    { -- symbol outline
        'stevearc/aerial.nvim',
        tag = "v1.3.0",
        opts = {},
        -- Optional dependencies
        dependencies = {
           "nvim-treesitter/nvim-treesitter",
           "nvim-tree/nvim-web-devicons"
        },
    },

	{ -- bufferline
        "akinsho/bufferline.nvim",
        tag = "v4.4.1",
        dependencies = {'nvim-tree/nvim-web-devicons'},
    },

	{ -- git conflict resolution
        "akinsho/git-conflict.nvim",
		tag = "v1.2.2",
		config = true,
	},

	-- statusbar
	{"nvim-lualine/lualine.nvim"},

	{ -- fuzzy search
        "nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{ -- Diagnostics, Code Actions, Auto formating & more
        "nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	-- Git information in gutter
	{"lewis6991/gitsigns.nvim", tag = "v0.7"},

    -- Git blame information in-line
	{"f-person/git-blame.nvim"},

	-- Surrond word with parentheses, quotes etc.
    {"tpope/vim-surround"},

	-- Git plugin for vim
    {"tpope/vim-fugitive"},

	{ -- Treesitter
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.9.1",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	},

	{ "nvim-treesitter/nvim-treesitter-context" },

	{ -- better matching
		"andymass/vim-matchup",
        commit = "2550178c43464134ce65328da458905f70dbe041",
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

    -- Go
    -- Inspiration from: https://www.youtube.com/watch?v=i04sSQjd-qo
	{"ray-x/go.nvim"},

	-- Debug neovim
    {"jbyuki/one-small-step-for-vimkind"},

    { -- indentation guides
        "lukas-reineke/indent-blankline.nvim",
        tag = "v3.3.10",
    },
})
