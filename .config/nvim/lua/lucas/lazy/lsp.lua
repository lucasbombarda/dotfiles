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

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"rust_analyzer",
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
			},
			handlers = {
				function(server_name) -- default handler (optional)
					vim.lsp.config(server_name, {
						capabilities = capabilities,
					})
				end,
			},
		})

		local capabilities_custom = vim.lsp.protocol.make_client_capabilities()
		capabilities_custom.textDocument.completion.completionItem.snippetSupport = true

		vim.lsp.config("html", {
			capabilities = capabilities_custom,
			filetypes = { "html" },
		})

		vim.lsp.config("svelte", {
			capabilities = capabilities,
			filetypes = { "svelte" },
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

		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
			settings = {
				["rust-analyzer"] = {
					inlayHints = {
						bindingModeHints = {
							enable = false,
						},
						chainingHints = {
							enable = true,
						},
						closingBraceHints = {
							enable = true,
							minLines = 25,
						},
						closureReturnTypeHints = {
							enable = "never",
						},
						lifetimeElisionHints = {
							enable = "never",
							useParameterNames = false,
						},
						maxLength = 25,
						parameterHints = {
							enable = true,
						},
						reborrowHints = {
							enable = "never",
						},
						renderColons = true,
						typeHints = {
							enable = true,
							hideClosureInitialization = false,
							hideNamedConstructor = false,
						},
					},
					diagnostics = {
						enable = true,
					},
					check = {
						command = "clippy",
					},
					cargo = {
						buildScripts = {
							enable = true,
						},
					},
					procMacro = {
						enable = true,
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

		vim.lsp.config("dartls", {
			capabilities = capabilities,
			settings = {
				dart = {
					completeFunctionCalls = true,
					showTodos = true,
					updateImportsOnRename = true,
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
			update_in_insert = true,

			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})
	end,
}
