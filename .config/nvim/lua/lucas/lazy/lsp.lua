return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
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
        require("conform").setup({
            formatters_by_ft = {}
        })
        local cmp = require('cmp')
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
                "sqlls",
                "biome",
                "gopls",
                "ts_ls",
                "angularls",
                "html",
                "bashls",
                "svelte",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
            }
        })

        local lspconfig = require("lspconfig")
        local capabilities_custom = vim.lsp.protocol.make_client_capabilities()
        capabilities_custom.textDocument.completion.completionItem.snippetSupport = true

        lspconfig.html.setup({
            capabilities = capabilities_custom,
            filetypes = { "html", "htmlangular" },
        })

        lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        typeCheckingMode = "basic",
                        diagnosticMode = "openFilesOnly",
                        useLibraryCodeForTypes = true,
                    }
                }
            }
        })

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "Lua 5.1" },
                    diagnostics = {
                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                    }
                }
            }
        })

        lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            settings = {
                ["rust-analyzer"] = {
                    cargo = {
                        buildScripts = {
                            enable = true
                        },
                    },
                    procMacro = {
                        enable = true
                    },
                }

            }
        })

        local ts_js_format = {
            indentSize = 4,
            convertTabsToSpaces = true,
            indentStyle = "Smart",
            semicolons = "insert",
            trimTrailingWhitespace = true,
        }
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
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
                }
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            virtual_text = {
                current_line = true
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
    end
}
