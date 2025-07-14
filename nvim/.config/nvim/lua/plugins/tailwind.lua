-- lua/plugins/tailwind.lua
return {
  -- Official Tailwind CSS Language Server integration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          settings = {
            tailwindCSS = {
              includeLanguages = {
                jsx = "javascriptreact",
                tsx = "typescriptreact",
              },
              experimental = {
                classRegex = {
                  "tw`([^`]*)`", -- for `tw` template literal support (if you use it)
                  'clsx\\(([^)]*)\\)', -- for clsx utility
                  'cva\\(([^)]*)\\)', -- for cva utility
                  'cn\\(([^)]*)\\)', -- for cn utility
                },
              },
            },
          },
        },
      },
    },
  },
  -- Tailwind CSS tooling and colorizer (compatible with blink.cmp)
  {
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim", -- optional
      "neovim/nvim-lspconfig", -- optional
    },
    opts = {
      document_color = {
        enabled = true, -- can be toggled by commands
        kind = "inline", -- "inline" | "foreground" | "background"
        inline_symbol = "●", -- only used in inline mode
        debounce = 200, -- in milliseconds, only applied in insert mode
      },
      conceal = {
        enabled = false, -- can be toggled by commands
        min_length = nil, -- only conceal classes exceeding the provided length
        symbol = "󱏿", -- only a single character is allowed
        highlight = {
          fg = "#38BDF8", -- style the symbol with a custom color
        },
      },
      custom_filetypes = {}, -- additional filetypes where tailwind classes should be detected
    },
    config = function(_, opts)
      require("tailwind-tools").setup(opts)
      
      -- Auto-sort Tailwind classes on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = {"*.html", "*.jsx", "*.tsx", "*.js", "*.ts", "*.vue", "*.svelte"},
        callback = function()
          -- Only run TailwindSort if the command exists
          if vim.fn.exists(":TailwindSort") > 0 then
            pcall(vim.cmd, "TailwindSort")
          end
        end,
      })
    end,
  },
}