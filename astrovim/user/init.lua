local config = {
  -- Configure plugins
  plugins = {
    ["cinnamon"] = function(config)
      config.scroll_limit = 0
        return config
    end,
  },
  mappings = {
    n = {
      ["<leader>ct"] = { function() require("Comment.api").toggle_current_linewise() end, desc = "Comment line" }
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
