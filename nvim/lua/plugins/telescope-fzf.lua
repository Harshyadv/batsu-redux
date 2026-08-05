-- Fuzzy finder native extension (conditionally loaded)
-- Only load if make is available
return {
  'nvim-telescope/telescope-fzf-native.nvim',
  cond = function()
    return vim.fn.executable 'make' == 1
  end,
  build = 'make',
  dependencies = { 'nvim-telescope/telescope.nvim' },
}
