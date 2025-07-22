require("lucas.set")
require("lucas.remap")
require("lucas.lazy_init")

local augroup = vim.api.nvim_create_augroup
local LucasGroup = augroup('Lucas', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

-- Automatically remove trailing whitespace on save
autocmd({ "BufWritePre" }, {
    group = LucasGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Automatically set the Angular filetype for component files
autocmd({ "BufRead", "BufNewFile" }, {
    group = LucasGroup,
    pattern = "*.component.html",
    callback = function()
        vim.bo.filetype = "htmlangular"
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

-- Run svelte-kit sync on save for Svelte files
autocmd({ "BufWritePost" }, {
    group = LucasGroup,
    pattern = { "*.svelte", "+*.ts", "+*.js" },
    callback = function()
        vim.fn.jobstart({ "npm", "exec", "-y", "svelte-kit", "sync" }, {
            stdout_buffered = true,
            stderr_buffered = true,
            detach = true,
        })
    end,
})


autocmd('LspAttach', {
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
                        vim.cmd("edit " .. first.filename)
                        vim.api.nvim_win_set_cursor(0, { first.lnum, first.col })
                    elseif #uniq > 1 then
                        vim.fn.setqflist({}, " ", { title = "Definitions", items = uniq })
                        vim.cmd("copen")
                    end
                end,
            })
        end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
