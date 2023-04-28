-- Enable transparency by default
vim.g.transparent_enabled = true


local config = {
  plugins = {
    {
      "xiyaowong/transparent.nvim",
      lazy = false,
      config = function()
        require("transparent").setup({
          groups = { -- table: default groups
            'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
            'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
            'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
            'SignColumn', 'CursorLineNr', 'EndOfBuffer',
          },
          extra_groups = {
            "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
            "NeoTreeNormal",
            "NeoTreeNormalNC",
            "NormalFloat",
          },                   -- table: additional groups that should be cleared
          exclude_groups = {}, -- table: groups you don't want to clear
        })
      end
    },
    { "folke/which-key.nvim", opts = { icons = { separator = "➜" } } }
  },
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
