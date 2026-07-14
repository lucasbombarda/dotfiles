return {
	"folke/trouble.nvim",
	opts = {
		focus = true,
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>tt",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Trouble: Toggle diagnostics",
		},
		{
			"<leader>tq",
			function()
				local trouble = require("trouble")
				if trouble.is_open() then
					trouble.close()
				else
					trouble.open("qflist")
				end
			end,
			desc = "Trouble: Fechar aberto ou abrir qflist",
		},
		{
			"gd",
			"<cmd>Trouble lsp_implementations auto_jump=true<cr>",
			desc = "Trouble: Goto implementation",
		},
		{
			"gD",
			"<cmd>Trouble lsp_definitions auto_jump=true<cr>",
			desc = "Trouble: Goto definition",
		},
	},
}
