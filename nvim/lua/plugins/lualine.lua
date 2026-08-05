return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  lazy = false, -- Load statusline immediately
  config = function()
    require('lualine').setup {
      options = {
        theme = 'gruvbox',
        -- Use flat rectangles (clean blocks with simple vertical separators)
        component_separators = { left = '|', right = '|' },
        section_separators = { left = '', right = '' },
        
        -- UNCOMMENT the lines below if you have a Nerd Font installed and want powerline triangles:
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        
        globalstatus = true,
      },
      sections = {
        lualine_a = { { 'mode', padding = { left = 2, right = 2 } } },
        lualine_b = { 'filename', 'branch' },
        lualine_c = {
          '%=', -- center alignment
        },
        lualine_x = {
          function()
            local bufs = vim.tbl_filter(function(b)
              return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
            end, vim.api.nvim_list_bufs())
            local cur_buf = vim.api.nvim_get_current_buf()
            return '(buf #' .. cur_buf .. ' of ' .. #bufs .. ')'
          end,
        },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          { 'location', padding = { left = 2, right = 2 } },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    }
  end,
}
