local config = {
  plugins = {
    { "github/copilot.vim",   lazy = false },
    { "andrewradev/linediff.vim", lazy = false },
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
    { "folke/which-key.nvim", opts = { icons = { separator = "➜" } } },
    {
      "nvim-neo-tree/neo-tree.nvim",
      config = function()
        require("neo-tree").setup({
          source_selector = {
            winbar = false,                        -- toggle to show selector on winbar
            statusline = false,                    -- toggle to show selector on statusline
            show_scrolled_off_parent_node = false, -- this will replace the tabs with the parent path
            -- of the top visible node when scrolled down.
            sources = {
              { source = "filesystem" },
              { source = "buffers" },
              { source = "git_status" },
            },
          },
        })
      end
    }
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
  polish = function()
    -- Keep search results highlighted
    vim.on_key(nil, vim.api.nvim_get_namespaces()["auto_hlsearch"])
  end
}

-- Avoid having to press "Enter" when entering a new buffer
vim.opt.shortmess = {
  o = true
}

-- Copilot: unmap TAB and set <C-e> for completion
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<C-e>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

vim.g.transparent_enabled = true

vim.g.linediff_first_buffer_command  = 'tabnew'
vim.g.linediff_second_buffer_command = 'rightbelow new'

-- autocmd for language specific settings
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "zig",
  callback = function()
    -- Keymap for Java --

    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})

return config
