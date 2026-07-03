return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		ts.install({
			"vimdoc",
			"javascript",
			"typescript",
			"c",
			"lua",
			"rust",
			"jsdoc",
			"bash",
			"python",
			"json",
			"css",
			"go",
			"gitignore",
			"gitcommit",
			"htmldjango",
			"html",
			"sql",
			"svelte",
			"markdown",
			"markdown_inline",
			"toml",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				if not pcall(vim.treesitter.start, ev.buf) then
					return
				end
				vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
