local config = {
  -- Configure plugins
  mappings = {
    n = {
      ["<leader>ct"] = { function() require("Comment.api").toggle.linewise() end, desc = "Comment line" },
      ["<leader>ms"] = { ":set spell!<cr>", desc = "Toggle spellcheck" }
    },
    v = {
      ["<leader>ct"] = {
        "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
        desc = "Toggle comment line",
      }
    }
  },
}

return config
