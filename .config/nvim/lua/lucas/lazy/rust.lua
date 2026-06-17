return {
	"mrcjkb/rustaceanvim",
	version = "^6",
	lazy = false, -- rustaceanvim sets itself up, no need for lspconfig/mason-lspconfig
	config = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
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
							-- Rely on cargo check (clippy) on save as the single
							-- diagnostics source; disabling the native pass avoids
							-- duplicate rustc/rust-analyzer diagnostics.
							enable = false,
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
			},
		}
	end,
}
