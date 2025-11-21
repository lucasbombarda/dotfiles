return {
    'nvim-flutter/flutter-tools.nvim',
    dependencies = {
        'neovim/nvim-lspconfig',
    },
    config = function()
        require('flutter-tools').setup {
            -- Customize flutter-tools settings
        }
    end,
}
