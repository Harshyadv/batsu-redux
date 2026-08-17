-- ============================================================
-- KEYMAPS CONFIGURATION
-- All keymaps are centralized here for easy customization
-- ============================================================

-- ============================================================
-- BASIC KEYMAPS
-- ============================================================
do
  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`

  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config & Keymaps
  --  See `:help vim.diagnostic.Opts`
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- TIP: Disable arrow keys in normal mode
  -- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  -- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  -- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  -- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
  -- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
  -- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
  -- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
  -- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- ============================================================
-- TELESCOPE KEYMAPS
-- ============================================================
do
  -- Lazy handle: only actually requires telescope.builtin the first
  -- time one of these keymaps is triggered, not at startup.
  local function builtin()
    return require 'telescope.builtin'
  end

  vim.keymap.set('n', '<leader>sh', function() builtin().help_tags() end, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', function() builtin().keymaps() end, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', function() builtin().find_files() end, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', function() builtin().builtin() end, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', function() builtin().grep_string() end, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', function() builtin().live_grep() end, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', function() builtin().diagnostics() end, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', function() builtin().resume() end, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', function() builtin().oldfiles() end, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', function() builtin().commands() end, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', function() builtin().buffers() end, { desc = '[ ] Find existing buffers' })

  -- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf

      vim.keymap.set('n', 'grr', function() builtin().lsp_references() end, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gri', function() builtin().lsp_implementations() end, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'grd', function() builtin().lsp_definitions() end, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gO', function() builtin().lsp_document_symbols() end, { buffer = buf, desc = 'Open Document Symbols' })
      vim.keymap.set('n', 'gW', function() builtin().lsp_dynamic_workspace_symbols() end, { buffer = buf, desc = 'Open Workspace Symbols' })
      vim.keymap.set('n', 'grt', function() builtin().lsp_type_definitions() end, { buffer = buf, desc = '[G]oto [T]ype Definition' })
    end,
  })

  -- Override default behavior and theme when searching
  vim.keymap.set('n', '<leader>/', function()
    builtin().current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  vim.keymap.set('n', '<leader>s/', function()
    builtin().live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })

  -- Shortcut for searching your Neovim configuration files
  vim.keymap.set('n', '<leader>sn', function() builtin().find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })
end

-- ============================================================
-- LSP KEYMAPS
-- ============================================================
do
  -- [[ LSP Configuration ]]
  -- Brief aside: **What is LSP?**
  --
  -- LSP is an initialism you've probably heard, but might not understand what it is.
  --
  -- LSP stands for Language Server Protocol. It's a protocol that helps editors
  -- and language tooling communicate in a standardized fashion.
  --
  -- In general, you have a "server" which is some tool built to understand a particular
  -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
  -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
  -- processes that communicate with some "client" - in this case, Neovim!
  --
  -- LSP provides Neovim with features like:
  --  - Go to definition
  --  - Find references
  --  - Autocompletion
  --  - Symbol Search
  --  - and more!
  --
  -- Thus, Language Servers are external tools that must be installed separately from
  -- Neovim. This is where `mason` and related plugins come into play.
  --
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })
end

-- ============================================================
-- FORMATTING KEYMAPS
-- ============================================================
do
  -- [[ Formatting ]]
  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
end

-- ============================================================
-- AUTOCOMPLETE KEYMAPS
-- ============================================================
-- Note: Autocomplete keymaps are configured in the blink.cmp setup in init.lua
-- The default preset includes:
-- <c-y> to accept completion
-- <tab>/<s-tab> to move right/left in snippet expansion
-- <c-space> to open menu or docs
-- <c-n>/<c-p> or <up>/<down> to select next/previous item
-- <c-e> to hide menu
-- <c-k> to toggle signature help

-- ============================================================
-- OBSIDIAN KEYMAPS
-- ============================================================
do
  -- Vault Navigation & Notes
  vim.keymap.set('n', '<leader>on', '<cmd>Obsidian new<CR>', { desc = '[O]bsidian [N]ew note' })
  vim.keymap.set('n', '<leader>of', '<cmd>Obsidian quick_switch<CR>', { desc = '[O]bsidian [F]ind note (quick switch)' })
  vim.keymap.set('n', '<leader>os', '<cmd>Obsidian search<CR>', { desc = '[O]bsidian [S]earch (grep in vault)' })
  vim.keymap.set('n', '<leader>ot', '<cmd>Obsidian tags<CR>', { desc = '[O]bsidian [T]ags' })
  vim.keymap.set('n', '<leader>ob', '<cmd>Obsidian backlinks<CR>', { desc = '[O]bsidian [B]acklinks' })
  vim.keymap.set('n', '<leader>ol', '<cmd>Obsidian links<CR>', { desc = '[O]bsidian [L]inks in note' })
  vim.keymap.set('n', '<leader>oc', '<cmd>Obsidian toc<CR>', { desc = '[O]bsidian Table of [C]ontents' })
  vim.keymap.set('n', '<leader>oo', '<cmd>Obsidian open<CR>', { desc = '[O]bsidian [O]pen in desktop app' })
  vim.keymap.set('n', '<leader>ow', '<cmd>Obsidian workspace<CR>', { desc = '[O]bsidian Switch [W]orkspace' })
  vim.keymap.set('n', '<leader>op', '<cmd>Obsidian template<CR>', { desc = '[O]bsidian Insert Tem[p]late' })
  vim.keymap.set('n', '<leader>oi', '<cmd>Obsidian paste_img<CR>', { desc = '[O]bsidian Paste [I]mage' })
  vim.keymap.set('n', '<leader>or', '<cmd>Obsidian rename<CR>', { desc = '[O]bsidian [R]ename note' })

  -- Daily Notes
  vim.keymap.set('n', '<leader>od', '<cmd>Obsidian today<CR>', { desc = '[O]bsidian [D]aily note (today)' })
  vim.keymap.set('n', '<leader>oy', '<cmd>Obsidian yesterday<CR>', { desc = '[O]bsidian [Y]esterday daily note' })
  vim.keymap.set('n', '<leader>om', '<cmd>Obsidian tomorrow<CR>', { desc = '[O]bsidian To[m]orrow daily note' })

  -- Visual Mode Mappings (Linking & Extracting)
  vim.keymap.set('v', '<leader>oe', '<cmd>Obsidian extract_note<CR>', { desc = '[O]bsidian [E]xtract selection to note' })
  vim.keymap.set('v', '<leader>ok', '<cmd>Obsidian link<CR>', { desc = '[O]bsidian Lin[k] selection' })
  vim.keymap.set('v', '<leader>on', '<cmd>Obsidian link_new<CR>', { desc = '[O]bsidian Link selection to [N]ew note' })
end
