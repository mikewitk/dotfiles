return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		local eslint_filetypes = {
			"javascriptreact",
			"typescriptreact",
		}

		local function has_eslint_config()
			local config_files = {
				".eslintrc.js",
				".eslintrc.cjs",
				".eslintrc.json",
				".eslintrc.yaml",
				".eslintrc.yml",
				"eslint.config.js",
				"package.json",
			}
			for _, file in ipairs(config_files) do
				if vim.fn.filereadable(file) == 1 or vim.fn.glob(file) ~= "" then
					return true
				end
			end
			return false
		end

		local function setup_linters()
			if has_eslint_config() then
				for _, ft in ipairs(eslint_filetypes) do
					if not lint.linters_by_ft[ft] or not vim.tbl_contains(lint.linters_by_ft[ft], "eslint_d") then
						lint.linters_by_ft[ft] = { "eslint_d" }
					end
				end
			else
				for _, ft in ipairs(eslint_filetypes) do
					lint.linters_by_ft[ft] = {}
				end
			end
		end

		setup_linters()

		local lint_augroup = vim.api.nvim_create_augroup("Linting", { clear = true })

		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
