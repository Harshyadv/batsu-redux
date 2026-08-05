-- Auto-detect and set indentation
return {
  'NMAC427/guess-indent.nvim',
  event = 'BufReadPre',
  config = function()
    require('guess-indent').setup {}
  end,
}
