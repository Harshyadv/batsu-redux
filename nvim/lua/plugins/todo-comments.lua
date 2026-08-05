-- Highlight TODO comments
return {
  'folke/todo-comments.nvim',
  event = 'BufReadPre',
  config = function()
    require('todo-comments').setup { signs = false }
  end,
}
