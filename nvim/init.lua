-- Set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
-- See `:help vim.o`
-- For more options, you can see `:help option-list`

-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

-- Make line numbers default
vim.o.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable line wrapping and character/word boundary wrapping
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Confirm before exiting with unsaved changes
vim.o.confirm = true

-- [[ Lazy.nvim Setup ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  spec = {
    -- Import all plugins from lua/plugins/
    { import = 'plugins' },
  },
  defaults = {
    -- By default, all plugins will be lazy-loaded
    lazy = true,
    version = false, -- Use the latest git version
  },
  install = {
    -- Try to load one of these colorschemes when starting an installation
    colorscheme = { 'gruvbox' },
  },
  checker = {
    enabled = true, -- Automatically check for plugin updates
    notify = false, -- Don't notify on update checks
  },
  change_detection = {
    notify = true, -- Don't notify when config changes
  },
  performance = {
    rtp = {
      -- Disable some built-in Neovim plugins to improve performance
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
}

-- Load keymaps from separate file
-- This is done at the end to ensure all plugins are loaded before keymaps that depend on them
require 'keymaps'
