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

    { -- File explorer in a normal buffer
        "stevearc/oil.nvim",
        tag = "v2.15.0",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

  { -- lsp config
        "neovim/nvim-lspconfig",
        tag = "v2.3.0",
    },

  { -- snippet manager
        "L3MON4D3/LuaSnip",
        tag = "v2.4.0",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
    },

  { -- auto-complete
        "hrsh7th/nvim-cmp",
        commit = "b5311ab3ed9c846b585c0c15b7559be131ec4be9",
        -- commit = "d884a049bb66722668ebe5de97f341327e8422cf", -- https://github.com/hrsh7th/nvim-cmp/pull/1833
        dependencies = {
          { "saadparwaiz1/cmp_luasnip" },
          { "hrsh7th/cmp-buffer" },
          { "hrsh7th/cmp-path" },
          { "hrsh7th/cmp-nvim-lsp" },
        },
  },

    {  -- Better diagnostics
        "folke/trouble.nvim",
        tag = "v3.7.1",
        lazy = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" }
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

    { -- symbol outline
        'stevearc/aerial.nvim',
        tag = "v2.5.0",
        opts = {},
        -- Optional dependencies
        dependencies = {
           "nvim-treesitter/nvim-treesitter",
           "nvim-tree/nvim-web-devicons"
        },
    },

  { -- bufferline
        "akinsho/bufferline.nvim",
        tag = "v4.9.1",
        dependencies = {'nvim-tree/nvim-web-devicons'},
    },

  { -- git conflict resolution
        "akinsho/git-conflict.nvim",
    tag = "v2.1.0",
    config = true,
  },

  { -- statusbar
        "nvim-lualine/lualine.nvim",
        commit = "0a5a66803c7407767b799067986b4dc3036e1983",
    },

  { -- fuzzy search
        "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  { -- Fancier UI select boxes.
        "stevearc/dressing.nvim",
        commit = "5162edb1442a729a885c45455a07e9a89058be2f",
    },

  { -- Diagnostics, Code Actions, Auto formating & more
        "nvimtools/none-ls.nvim",  -- formerly null-ls
        commit = "a117163db44c256d53c3be8717f3e1a2a28e6299",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  { -- Git information in gutter
        "lewis6991/gitsigns.nvim",
        tag = "v1.0.2"
    },

  { -- Much improved diff viewer
    "rbjorklin/diffview.nvim",
    commit = "be55bf10a1cba8a3d0db20a461538d3a4dd833c2",
  },
  --{
  --  dir = "~/git/diffview.nvim",
  --  dev = true
  --},

  { -- A Magit inspired git interface
    "NeogitOrg/neogit",
    commit = "3d58bf1d548f6fafdaab8ce4d75e25c438aee92c",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true
  },

  { -- vim-fugitive, really only for the GBrowse feature
    "tpope/vim-fugitive",
    commit = "1d18c696c4284e9ce9467a5c04d3adf8af43f994",
    dependencies = {
      "tpope/vim-rhubarb",
    }
  },

    { -- Surrond word with parentheses, quotes etc.
        "tpope/vim-surround",
        commit = "3d188ed2113431cf8dac77be61b842acb64433d9",
    },

  { -- Treesitter
        "nvim-treesitter/nvim-treesitter",
        tag = "v0.10.0",
        build = ":TSUpdate",
  },

  { -- provide context when scrolling
        "nvim-treesitter/nvim-treesitter-context",
        commit = "1a1a7c5d6d75cb49bf64049dafab15ebe294a79f",
  },

  { -- provide syntax aware text objects
        "nvim-treesitter/nvim-treesitter-textobjects",
        commit = "89ebe73cd2836db80a22d9748999ace0241917a5",
  },

  { -- better matching
        "andymass/vim-matchup",
        commit = "aca23ce53ebfe34e02c4fe07e29e9133a2026481",
  },

    { -- Debug using DAP
        "mfussenegger/nvim-dap",
        tag = "0.10.0",
        lazy = true,
        cmd = {
          "DapToggleBreakpoint",
          "DapContinue",
          "DapStepOver",
          "DapStepInto",
          "DapToggleRepl",
        },
    },

    { -- UI for nvim DAP
        "rcarriga/nvim-dap-ui",
        tag = "v4.0.0",
        lazy = true,
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        }
    },

    -- Inspiration from: https://www.youtube.com/watch?v=i04sSQjd-qo
  { -- Go
        "ray-x/go.nvim",
        commit = "789aca938a9a6f140fc2e2b585380a18f9cef422",
    },

    { -- Debug neovim
        "jbyuki/one-small-step-for-vimkind",
        commit = "93af151b02d2952977fd3db20b07d2a5d23b60f6",
    },

    { -- indentation guides
        "lukas-reineke/indent-blankline.nvim",
        tag = "v3.9.0",
    },

  { -- basic ollama integration
        "David-Kunz/gen.nvim",
        commit = "83f1d6b6ffa6a6f32f6a93a33adc853f27541a94",
        lazy = true,
  },
  { -- basic ollama integration
        "gsuuon/model.nvim",
        commit = "d6ea8a3274fbcb464b0559ce5dfe9b14acff12f3",
        lazy = true,  -- probably change this
  },
  { --  better marks
        "otavioschwanck/arrow.nvim",  -- harpoon alternative
        commit = "9608ce6d7e6935efd423946a319f7f4041cbde93",
        opts = {
          show_icons = true,
          leader_key = ';', -- Recommended to be a single key
          buffer_leader_key = 'm', -- Per Buffer Mappings
        }
  },
  {
        "olimorris/codecompanion.nvim",
        tag = "v17.21.0",
        opts = {},
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
        }
  }
})
