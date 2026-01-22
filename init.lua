--[[ 
My TODOS:
TODO:
- figure out how to use black. Does it have to be installed separately in every Python env.?
- similarly, how is nvim-dap currently installed / configured for Python.
- add more keybind description to which-key
--]]

--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   KICKSTART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Kickstart?

  Kickstart.nvim is *not* a distribution.

  Kickstart.nvim is a starting point for your own configuration.
    The goal is that you can read every line of code, top-to-bottom, understand
    what your configuration is doing, and modify it to suit your needs.

    Once you've done that, you can start exploring, configuring and tinkering to
    make Neovim your own! That might mean leaving Kickstart just the way it is for a while
    or immediately breaking it into modular pieces. It's up to you!

    If you don't know anything about Lua, I recommend taking some time to read through
    a guide. One possible example which will only take 10-15 minutes:
      - https://learnxinyminutes.com/docs/lua/

    After understanding a bit more about Lua, you can use `:help lua-guide` as a
    reference for how Neovim integrates Lua.
    - :help lua-guide
    - (or HTML version): https://neovim.io/doc/user/lua-guide.html

Kickstart Guide:

  TODO: The very first thing you should do is to run the command `:Tutor` in Neovim.

    If you don't know what this means, type the following:
      - <escape key>
      - :
      - Tutor
      - <enter key>

    (If you already know the Neovim basics, you can skip this step.)

  Once you've completed that, you can continue working through **AND READING** the rest
  of the kickstart init.lua.

  Next, run AND READ `:help`.
    This will open up a help window with some basic information
    about reading, navigating and searching the builtin help documentation.

    This should be the first place you go to look when you're stuck or confused
    with something. It's one of my favorite Neovim features.

    MOST IMPORTANTLY, we provide a keymap "<space>sh" to [s]earch the [h]elp documentation,
    which is very useful when you're not exactly sure of what you're looking for.

  I have left several `:help X` comments throughout the init.lua
    These are hints about where to find more information about the relevant settings,
    plugins or Neovim features used in Kickstart.

   NOTE: Look for lines like this

    Throughout the file. These are for you, the reader, to help you understand what is happening.
    Feel free to delete them once you know what you're doing, but they should serve as a guide
    for when you are first encountering a few different constructs in your Neovim config.

