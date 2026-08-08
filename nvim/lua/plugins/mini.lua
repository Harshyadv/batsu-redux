-- Collection of small independent plugins (mini.nvim)
return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'VimEnter',
  config = function()
    -- Icons
    if vim.g.have_nerd_font then
      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()
    end

    -- Textobjects (Better Around/Inside)
    require('mini.ai').setup {
      mappings = {
        around_next = 'aa',
        inside_next = 'ii',
      },
      n_lines = 500,
    }

    -- Surround (Add/delete/replace surroundings)
    require('mini.surround').setup()

    -- Starter / Dashboard & Session Management
    local session_dir = vim.fn.stdpath 'data' .. '/sessions/'
    vim.fn.mkdir(session_dir, 'p')

    local function session_file()
      local uv = vim.uv or vim.loop
      local cwd = uv.fs_realpath(vim.fn.getcwd()) or vim.fn.getcwd()
      local encoded_cwd = cwd:gsub('[\\/:]', '_')
      return session_dir .. encoded_cwd .. '.vim'
    end

    local function has_real_buffers()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) ~= '' then
          return true
        end
      end
      return false
    end

    vim.api.nvim_create_user_command('RestoreSession', function()
      local file = session_file()
      if vim.fn.filereadable(file) == 1 then
        vim.cmd('source ' .. vim.fn.fnameescape(file))
        vim.notify('Session restored successfully', vim.log.levels.INFO)
      else
        vim.notify('No saved session for this directory', vim.log.levels.WARN)
      end
    end, {})

    -- Save session on exit (only if real file buffers were open)
    local session_group = vim.api.nvim_create_augroup('AutoSessionSave', { clear = true })
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = session_group,
      callback = function()
        if has_real_buffers() then
          pcall(vim.cmd, 'Neotree close')
          vim.cmd('mksession! ' .. vim.fn.fnameescape(session_file()))
        end
      end,
    })

    local starter = require 'mini.starter'
    starter.setup {
      evaluate_single = true,
      header = function()
        return "Hey Harsh, it's " .. os.date '%H:%M of %d/%m/%Y'
      end,
      items = {
        starter.sections.recent_files(5),
        { name = 'Restore Session', action = 'RestoreSession', section = 'Session' },
        { name = 'Open file', action = 'Telescope find_files', section = 'Builtin actions' },
        { name = 'Lazy config', action = 'Lazy', section = 'Builtin actions' },
        starter.sections.builtin_actions(),
      },
      footer = function()
        local stats = require('lazy').stats()
        local startup_time = string.format('%.2f', stats.startuptime)
        local v = vim.version()
        local nvim_version = string.format('v%d.%d.%d', v.major, v.minor, v.patch)
        return '⚡ Neovim ' .. nvim_version .. ' loaded in ' .. startup_time .. 'ms'
      end,
    }

    -- Force a refresh right after startup sequence finishes
    vim.schedule(function()
      starter.refresh()
    end)
  end,
}

