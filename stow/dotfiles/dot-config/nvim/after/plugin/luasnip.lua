local status, luasnip_loaders = pcall(require, "luasnip.loaders.from_vscode")
if (not status) then return end

luasnip_loaders.lazy_load()
