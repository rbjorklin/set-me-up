local status, gen = pcall(require, "gen")
if not status then return end

gen.setup({
    model = "llama3:8b-instruct-q8_0"
})
