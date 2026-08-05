-- Add indentation guides even on blank lines
-- See `:help ibl`
return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',
  event = 'BufReadPre',
  opts = {},
}
