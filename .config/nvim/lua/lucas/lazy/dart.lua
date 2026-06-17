return {
    'nvim-flutter/flutter-tools.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
    },
    config = function()
        require('flutter-tools').setup {
            lsp = {
                settings = {
                    completeFunctionCalls = true,
                    showTodos = true,
                    updateImportsOnRename = true,
                },
            },
        }
    end,
}
