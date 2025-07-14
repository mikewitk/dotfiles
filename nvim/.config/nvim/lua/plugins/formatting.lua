return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      html = {"prettier"},
      javascript = {"prettier"},
      javascriptreact = {"prettier"}, -- For JSX in JS files
      typescript = {"prettier"},
      typescriptreact = {"prettier"}, -- For JSX/TSX in TS files
      json = {"prettier"},
      css = {"prettier"},
      scss = {"prettier"},
      lua = {"stylua"}
    },
    formatters = {
      prettier = {
        -- Ensure prettier can infer the file type correctly
        args = function(self, ctx)
          local args = {"--stdin-filepath", ctx.filename}
          if vim.fn.filereadable(".prettierrc") == 1 or vim.fn.filereadable(".prettierrc.json") == 1 then
            table.insert(args, "--config-precedence")
            table.insert(args, "prefer-file")
          end
          return args
        end,
      },
    },
  },
}
