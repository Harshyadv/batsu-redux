local function get_workspaces()
  local vaults = {
    { name = 'HarshPro', rel = 'Harsh/HarshPro' },
    { name = 'HarshPer', rel = 'Harsh/.HarshPer' },
  }

  local resolved = {}
  for _, vault in ipairs(vaults) do
    local candidates = {
      vim.fn.expand('~/Documents/Notes/' .. vault.rel),
      'D:/Documents/Notes/' .. vault.rel,
    }
    for _, path in ipairs(candidates) do
      if vim.fn.isdirectory(path) == 1 then
        table.insert(resolved, { name = vault.name, path = path })
        break
      end
    end
  end

  return resolved
end

local workspaces = get_workspaces()

return {
  'obsidian-nvim/obsidian.nvim',
  version = '*', -- Recommended: use latest release
  lazy = true,
  ft = { 'markdown', 'quarto' },
  cond = function()
    return #workspaces > 0
  end,
  cmd = {
    'Obsidian',
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'saghen/blink.cmp',
  },
  ---@type obsidian.config
  opts = {
    -- Disable legacy command format (ObsidianNew -> Obsidian new)
    legacy_commands = false,

    -- Workspaces: define your Obsidian vaults
    workspaces = workspaces,

    -- Where new notes are created by default ("current_dir" or "notes_subdir")
    new_notes_location = 'current_dir',

    -- Daily notes configuration
    daily_notes = {
      folder = 'Daily',
      date_format = '%Y-%m-%d',
      alias_format = '%B %-d, %Y',
      default_tags = { 'daily-notes' },
      template = nil,
      workdays_only = false,
    },

    -- Preferred picker
    picker = {
      name = 'telescope.nvim',
      note_mappings = {
        new = '<C-x>',
        insert_link = '<C-l>',
      },
      tag_mappings = {
        tag_note = '<C-x>',
        insert_tag = '<C-l>',
      },
    },

    -- Customize how note IDs and file names are generated
    note_id_func = function(title)
      if title ~= nil then
        return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-_]', ''):lower()
      else
        local suffix = ''
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return tostring(os.time()) .. '-' .. suffix
      end
    end,

    note_path_func = function(spec)
      local path = spec.dir / tostring(spec.title or spec.id)
      return path:with_suffix '.md'
    end,

    -- Link style & auto update on file rename
    link = {
      style = 'wiki',
      format = 'shortest',
      auto_update = true,
    },

    -- Disable internal UI decorations to let render-markdown.nvim handle all styling seamlessly
    ui = {
      enable = false,
    },

    -- Attachments configuration (images pasted with :Obsidian paste_img)
    attachments = {
      folder = 'attachments',
      confirm_img_paste = true,
      img_name_func = function()
        return string.format('%s-', os.time())
      end,
    },

    -- Callbacks for vault notes
    callbacks = {
      ---@param note obsidian.Note
      enter_note = function(note)
        -- Buffer-local keymaps for notes
        local opts = { buffer = true, silent = true }

        -- Toggle checkbox
        vim.keymap.set('n', '<leader>ch', '<cmd>Obsidian toggle_checkbox<cr>', vim.tbl_extend('force', opts, { desc = 'Toggle checkbox' }))

        -- Follow link under cursor
        vim.keymap.set('n', 'gf', '<cmd>Obsidian follow_link<cr>', vim.tbl_extend('force', opts, { desc = 'Follow Obsidian link' }))

        -- Smart action on <CR> (follow link or toggle checkbox depending on cursor)
        vim.keymap.set('n', '<CR>', function()
          return require('obsidian').util.smart_action()
        end, vim.tbl_extend('force', opts, { expr = true, desc = 'Obsidian smart action' }))
      end,
    },
  },
}
