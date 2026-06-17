return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

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
			capabilities = capabilities,
			filetypes = { "svelte" },
		})

		vim.lsp.config("emmet_language_server", {
			capabilities = capabilities,
			filetypes = { "html", "htmldjango", "css", "scss", "less", "svelte" },
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
			filetypes = { "css", "scss", "less" },
		})

		vim.lsp.config("tailwindcss", {
			capabilities = capabilities,

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
			capabilities = capabilities,
			settings = {
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
			capabilities = capabilities,
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
			capabilities = capabilities,
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

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
			}, {
				{ name = "buffer" },
			}),
		})

		cmp.setup.filetype({ "sql" }, {
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "buffer" },
			},
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