If you experience any errors while trying to install kickstart, run `:checkhealth` for more info.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now! :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable default mappings from vim-tmux-navigator (define unified ones to handle snacks.nvim terminal)
vim.g.tmux_navigator_no_mappings = 1

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
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
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Custom escape sequences for better UX
vim.keymap.set('i', 'kj', '<esc>', { noremap = true })
vim.keymap.set('i', 'jk', '<esc>', { noremap = true })
vim.keymap.set('n', 'q', '<esc>', { remap = true })
vim.keymap.set('v', 'q', '<esc>', { remap = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- I use vim-tmux-navigator instead
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Unified Neovim <-> Tmux navigation (normal & terminal, incl. snacks / Claude Code)
-- Requires: vim.g.tmux_navigator_no_mappings = 1 (set before plugin load)
local function TmuxWinNavigate(dir)
  -- Mapping from direction key to tmux-navigator command suffix
  local tmux_suffix = { h = 'Left', j = 'Down', k = 'Up', l = 'Right', p = 'Previous' }
  local fallback = { h = 'h', j = 'j', k = 'k', l = 'l' } -- wincmd fallbacks

  local function do_nav()
    local suffix = tmux_suffix[dir]
    if suffix and vim.fn.exists(':TmuxNavigate' .. suffix) == 2 then
      vim.cmd('silent! TmuxNavigate' .. suffix)
    else
      if fallback[dir] then
        vim.cmd('wincmd ' .. fallback[dir])
      end
    end
  end

  if vim.fn.mode() == 't' then
    -- Leave terminal mode first
    local esc = vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'n', false)
    -- Schedule so we only run after Neovim fully returns to normal mode
    vim.schedule(do_nav)
  else
    do_nav()
  end
end

local function map_nav(lhs, dir, desc)
  vim.keymap.set({ 'n', 't' }, lhs, function()
    TmuxWinNavigate(dir)
  end, { silent = true, desc = desc })
end

map_nav('<C-h>', 'h', 'Navigate Left (tmux/win)')
map_nav('<C-j>', 'j', 'Navigate Down (tmux/win)')
map_nav('<C-k>', 'k', 'Navigate Up (tmux/win)')
map_nav('<C-l>', 'l', 'Navigate Right (tmux/win)')
map_nav('<C-\\>', 'p', 'Navigate Previous (tmux/win)')

-- (Optional but robust) Ensure mappings are always present for newly created terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('user-term-tmux-nav', { clear = true }),
  pattern = '*',
  callback = function(ev)
    for _, spec in ipairs {
      { '<C-h>', 'h' },
      { '<C-j>', 'j' },
      { '<C-k>', 'k' },
      { '<C-l>', 'l' },
      { '<C-\\>', 'p' },
    } do
      local lhs, dir = spec[1], spec[2]
      vim.keymap.set('t', lhs, function()
        TmuxWinNavigate(dir)
      end, { silent = true, buffer = ev.buf })
    end
  end,
  desc = 'Terminal tmux-style navigation',
})

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  -- Move seamlessly between vim and tmux panes using C+[hjkl]
  'christoomey/vim-tmux-navigator',

  -- GitHub Copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },
  {
    'giuxtaposition/blink-cmp-copilot',
    dependencies = { 'zbirenbaum/copilot.lua' },
  },

  -- Faster motions with hop
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    opts = {
      keys = 'etovxqpdygfblzhckisuran',
    },
  },

  -- Run selected code in neighboring tmux pane (e.g. ipython)
  { 'jpalardy/vim-slime', ft = 'python' },

  -- Tree-based file explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      sort_by = 'case_sensitive',
      view = { adaptive_size = true },
      renderer = { group_empty = true },
      filters = { dotfiles = true },
    },
  },

  -- Directory-based file explorer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
        },
        view_options = {
          show_hidden = true,
        },
      }
      -- Open parent direcory in current window
      vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })
      -- Open parent direcory in floating window
      vim.keymap.set('n', '<leader>-', require('oil').toggle_float, { desc = 'Open floating parent directory' })
    end,
  },

  -- Floating terminal
  'numToStr/FTerm.nvim',

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- gp.nvim agent picker for telescope
      'undg/telescope-gp-agent-picker.nvim',

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        defaults = {
          mappings = {
            i = {
              ['<c-enter>'] = 'to_fuzzy_refine',
            },
            n = {
              ['q'] = require('telescope.actions').close,
              ['dd'] = require('telescope.actions').delete_buffer,
            },
          },
        },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'gp_picker')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>l', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = true,
        })
      end, { desc = '[L] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
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

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        -- Python LSP
        pyright = {},

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'black', -- Python formatter - install manually if needed
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "black" }, -- Uncomment when black is available
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'copilot' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          copilot = {
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
          },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Additional colorscheme
  'tiagovla/tokyodark.nvim',

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- Simple and easy commenting
      local comment = require 'mini.comment'
      comment.setup {
        options = {
          custom_commentstring = nil,
        },
        mappings = {
          comment_line = '<leader>/',
          comment_visual = '<leader>/',
          textobject = 'gc',
        },
      }

      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- LLM chat support in a Neovim-native style
  {
    'robitx/gp.nvim',
    config = function()
      local gp_conf = {
        -- For customization, refer to Install > Configuration in the Documentation/Readme
        providers = {
          openai = {
            endpoint = 'https://api.openai.com/v1/chat/completions',
            secret = os.getenv 'OPENAI_API_KEY',
          },
          copilot = {
            endpoint = 'https://api.githubcopilot.com/chat/completions',
            secret = {
              'bash',
              '-c',
              "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
            },
          },
          anthropic = {
            endpoint = 'https://api.anthropic.com/v1/messages',
            secret = os.getenv 'ANTHROPIC_API_KEY',
          },
        },

        agents = {
          {
            name = 'ExampleDisabledAgent',
            disable = true,
          },
          {
            name = 'ChatGPT4o',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'gpt-4o', temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'openai',
            name = 'ChatGPT4o-mini',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'gpt-4o-mini', temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'openai',
            name = 'ChatChatGPT4o',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'chatgpt-4o-latest', temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'copilot',
            name = 'ChatCopilot',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'gpt-4o', temperature = 1.1, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'anthropic',
            name = 'ChatClaude-3-7-Sonnet',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'claude-3-7-sonnet-latest', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'anthropic',
            name = 'ChatClaude-Sonnet-4',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'claude-sonnet-4-20250514', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'anthropic',
            name = 'ChatClaude-Opus-4.1',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'claude-opus-4-1-20250805', temperature = 0.8 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'anthropic',
            name = 'ChatClaude-3-Haiku',
            chat = true,
            command = false,
            -- string with model name or table with model name and parameters
            model = { model = 'claude-3-haiku-20240307', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').chat_system_prompt,
          },
          {
            provider = 'openai',
            name = 'CodeGPT4o',
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = 'gpt-4o', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').code_system_prompt,
          },
          {
            provider = 'openai',
            name = 'CodeGPT4o-mini',
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = 'gpt-4o-mini', temperature = 0.7, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = 'Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```',
          },
          {
            provider = 'openai',
            name = 'CodeChatGPT4o',
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = 'chatgpt-4o-latest', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').code_system_prompt,
          },
          {
            provider = 'copilot',
            name = 'CodeCopilot',
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = 'gpt-4o', temperature = 0.8, top_p = 1, n = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = require('gp.defaults').code_system_prompt,
          },
          {
            provider = 'anthropic',
            name = 'CodeClaude-3-7-Sonnet',
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = 'claude-3-7-sonnet-latest', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = 'Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```',
          },
          {
            provider = 'anthropic',
            name = 'CodeClaude-Sonnet-4',
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = 'claude-sonnet-4-20250514', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = 'Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```',
          },
          {
            provider = 'anthropic',
            name = 'CodeClaude-Opus-4.1',
            chat = false,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = 'claude-opus-4-1-20250805', temperature = 0.8, top_p = 1 },
            -- system prompt (use this to specify the persona/role of the AI)
            system_prompt = 'Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```',
          },
        },

        -- directory for storing chat files
        chat_dir = '/home/fs/data/opt_files/gp.nvim/chats',

        -- image generation settings
        image = {
          store_dir = '/home/fs/data/opt_files/gp.nvim/images',
        },

        -- (be careful to choose something which will work across specified modes)
        chat_shortcut_respond = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-q><C-q>' },
        chat_shortcut_delete = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-q>d' },
        chat_shortcut_stop = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-q>s' },
        chat_shortcut_new = { modes = { 'n', 'i', 'v', 'x' }, shortcut = '<C-q>c' },

        whisper = {
          -- you can disable whisper completely by whisper = {disable = true}
          disable = false,

          -- OpenAI audio/transcriptions api endpoint to transcribe audio to text
          endpoint = 'https://api.openai.com/v1/audio/transcriptions',
          -- directory for storing whisper files
          store_dir = (os.getenv 'TMPDIR' or os.getenv 'TEMP' or '/tmp') .. '/gp_whisper',
          -- multiplier of RMS level dB for threshold used by sox to detect silence vs speech
          -- decibels are negative, the recording is normalized to -3dB =>
          -- increase this number to pick up more (weaker) sounds as possible speech
          -- decrease this number to pick up only louder sounds as possible speech
          -- you can disable silence trimming by setting this a very high number (like 1000.0)
          silence = '1.75',
          -- whisper tempo (1.0 is normal speed)
          tempo = '1.75',
          -- The language of the input audio, in ISO-639-1 format.
          language = 'en',
          -- command to use for recording can be nil (unset) for automatic selection
          -- string ("sox", "arecord", "ffmpeg") or table with command and arguments:
          -- sox is the most universal, but can have start/end cropping issues caused by latency
          -- arecord is linux only, but has no cropping issues and is faster
          -- ffmpeg in the default configuration is macos only, but can be used on any platform
          -- (see https://trac.ffmpeg.org/wiki/Capture/Desktop for more info)
          -- below is the default configuration for all three commands:
          -- whisper_rec_cmd = {"sox", "-c", "1", "--buffer", "32", "-d", "rec.wav", "trim", "0", "60:00"},
          -- whisper_rec_cmd = {"arecord", "-c", "1", "-f", "S16_LE", "-r", "48000", "-d", "3600", "rec.wav"},
          -- whisper_rec_cmd = {"ffmpeg", "-y", "-f", "avfoundation", "-i", ":0", "-t", "3600", "rec.wav"},
          rec_cmd = nil,
        },
      }
      require('gp').setup(gp_conf)
    end,
  },

  -- Claude Code Neovim integration
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    opts = {
      terminal_cmd = 'claude', -- Use command from PATH
    },
    config = true,
    keys = {
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude Code' },
    },
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- [[ Custom Configuration ]]

-- Custom scroll amount (25% instead of 50%)
vim.keymap.set('n', '<C-d>', function()
  local win_height = vim.api.nvim_win_get_height(0)
  local scroll_amount = math.floor(win_height / 4)
  vim.cmd('normal! ' .. scroll_amount .. 'j')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<C-u>', function()
  local win_height = vim.api.nvim_win_get_height(0)
  local scroll_amount = math.floor(win_height / 4)
  vim.cmd('normal! ' .. scroll_amount .. 'k')
end, { noremap = true, silent = true })

-- Vim Slime configuration
vim.g.slime_target = 'tmux'
vim.g.slime_python_ipython = 1

-- Configure slime for tmux if in tmux session
local function istmux()
  return os.getenv 'TMUX' ~= nil
end

if istmux() then
  local tmux_socket = os.getenv('TMUX'):match '([^,]+)'
  vim.g.slime_default_config = {
    socket_name = tmux_socket,
    target_pane = '{bottom-right}',
  }
  vim.g.slime_dont_ask_default = 1
end

-- Hop keymaps
vim.keymap.set('', '<leader>h', function()
  require('hop').hint_words()
end)
vim.keymap.set('', '<leader>H', function()
  require('hop').hint_words { current_line_only = true }
end)
vim.keymap.set('', '<leader>j', function()
  require('hop').hint_char1 { current_line_only = true }
end)
vim.keymap.set('', '<leader>J', function()
  require('hop').hint_char1()
end)
vim.keymap.set('', '<leader>k', function()
  require('hop').hint_lines()
end)

-- Hop colors
vim.cmd 'hi HopNextKey guifg=#ff9900'
vim.cmd 'hi HopNextKey1 guifg=#ff9900'
vim.cmd 'hi HopNextKey2 guifg=#ff9900'

-- NvimTree toggle
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>')

-- FTerm toggle
vim.keymap.set('n', '<A-\\>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<A-\\>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- Jupyter cell execution
local select_jupyter_cell = function()
  local current_line = vim.fn.getline '.'
  if current_line:match '^# %%' then
    vim.cmd 'normal! V'
    vim.cmd '/# %%\\|\\%$'
  else
    vim.cmd '?# %%'
    vim.cmd 'normal! V'
    vim.cmd '/# %%\\|\\%$'
  end
  if vim.fn.getline '.' == '# %%' then
    vim.cmd 'normal! k'
  end
  vim.cmd 'nohlsearch'
end

vim.keymap.set('n', 'vcc', select_jupyter_cell, { silent = true })
vim.keymap.set('n', '<leader>cc', function()
  select_jupyter_cell()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c><C-c>', true, false, true), 'm', true)
end, { silent = true })

vim.keymap.set('n', '<leader>cx', function()
  vim.cmd '/# %%\\|\\%$'
  select_jupyter_cell()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c><C-c>', true, false, true), 'm', true)
end, { silent = true })

-- [[ GP.NVIM Keymaps ]]
-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
local function keymapOptionsGp(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = 'GPT prompt ' .. desc,
  }
end

-- Chat commands
-- many commands have both a <C-q> and <leader>q binding on purpose
-- GpChatNew
vim.keymap.set({ 'n', 'i' }, '<C-q>n', '<cmd>GpChatNew<cr>', keymapOptionsGp 'New Chat')
vim.keymap.set({ 'n' }, '<leader>qn', '<cmd>GpChatNew<cr>', keymapOptionsGp 'New Chat')
vim.keymap.set('v', '<C-q>n', ":<C-u>'<,'>GpChatNew<cr>", keymapOptionsGp 'Visual Chat New')
vim.keymap.set('v', '<leader>qn', ":<C-u>'<,'>GpChatNew<cr>", keymapOptionsGp 'Visual Chat New')
-- GpChatToggle
vim.keymap.set({ 'n', 'i' }, '<C-q>t', '<cmd>GpChatToggle<cr>', keymapOptionsGp 'Toggle Chat')
vim.keymap.set({ 'n' }, '<leader>qt', '<cmd>GpChatToggle<cr>', keymapOptionsGp 'Toggle Chat')
vim.keymap.set('v', '<C-q>t', ":<C-u>'<,'>GpChatToggle<cr>", keymapOptionsGp 'Visual Toggle Chat')
vim.keymap.set('v', '<leader>qt', ":<C-u>'<,'>GpChatToggle<cr>", keymapOptionsGp 'Visual Toggle Chat')
-- GpChatFinder
vim.keymap.set({ 'n', 'i' }, '<C-q>f', '<cmd>GpChatFinder<cr>', keymapOptionsGp 'Chat Finder')
vim.keymap.set({ 'n' }, '<leader>qf', '<cmd>GpChatFinder<cr>', keymapOptionsGp 'Chat Finder')
-- GpChatPaste
vim.keymap.set('v', '<C-q>p', ":<C-u>'<,'>GpChatPaste<cr>", keymapOptionsGp 'Visual Chat Paste')
vim.keymap.set('v', '<leader>qp', ":<C-u>'<,'>GpChatPaste<cr>", keymapOptionsGp 'Visual Chat Paste')
-- GpChatNew split, vsplit, tabnew
vim.keymap.set({ 'n', 'i' }, '<C-q><C-x>', '<cmd>GpChatNew split<cr>', keymapOptionsGp 'New Chat split')
vim.keymap.set({ 'n' }, '<leader>qx', '<cmd>GpChatNew split<cr>', keymapOptionsGp 'New Chat split')
vim.keymap.set({ 'n', 'i' }, '<C-q><C-v>', '<cmd>GpChatNew vsplit<cr>', keymapOptionsGp 'New Chat vsplit')
vim.keymap.set({ 'n' }, '<leader>qv', '<cmd>GpChatNew vsplit<cr>', keymapOptionsGp 'New Chat vsplit')
vim.keymap.set({ 'n', 'i' }, '<C-q><C-,>', '<cmd>GpChatNew tabnew<cr>', keymapOptionsGp 'New Chat tabnew')
vim.keymap.set({ 'n' }, '<leader>q,', '<cmd>GpChatNew tabnew<cr>', keymapOptionsGp 'New Chat tabnew')
vim.keymap.set('v', '<C-q><C-x>', ":<C-u>'<,'>GpChatNew split<cr>", keymapOptionsGp 'Visual Chat New split')
vim.keymap.set('v', '<leader>qx', ":<C-u>'<,'>GpChatNew split<cr>", keymapOptionsGp 'Visual Chat New split')
vim.keymap.set('v', '<C-q><C-v>', ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptionsGp 'Visual Chat New vsplit')
vim.keymap.set('v', '<leader>qv', ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptionsGp 'Visual Chat New vsplit')
vim.keymap.set('v', '<C-q><C-,>', ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptionsGp 'Visual Chat New tabnew')
vim.keymap.set('v', '<leader>q,', ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptionsGp 'Visual Chat New tabnew')

-- Prompt commands
-- GpRewrite, GpAppend, GpPrepend
vim.keymap.set({ 'n', 'i' }, '<C-q>e', '<cmd>GpRewrite<cr>', keymapOptionsGp 'Inline Rewrite')
vim.keymap.set({ 'n' }, '<leader>qe', '<cmd>GpRewrite<cr>', keymapOptionsGp 'Inline Rewrite')
vim.keymap.set({ 'n', 'i' }, '<C-q>a', '<cmd>GpAppend<cr>', keymapOptionsGp 'Append (after)')
vim.keymap.set({ 'n' }, '<leader>qa', '<cmd>GpAppend<cr>', keymapOptionsGp 'Append (after)')
vim.keymap.set({ 'n', 'i' }, '<C-q>z', '<cmd>GpPrepend<cr>', keymapOptionsGp 'Prepend (before)')
vim.keymap.set({ 'n' }, '<leader>qz', '<cmd>GpPrepend<cr>', keymapOptionsGp 'Prepend (before)')
vim.keymap.set('v', '<C-q>e', ":<C-u>'<,'>GpRewrite<cr>", keymapOptionsGp 'Visual Rewrite')
vim.keymap.set('v', '<leader>qe', ":<C-u>'<,'>GpRewrite<cr>", keymapOptionsGp 'Visual Rewrite')
vim.keymap.set('v', '<C-q>a', ":<C-u>'<,'>GpAppend<cr>", keymapOptionsGp 'Visual Append (after)')
vim.keymap.set('v', '<leader>qa', ":<C-u>'<,'>GpAppend<cr>", keymapOptionsGp 'Visual Append (after)')
vim.keymap.set('v', '<C-q>z', ":<C-u>'<,'>GpPrepend<cr>", keymapOptionsGp 'Visual Prepend (before)')
vim.keymap.set('v', '<leader>qz', ":<C-u>'<,'>GpPrepend<cr>", keymapOptionsGp 'Visual Prepend (before)')

-- GpNew, GpVnew
vim.keymap.set({ 'n', 'i' }, '<C-q>wx', '<cmd>GpNew<cr>', keymapOptionsGp 'GpNew')
vim.keymap.set({ 'n', 'i' }, '<leader>qwx', '<cmd>GpNew<cr>', keymapOptionsGp 'GpNew')
vim.keymap.set({ 'n', 'i' }, '<C-q>wv', '<cmd>GpVnew<cr>', keymapOptionsGp 'GpVnew')
vim.keymap.set({ 'n', 'i' }, '<leader>qwv', '<cmd>GpVnew<cr>', keymapOptionsGp 'GpVnew')
vim.keymap.set('v', '<C-q>wx', ":<C-u>'<,'>GpNew<cr>", keymapOptionsGp 'Visual GpNew')
vim.keymap.set('v', '<leader>qwx', ":<C-u>'<,'>GpNew<cr>", keymapOptionsGp 'Visual GpNew')
vim.keymap.set('v', '<C-q>wv', ":<C-u>'<,'>GpVnew<cr>", keymapOptionsGp 'Visual GpVnew')
vim.keymap.set('v', '<leader>qwv', ":<C-u>'<,'>GpVnew<cr>", keymapOptionsGp 'Visual GpVnew')

vim.keymap.set({ 'n', 'i', 'v', 'x' }, '<C-q>s', '<cmd>GpStop<cr>', keymapOptionsGp 'Stop')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>qs', '<cmd>GpStop<cr>', keymapOptionsGp 'Stop')

-- GP.NVIM Whisper
vim.keymap.set({ 'n', 'i' }, '<C-q>ww', '<cmd>GpWhisper<cr>', keymapOptionsGp 'Whisper')
vim.keymap.set({ 'n' }, '<leader>ww', '<cmd>GpWhisper<cr>', keymapOptionsGp 'Whisper')
vim.keymap.set('v', '<C-q>ww', ":<C-u>'<,'>GpWhisper<cr>", keymapOptionsGp 'Visual Whisper')
vim.keymap.set('v', '<leader>ww', ":<C-u>'<,'>GpWhisper<cr>", keymapOptionsGp 'Visual Whisper')

-- GP.NVIM Telescope agent picker
vim.keymap.set('n', '<leader>fa', '<cmd>Telescope gp_picker agent<cr>', { desc = 'GP Agent Picker' })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
