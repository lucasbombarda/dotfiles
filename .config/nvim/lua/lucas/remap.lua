vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "g*", "g*zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")
-- This is going to get me cancelled

vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Open a new file adjacent to the current one (same directory).
vim.keymap.set("n", "<leader>o", ":e <C-R>=expand('%:p:h') . '/' <CR>")

-- Quick-save.
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>")
-- Make missing : less annoying.
vim.keymap.set("n", ";", ":")
-- Toggle visibility of tabs/trailing whitespace/etc (see listchars in set.lua).
vim.keymap.set("n", "<leader>,", ":set invlist<CR>")
-- Replace up to the next underscore, handy for editing snake_case names.
vim.keymap.set("n", "<leader>m", "ct_")

-- Leap: jump the cursor anywhere visible with 2 chars (see lazy/leap.lua).
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")

-- No arrow keys in normal/insert/visual: force home-row navigation.
-- Left/right stay usable on the command-line for editing the command itself.
for _, mode in ipairs({ "n", "i", "v" }) do
	vim.keymap.set(mode, "<Up>", "<Nop>")
	vim.keymap.set(mode, "<Down>", "<Nop>")
	vim.keymap.set(mode, "<Left>", "<Nop>")
	vim.keymap.set(mode, "<Right>", "<Nop>")
end

vim.keymap.set("n", "<leader><leader>", function()
	vim.cmd("so")
end)
