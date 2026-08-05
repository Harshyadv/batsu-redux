-- Collection of small independent plugins
return {
  'nvim-mini/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- If a nerd font is available, load the icons module
    if vim.g.have_nerd_font then
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
    end

    -- Better Around/Inside textobjects
    require('mini.ai').setup {
      mappings = {
        around_next = 'aa',
        inside_next = 'ii',
      },
      n_lines = 500,
    }

    -- Add/delete/replace surroundings
    require('mini.surround').setup()

    -- Simple and easy statusline
    local statusline = require 'mini.statusline'
    statusline.setup { use_icons = vim.g.have_nerd_font }
    statusline.section_location = function() return '%2l:%-2v' end
  end,
}
