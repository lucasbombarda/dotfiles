return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				-- Match the old copilot.vim muscle memory: <Tab> accepts the
				-- inline suggestion. blink uses preset "none", so <Tab> is free.
				-- When no suggestion is shown, these keys fall back to normal.
				keymap = {
					accept = "<Tab>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = { enabled = true },
		})
	end,
}
