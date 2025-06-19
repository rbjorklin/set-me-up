local status, diffview = pcall(require, "diffview")
if not status then return end

local keymap = vim.keymap.set
local opts = {silent = true, noremap = true}

diffview.setup({})

local function telescope_commits_to_diffview()
  local builtin = require('telescope.builtin')
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  builtin.git_commits({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection then
          local commit_hash = selection.value
          vim.cmd('DiffviewOpen ' .. commit_hash .. '^..' .. commit_hash)
        end
      end)

      return true
    end,
  })
end

keymap("n", "<leader>gd", telescope_commits_to_diffview, opts)
