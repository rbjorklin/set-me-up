local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don"t error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	print("Packer is not installed")
	return
end

-- Have packer use a popup window
packer.init({
	ensure_dependencies = true, -- default
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- https://github.com/wbthomason/packer.nvim#specifying-plugins
packer.startup(function(use)
	-- packer can manage itself!
	use("wbthomason/packer.nvim")

	-- nvim-tree file explorer
	use({
		"nvim-tree/nvim-tree.lua",
	})

	-- lsp config
	use({
		"neovim/nvim-lspconfig",
	})

	use({
		"L3MON4D3/LuaSnip",
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },
		},
	})

	-- colorscheme
	use({
		"rbjorklin/nvim-solarized-lua",
		as = "solarized",
		branch = "use-all-colors",
	})

	-- symbol
	use({
		"simrat39/symbols-outline.nvim",
		branch = "master",
	})

	-- bufferline
	use({
		"akinsho/bufferline.nvim",
		tag = "v3.7.0",
	})

	-- git conflict resolution
	use({
		"akinsho/git-conflict.nvim",
		tag = "v1.1.2",
		config = function()
			require("git-conflict").setup()
		end,
	})

	-- statusbar
	use({
		"nvim-lualine/lualine.nvim",
	})

	-- fuzzy search
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.2",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Diagnostics, Code Actions, Auto formating & more
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- Git information in gutter
	use({
		"lewis6991/gitsigns.nvim",
		tag = "v0.6",
	})

	-- Surrond word with parentheses, quotes etc.
	use("tpope/vim-surround")

	-- Git plugin for vim
	use("tpope/vim-fugitive")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		tag = "v0.9.0",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter-context" })

	use({
		-- :TSHighlightCapturesUnderCursor
		"nvim-treesitter/playground",
		opt = true,
		cmd = { "TSHighlightCapturesUnderCursor" },
	})

	-- better matching
	use({
		"andymass/vim-matchup",
        commit = "6c8909b682803d8c3a054259079f158a73a0e30f", -- good
        -- commit = "b8eca3b588e41e0bb1b3ae200fae88183b91a76d", -- this commits breaks the plugin under lua
	})

	-- more intuitive navigation
	use("ggandor/leap.nvim")

	-- Debug using DAP
	use({
		"mfussenegger/nvim-dap",
		opt = true,
		cmd = {
			"DapToggleBreakpoint",
			"DapContinue",
			"DapStepOver",
			"DapStepInto",
			"DapToggleRepl",
		},
	})

    -- Go
    -- Inspiration from: https://www.youtube.com/watch?v=i04sSQjd-qo
	use({
		"ray-x/go.nvim",
	})

    -- Does go.nvim make this superflous?
    -- use ({
    --     'leoluz/nvim-dap-go',
    --     requires = { "mfussenegger/nvim-dap" },
    -- })

	-- Debug neovim
	use("jbyuki/one-small-step-for-vimkind")

	-- indentation guides
	use("lukas-reineke/indent-blankline.nvim")

	-- Automatically run packer.clean() followed by packer.update() after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
