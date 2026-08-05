return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' }, -- Tells lazy.nvim to load this plugin when opening a markdown file
    dependencies = { 
        'nvim-treesitter/nvim-treesitter', 
        'echasnovski/mini.nvim',
        'nvim-tree/nvim-web-devicons' 
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
}
