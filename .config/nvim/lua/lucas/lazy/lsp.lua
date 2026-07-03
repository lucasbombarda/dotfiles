return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		-- version pins blink to a release so it pulls the prebuilt Rust
		-- fuzzy-matcher binary instead of compiling from source.
		{
			"saghen/blink.cmp",
			version = "*",
			-- Surfaces copilot suggestions inside the blink menu.
			dependencies = { "fang2hou/blink-copilot" },
		},
		"L3MON4D3/LuaSnip",
		"j-hui/fidget.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("fidget").setup()
		require("mason").setup()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"ruff",
				"pyright",
				"cssls",
				"gopls",
				"ts_ls",
				"html",
				"bashls",
				"svelte",
				"tailwindcss",
				"emmet_language_server",
			},
			-- rust_analyzer is managed by rustaceanvim, keep mason-lspconfig
			-- from enabling a second instance.
			automatic_enable = {
				exclude = { "rust_analyzer" },
			},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"stylua",
				"prettier",
				"djlint",
				"pgformatter",
				"clang-format",
				"shfmt",
				"taplo",
				"rust-analyzer",
			},
		})

		vim.lsp.config("svelte", {
			filetypes = { "svelte" },
		})

		vim.lsp.config("emmet_language_server", {
			filetypes = { "html", "htmldjango", "css", "scss", "less", "svelte" },
		})

		vim.lsp.config("cssls", {
			filetypes = { "css", "scss", "less" },
		})

		vim.lsp.config("tailwindcss", {
			filetypes = {
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
			},
		})

		vim.lsp.config("pyright", {
			settings = {
				pyright = {
					-- Let ruff own import organizing to avoid duplicate code actions.
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						autoSearchPaths = true,
						typeCheckingMode = "basic",
						diagnosticMode = "openFilesOnly",
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = { version = "Lua 5.1" },
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
						},
					},
					diagnostics = {
						globals = { "vim", "it", "describe", "before_each", "after_each" },
					},
				},
			},
		})

		local ts_js_format = {
			indentSize = 4,
			convertTabsToSpaces = true,
			indentStyle = "Smart",
			semicolons = "insert",
			trimTrailingWhitespace = true,
		}
		vim.lsp.config("ts_ls", {
			filetypes = { "typescript", "svelte", "javascript" },
			init_options = {
				hostInfo = "neovim",
				preferences = {
					quotePreference = "double",
				},
			},
			settings = {
				typescript = {
					format = ts_js_format,
				},
				javascript = {
					format = ts_js_format,
				},
			},
		})

		require("blink.cmp").setup({
			-- Mirror the old nvim-cmp keymaps (<C-p>/<C-n>/<CR>/<C-Space>).
			-- preset "none" leaves <Tab> free for copilot.lua inline accept.
			keymap = {
				preset = "none",
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				-- Manually re-trigger signature help if the automatic popup closes.
				["<C-h>"] = { "show_signature", "hide_signature", "fallback" },
			},
			snippets = { preset = "luasnip" },
			sources = {
				default = { "copilot", "lsp", "snippets", "path", "buffer" },
				per_filetype = {
					sql = { "dadbod", "buffer" },
				},
				providers = {
					-- vim-dadbod-completion ships a native blink source module.
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
					-- Copilot suggestions as a blink source (score_offset ranks
					-- them above the rest; async keeps typing responsive).
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
			-- Use the Rust matcher; warn (don't error) if the binary is missing.
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		})

		vim.diagnostic.config({
			virtual_text = {
				current_line = true,
			},
			update_in_insert = false,

			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,
}
