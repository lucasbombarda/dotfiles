return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			default_format_opts = {
				lsp_format = "fallback",
				timeout_ms = 10000,
			},

			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				lua = { "stylua" },
				go = { "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				-- svelteserver bundles prettier-plugin-svelte; ts_ls is also attached to svelte buffers
				svelte = { lsp_format = "prefer", name = "svelte" },
				html = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				toml = { "taplo" },
				rust = { "rustfmt" },
				python = {
					"ruff_fix",
					"ruff_format",
					"ruff_organize_imports",
				},
				htmldjango = { "djlint" },
				sql = { "pg_format" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style={BasedOnStyle: LLVM, IndentWidth: 4}" },
				},
				["djlint"] = {
					prepend_args = { "--format-css", "--format-js", "--quiet" },
				},
				["pg_format"] = {
					command = "pg_format",
					args = {
						"--keyword-case",
						"2",
						"--type-case",
						"2",
						"--function-case",
						"2",
						"--spaces",
						"4",
						"--no-space-function",
						"-",
					},
					stdin = true,
				},
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
