return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'stevearc/conform.nvim',
      'mfussenegger/nvim-lint',
    },
    config = function()
      local on_attach = function(client, bufnr)
        -- lsp keymaps
        local map = vim.keymap.set
        map('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = 'LSP Hover' })
        map('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'LSP Definition' })
        -- ... other lsp keymaps ...
        map('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = 'LSP Code Action' })
        map('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = 'LSP Rename' })
      end

      -- setup mason and mason-lspconfig
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { 'pyright', 'rust_analyzer', 'gopls', 'lua_ls' },
        handlers = {
          function(server_name) -- default handler for most servers
            require('lspconfig')[server_name].setup({
              on_attach = on_attach,
            })
          end,

          ['lua_ls'] = function()
            require('lspconfig').lua_ls.setup({
              on_attach = on_attach,
              settings = {
                Lua = {
                  -- tell the language server that 'vim' is a global variable
                  diagnostics = { globals = { 'vim' } },
                },
              },
            })
          end,
        },
      })

      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(), -- previous suggestion
          ['<C-j>'] = cmp.mapping.select_next_item(), -- next suggestion
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- accept suggestion
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }),
      })

      require('conform').setup({
        format_on_save = { timeout_ms = 500, lsp_fallback = true },
        formatters_by_ft = {
          python = { 'ruff-format' },
          rust = { 'rustfmt' },
          go = { 'gofmt' },
          typescript = { 'prettierd' },
          lua = { 'stylua' },
        },
      })
      require('lint').linters_by_ft = {
        python = { 'ruff' }, typescript = { 'eslint_d' },
      }
    end,
  },
}