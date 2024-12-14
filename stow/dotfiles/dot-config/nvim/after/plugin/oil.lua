local status, oil = pcall(require, "oil")
if (not status) then return end

oil.setup({
	keymaps = {
		["q"] = "actions.close",
	},
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
