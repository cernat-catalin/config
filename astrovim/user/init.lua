local config = {
  -- Configure plugins
  plugins = {
    init = {
      { "google/vim-jsonnet" }
    },

    ["cinnamon"] = function(config)
      config.scroll_limit = 0
        return config
    end,
  },
  mappings = {
    n = {
      ["<leader>ct"] = { function() require("Comment.api").toggle_current_linewise() end, desc = "Comment line" },
      ["<leader>ms"] = { ":set spell!<cr>", desc = "Toggle spellcheck" }
    },
    v =  {
    ["<leader>ct"] = {
      "<esc><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<cr>",
      desc = "Toggle comment line",
    }
  }
  },
}

return config
