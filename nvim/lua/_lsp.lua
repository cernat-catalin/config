local cmp = require'cmp'

-- requires the installation of fonts: https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts
-- Doesn't work in Alacritty
local lspkind = require('lspkind')

-- CMP setup. Mostly copied from the repository.
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },

    mapping = {
      ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Confirm with TAB character
    },

    sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' }
        }, {
            { name = 'buffer' },
        }),

    experimental = {
        ghost_text = true,
    },

    completion = {
        completeopt = 'menu,menuone,noinsert',
    },

    formatting = {
      format = require("lspkind").cmp_format({with_text = true, menu = ({
          buffer = "[Buffer]",
          nvim_lsp = "[LSP]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
        })}),
    }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['pyright'].setup {
    capabilities = capabilities
}


-- Load all instealled language servers
require'lspinstall'.setup()
local servers = require'lspinstall'.installed_servers()
for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
end
