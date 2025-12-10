return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				lua = { "stylua" },
				go = { "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				svelte = { "prettier" },
				rust = { "rustfmt" },
				python = {
					"ruff_fix",
					"ruff_format",
					"ruff_organize_imports",
				},
				htmldjango = { "djlint" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
				["djlint"] = {
					prepend_args = { "$FILENAME", "--reformat", "--format-css", "--format-js", "--quiet" },
				},
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
