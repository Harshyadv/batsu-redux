-- Autocomplete and snippets
return {
  {
    'L3MON4D3/LuaSnip',
    version = 'v2.*',
    event = 'InsertEnter',
    build = (function()
      if vim.fn.has 'win32' == 1 then
        return nil -- Don't build on Windows
      elseif vim.fn.executable 'make' == 1 then
        return 'make install_jsregexp'
      else
        return nil
      end
    end)(),
    config = function()
      require('luasnip').setup {}
    end,
  },
  {
    'saghen/blink.cmp',
    version = '*',
    event = 'InsertEnter',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      keymap = {
        preset = 'super-tab',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
    opts_extend = { 'sources.default' },
  },
}

