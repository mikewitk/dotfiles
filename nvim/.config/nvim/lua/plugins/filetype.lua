return {
  -- Enhanced filetype detection and embedded language support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Configure embedded language injection for better completion
      opts.highlight = opts.highlight or {}
      opts.highlight.enable = true
      opts.highlight.additional_vim_regex_highlighting = false
      
      -- Enable incremental selection
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = "<S-CR>",
          node_decremental = "<BS>",
        },
      }
      
      -- Configure language injection for HTML with JS/TS
      opts.indent = { enable = true }
      
      return opts
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      
      -- Custom queries for better embedded language support
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      
      -- Ensure proper language injection
      vim.treesitter.language.register("javascript", "js")
      vim.treesitter.language.register("typescript", "ts")
      vim.treesitter.language.register("html", "htm")
    end,
  },
  
  -- File type specific configurations
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Configure LSP servers for different file types
      local servers = opts.servers or {}
      
      -- HTML server with embedded JS support
      servers.html = vim.tbl_deep_extend("force", servers.html or {}, {
        filetypes = { "html", "htm" },
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = {
            css = true,
            javascript = true,
          },
          provideFormatter = true,
        },
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = "auto",
            },
            hover = {
              documentation = true,
              references = true,
            },
          },
        },
      })
      
      -- Enhanced TypeScript server for JSX/TSX
      servers.ts_ls = vim.tbl_deep_extend("force", servers.ts_ls or {}, {
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
        init_options = {
          preferences = {
            includeCompletionsForModuleExports = true,
            includeCompletionsForImportStatements = true,
            includeCompletionsWithSnippetText = true,
            includeAutomaticOptionalChainCompletions = true,
          },
        },
        settings = {
          typescript = {
            suggest = {
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
            },
            preferences = {
              includePackageJsonAutoImports = "on",
              includeCompletionsForModuleExports = true,
            },
          },
          javascript = {
            suggest = {
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
            },
            preferences = {
              includePackageJsonAutoImports = "on",
              includeCompletionsForModuleExports = true,
            },
          },
        },
      })
      
      opts.servers = servers
      return opts
    end,
  },
  
  -- Auto commands for better language support
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "htm" },
        callback = function()
          -- Enable JavaScript completion in HTML files
          vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
          
          -- Set up local completion sources (with safety check)
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
              }),
            })
          end
        end,
      })
      
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        callback = function()
          -- Enable HTML-like completion in JSX/TSX files
          vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
          
          -- Set up enhanced completion sources for React files (with safety check)
          local ok, cmp = pcall(require, "cmp")
          if ok then
            cmp.setup.buffer({
              sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "buffer" },
                { name = "path" },
              }),
            })
          end
        end,
      })
    end,
  },
}