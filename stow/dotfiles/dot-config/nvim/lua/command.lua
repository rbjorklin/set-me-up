vim.api.nvim_create_user_command("DuneUtopBelow", [[:rightbelow :20split +set\ nonu term://dune utop]], {})
vim.api.nvim_create_user_command("DuneUtopLeft", [[:leftabove :vsplit +set\ nonu term://dune utop]], {})
vim.api.nvim_create_user_command("DuneBuildRight", [[:rightbelow :vsplit +set\ nonu term://dune build @install --watch]], {})
vim.api.nvim_create_user_command("DuneBuild", [[:rightbelow :14split +set\ nonu term://dune build @install --watch]], {})
