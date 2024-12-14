local status, gen = pcall(require, "gen")
if not status then return end

gen.setup({
	model = "qwen2.5-coder:7b-instruct-q5_K_M",
	prompts = {
		-- See examples here: https://github.com/David-Kunz/gen.nvim/blob/main/lua/gen/prompts.lua
		['Review'] = {
			prompt = "Your task is to complete a thorough step-by-step code review.\nThe results of your review will be used to fix bugs, improve the code readability and maintainability.\nProvide concrete changes to the code showing your suggested improvements.\nThe code to review follows here:\n```$filetype\n$text\n```"
		},
		['Identify bugs'] = {
			prompt = "Your task is to complete a thorough step-by-step code review.\nIt is crucial that you point out any bugs you find in the code.\nThe code to review follows here:\n```$filetype\n$text\n```"
		}
	}

})
