require("lucas.set")
require("lucas.remap")
require("lucas.lazy_init")

local augroup = vim.api.nvim_create_augroup
local LucasGroup = augroup("Lucas", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

-- Interactive dev helper: `:lua R('lucas.lazy.colors')` to hot-reload a module.
function _G.R(name)
	require("plenary.reload").reload_module(name)
end

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- Automatically remove trailing whitespace on save, preserving the cursor
-- position and the last search pattern (keeppatterns + saved view).
autocmd({ "BufWritePre" }, {
	group = LucasGroup,
	pattern = "*",
	callback = function()
		local view = vim.fn.winsaveview()
		vim.cmd([[keeppatterns %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	group = LucasGroup,
	pattern = { "*.svelte" },
	callback = function()
		vim.bo.filetype = "svelte"
	end,
})

-- Automatically set the Django filetype for template files
autocmd({ "BufRead", "BufNewFile" }, {
	group = LucasGroup,
	pattern = "**/templates/**/*.html",
	callback = function()
		vim.bo.filetype = "htmldjango"
	end,
})

autocmd({ "BufRead", "BufNewFile" }, {
	group = LucasGroup,
	pattern = { "*.dart" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
})

autocmd({ "BufWritePost" }, {
	group = LucasGroup,
	pattern = { "*.svelte", "+*.ts", "+*.js" },
	callback = function(args)
		-- svelteserver won't attach to a file that didn't exist on disk yet.
		-- After the first save, re-fire FileType so the LSP attaches without
		-- reloading the buffer.
		local buf = args.buf
		if vim.bo[buf].filetype == "svelte" then
			local has_svelte = false
			for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
				if c.name == "svelte" then
					has_svelte = true
					break
				end
			end
			if not has_svelte then
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(buf) then
						vim.api.nvim_exec_autocmds("FileType", { buffer = buf })
					end
				end)
			end
		end

		-- Run the project's type check after save and surface failures in the
		-- quickfix list instead of discarding the output.
		local lines = {}
		vim.fn.jobstart({ "bun", "run", "check" }, {
			stdout_buffered = true,
			stderr_buffered = true,
			on_stdout = function(_, data)
				vim.list_extend(lines, data or {})
			end,
			on_stderr = function(_, data)
				vim.list_extend(lines, data or {})
			end,
			on_exit = function(_, code)
				if code == 0 then
					return
				end
				vim.schedule(function()
					vim.fn.setqflist({}, " ", { title = "bun run check", lines = lines })
				end)
			end,
		})
	end,
})

autocmd("LspAttach", {
	group = LucasGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition({
				reuse_win = true,
				on_list = function(options)
					local items = options.items or {}
					local seen, uniq = {}, {}
					for _, it in ipairs(items) do
						local key = table.concat({ it.filename, it.lnum, it.col }, ":")
						if not seen[key] then
							seen[key] = true
							table.insert(uniq, it)
						end
					end
					if #uniq == 1 then
						local first = uniq[1]
						vim.cmd.edit(vim.fn.fnameescape(first.filename))
						vim.api.nvim_win_set_cursor(0, { first.lnum, first.col })
					elseif #uniq > 1 then
						vim.fn.setqflist({}, " ", { title = "Definitions", items = uniq })
						vim.cmd("copen")
					end
				end,
			})
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "<leader>vrr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, opts)
		vim.keymap.set("n", "<leader>h", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = e.buf }), { bufnr = e.buf })
		end, opts)
	end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
