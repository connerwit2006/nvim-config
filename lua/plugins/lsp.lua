-- lua/plugins/lsp.lua
-- Focused LSP configuration for error checking based on languages in Treesitter

return {
  -- LSP Configuration & Plugins
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs 
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      
      -- Useful status updates for LSP
      { "j-hui/fidget.nvim", opts = {} },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Setup Mason
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      
      -- ONLY language servers for languages in your Treesitter config
      local servers = {
        -- Core languages from your treesitter.lua
        "bashls",      -- bash
        "clangd",      -- c and cpp 
        "cssls",       -- css
        "html",        -- html
        "ts_ls",    -- javascript, typescript, tsx
        "jsonls",      -- json, jsonc
        "lua_ls",      -- lua
        "marksman",    -- markdown
        "pyright",     -- python
        "rust_analyzer", -- rust
        "yamlls",      -- yaml
      }
      
      -- Configure Mason to auto-install the servers
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_installation = true,
      })
      
      -- Configure diagnostic display to show errors in real-time
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = true,  -- This enables real-time diagnostics in insert mode
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })
      
      -- Add diagnostic symbols to the sign column
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      
      -- Diagnostic keyboard shortcuts
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show Diagnostic Error" })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Show Diagnostic List" })
      
      -- LSP settings
      local lspconfig = require('lspconfig')
      
      -- Default LSP handler
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
        -- Set up buffer-local mappings
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
      end
      
      -- Set up capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      
      -- Set up specific language servers
      
      -- TypeScript/JavaScript
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
            },
          },
        },
      })
      
      -- Rust
      lspconfig.rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy",
            },
            inlayHints = {
              closingBraceHints = true,
              parameterHints = true,
              typeHints = true,
              chainingHints = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
      })
      
      -- HTML
      lspconfig.html.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      
      -- CSS
      lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          css = {
            validate = true,
          },
        },
      })
      
      -- JSON
      lspconfig.jsonls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      })
      
      -- YAML
      lspconfig.yamlls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          yaml = {
            validate = true,
            format = { enable = true },
          },
        },
      })
      
      -- Python
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      
      -- Lua
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
      
      -- C/C++
      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      
      -- Bash
      lspconfig.bashls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      
      -- Markdown
      lspconfig.marksman.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
      
      -- Toggle diagnostic display
      vim.keymap.set('n', '<leader>td', function()
        local current = vim.diagnostic.config().virtual_text
        vim.diagnostic.config({ virtual_text = not current })
      end, { desc = "Toggle Diagnostics" })
    end,
  },
  
  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      -- Schema store for JSON/YAML validation
      { "b0o/schemastore.nvim", ft = { "json", "jsonc", "yaml" } },
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },
}
