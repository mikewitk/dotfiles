return {
	"m4xshen/hardtime.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			config = function()
				vim.notify = require("notify")
			end,
		},
	},
	config = function()
		require("hardtime").setup({
			notification = true,
			callback = function(...)
				require("notify")(...)
			end,
			disabled_keys = {
				["<Up>"] = {},
				["<Down>"] = {},
				["<Left>"] = {},
				["<Right>"] = {},
			},
		})
	end,
}
