-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

-- disable netrw file explorer (advised by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- 'j-hui/fidget.nvim',
      {
      'j-hui/fidget.nvim',
      tag = 'legacy',
      config = function()
        require("fidget").setup {
          -- options
        }
      end,
      },

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    -- Optional completion sources for nvim-cmp
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
  }

  -- -- Tabnine AI autocompletion
  -- use { 'codota/tabnine-nvim', run = "./dl_binaries.sh" }
  -- use {
  --   'tzachar/cmp-tabnine',
  --   run='./install.sh',
  --   requires = 'hrsh7th/nvim-cmp'
  -- }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use { -- Highlight TODO, FIX, HACK, etc.
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- Github Copilot
  use {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  }
  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  }

  -- -- Codeium (unofficial with nvim-cmp support)
  -- use {
  --   "Exafunction/codeium.nvim",
  --   requires = {
  --       "nvim-lua/plenary.nvim",
  --       "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --       require("codeium").setup({
  --       })
  --   end
  -- }

  -- -- Codeium (official with virtual text)
  -- -- use 'Exafunction/codeium.vim'
  -- use {
  --   'Exafunction/codeium.vim',
  --   config = function ()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set('i', '<leader><Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  --   end
  -- }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  -- VimTex
  use 'lervag/vimtex'

  -- colorschemes
  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'marko-cerovac/material.nvim'
  use 'EdenEast/nightfox.nvim'
  use 'tiagovla/tokyodark.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Move seamlessly between vin and tmux panes using C+[hjkl] 
  use { 'christoomey/vim-tmux-navigator' }

  -- Run selected code in neighboring tmux pane e.g. ipython
  use { 'jpalardy/vim-slime', ft = 'python' }

  use { -- Faster motions
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  -- Floating terminal
 use "numToStr/FTerm.nvim"

  use { -- File explorer
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use({
      "kylechui/nvim-surround",
      tag = "*", -- Use for stability; omit to use `main` branch for the latest features
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
  })

  -- Debugging
  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-dap-python'
  use { "rcarriga/nvim-dap-ui", requires = {"nvim-neotest/nvim-nio"} }
  use 'rcarriga/cmp-dap'
  -- use 'jayp0521/mason-nvim-dap.nvim'

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
-- vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
-- Relative line numbers
vim.wo.relativenumber = true

-- Highlight the current line
vim.o.cursorline = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Convert tabs to spaces
vim.o.expandtab = true

-- Copy between nvim and everything else
vim.o.clipboard = 'unnamedplus'

-- Save undo history
-- vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
-- vim.cmd [[colorscheme onedark]]
-- vim.g.material_style = "deep ocean"
-- vim.cmd [[colorscheme material]]
-- init.lua
vim.g.tokyodark_transparent_background = true
vim.g.tokyodark_enable_italic_comment = true
vim.g.tokyodark_enable_italic = true
vim.g.tokyodark_color_gamma = '1.0'
vim.cmd('colorscheme tokyodark')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    -- theme = 'onedark',
    -- theme = 'material',
    theme = 'tokyodark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup {
    ---LHS of toggle mappings in NORMAL mode
    toggler = {
        ---Line-comment toggle keymap
        -- line = 'gcc',
        line = '<leader>/',
        ---Block-comment toggle keymap
        block = 'gbc',
    },
    ---LHS of operator-pending mappings in NORMAL and VISUAL mode
    opleader = {
        ---Line-comment keymap
        -- line = 'gc',
        line = '<leader>/',
        ---Block-comment keymap
        block = 'gb',
    },
    ---LHS of extra mappings
    extra = {
        ---Add comment on the line above
        above = 'gcO',
        ---Add comment on the line below
        below = 'gco',
        ---Add comment at the end of line
        eol = 'gcA',
    },
}

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('ibl').setup {
  indent = {
    char = '┊',
  }
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
      n = {
        ['q'] = require('telescope.actions').close,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>l', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').commands, { desc = '[S]earch [C]ommands' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'lua', 'python', 'help', 'vim' },

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to definh shsmall helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('KK', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {

  -- pylsp = {},
  -- install Ruff via :PylspInstall python-lsp-ruff in each venv
  -- pylsp = {
  --   pylsp = {
  --     plugins = {
  --       ruff = { enabled = false },
  --       flake8 = { enabled = false },
  --       pycodestyle = { enabled = true },
  --       mccabe = { enabled = true },
  --       pyflakes = { enabled = true },
  --       jedi_completion = {
  --         cache_for = { "pandas", "numpy", "pytorch", "tensorflow", "matplotlib" }
  --       },
  --     },
  --     configurationSources =  'flake8'
  --   },
  -- },
  pylsp = {
    pylsp = {
      plugins = {
        pycodestyle = {
          -- ignore = {'E402'},
          ignore = {'E501'},
          maxLineLength = 100
        },
        -- black = {
        --   enabled = true,
        --   line_length = 100,
        --   preview = true
        -- },
      },
    },
  },

  -- sumneko_lua = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()
--
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- Below snip, doesn't appear in my completion suggestions
-- -- Latex-specific snippet; type frac and change to \frac{}{},
-- -- moving curson inside the first bracket
-- luasnip.parser.parse_snippet("frac", "\\frac{${1:numerator}}{${2:denominator}}$0")

cmp.setup {
  -- MY ADDITION
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        or require("cmp_dap").is_dap_buffer()
  end,
  -- MY ADDITION END
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      -- select = true,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    -- { name = 'cmp_tabnine' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'copilot' },
    -- { name = "codeium" },
  },
}
-- MY ADDITION
require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
  sources = {
    { name = "dap" },
  },
})
-- MY ADDITION END

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- MY CONFIGS FISO

-- pressing <esc> disables highlights until next search
vim.keymap.set('n', '<esc>', ':noh<return><esc>', { noremap = true })
-- map 'kj' to <esc> because xps plus's touch esc is bad
vim.keymap.set('i', 'kj', '<esc>', { noremap = true })
vim.keymap.set('i', 'jk', '<esc>', { noremap = true })
-- vim.keymap.set('i', 'lk', '<esc>', { noremap = true })
vim.keymap.set('n', 'q', '<esc>', { remap = true })
vim.keymap.set('v', 'q', '<esc>', { remap = true })

-- set ctrl-d and ctrl-u to 25% of screen hight instead of the default 50%
-- Function to scroll down by 25% of the window height
vim.keymap.set('n', '<C-d>', function()
  local win_height = vim.api.nvim_win_get_height(0)
  local scroll_amount = math.floor(win_height / 4)
  -- Move the cursor down by scroll_amount lines
  vim.cmd('normal! ' .. scroll_amount .. 'j')
  -- Center the screen if desired
  -- vim.cmd('normal! zz')
end, { noremap = true, silent = true })

-- Function to scroll up by 25% of the window height
vim.keymap.set('n', '<C-u>', function()
  local win_height = vim.api.nvim_win_get_height(0)
  local scroll_amount = math.floor(win_height / 4)
  -- Move the cursor up by scroll_amount lines
  vim.cmd('normal! ' .. scroll_amount .. 'k')
  -- Center the screen if desired
  -- vim.cmd('normal! zz')
end, { noremap = true, silent = true })
--
-- vim.keymap.set('n', '<C-d>', (vim.api.nvim_win_get_height(0) / 4 - 1) .. '<C-d>')
-- vim.keymap.set('n', '<C-u>', (vim.api.nvim_win_get_height(0) / 4 - 1) .. '<C-u>')

-- VIM SLIME
vim.g.slime_target = "tmux"

vim.g.slime_python_ipython = 1
-- vim.slime_bracketed_paste = 1

function string.split(str, sep)
    local fields = {}
    str:gsub("([^"..sep.."]+)", function(c) fields[#fields+1] = c end)
    return fields
end

local function istmux()
  return os.getenv("TMUX") ~= nil
end

if istmux() then
  vim.g.slime_default_config = {
          socket_name = string.split(os.getenv("TMUX"), ",")[1],
          target_pane = "{bottom-right}"
  }
  vim.g.slime_dont_ask_default = 1
end

-- HOP
require('hop').setup()
vim.keymap.set('', '<leader>h', require('hop').hint_words)
vim.keymap.set('', '<leader>H', function()
  require('hop').hint_words({ current_line_only = true })
end)
vim.keymap.set('', '<leader>j', function()
  require('hop').hint_char1({ current_line_only = true })
end)
vim.keymap.set('', '<leader>J', require('hop').hint_char1)
vim.keymap.set('', '<leader>k', require('hop').hint_lines)

vim.cmd("hi HopNextKey guifg=#ff9900")
vim.cmd("hi HopNextKey1 guifg=#ff9900")
vim.cmd("hi HopNextKey2 guifg=#ff9900")

-- NVIM-TREE
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<CR>')

-- NVIM-SURROUND
require('nvim-surround').setup()

-- NVIM-DAP-PYTHON
-- the way I understand this, the line below just refers to debugpy config
-- the way init.lua dap config looks rn debugpy needs to be installed in every debugged env.
require('dap-python').setup('~/opt/miniconda3/envs/debugpy/bin/python')
-- replaced the above with
-- require("mason-nvim-dap").setup({
--     ensure_installed = { "python" }
-- })

-- NVIM-DAP
-- vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>", { silent = true })
-- vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>") -- , { silent = true })
vim.keymap.set('n', '<F6>', ":lua require'dap'.step_over()<CR>") -- , { silent = true })
vim.keymap.set('n', '<F7>', ":lua require'dap'.step_into()<CR>") -- , { silent = true })
vim.keymap.set('n', '<F8>', ":lua require'dap'.step_out()<CR>") -- , { silent = true })
vim.keymap.set('n', '<F9>', ":lua require'dap'.terminate()<CR>") -- , { silent = true })
vim.keymap.set('n', '<F10>', ":lua require'dap'.pause()<CR>") -- , { silent = true })
vim.keymap.set('n', '<leader>b', ":lua require'dap'.toggle_breakpoint()<CR>") -- , { silent = true })
vim.keymap.set('n', '<leader>B', [[:lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]]) -- , { silent = true })
vim.keymap.set('n', '<leader>dp', [[:lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]]) -- , { silent = true })
vim.keymap.set('n', '<leader>dr', ":lua require'dap'.repl.open()<CR>") -- , { silent = true })
vim.keymap.set('n', '<leader>dl', ":lua require'dap'.run_last()<CR>") -- , { silent = true })
vim.keymap.set('n', '<leader>dc', ":lua require'dap'.run_to_cursor()<CR>") -- , { silent = true })
-- nvim-dap-python keymaps
vim.keymap.set('n', '<leader>dn', ":lua require('dap-python').test_method()<CR>") -- , { silent = true })
vim.keymap.set('n', '<leader>df', ":lua require('dap-python').test_class()<CR>") -- , { silent = true })
vim.keymap.set('v', '<leader>ds', [[<ESC>:lua require('dap-python').debug_selection()<CR>]]) -- , { silent = true })

-- NVIM-DAP-UI
-- require('dapui').setup()
require("dapui").setup({
  icons = { expanded = "", collapsed = "", current_frame = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "console",
        "repl",
      },
      size = 0.25, -- 25% of total lines
      -- position = "bottom",
      position = "right",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "",
      terminate = "",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})
vim.keymap.set('n', '<leader>du', require('dapui').toggle)
vim.keymap.set('n', '<leader>de', require('dapui').eval)
vim.keymap.set('v', '<leader>de', require('dapui').eval)

-- TABNINE
-- require('tabnine').setup({
--   disable_auto_comment=true,
--   accept_keymap="<Tab>",
--   dismiss_keymap = "<C-]>",
--   debounce_ms = 800,
--   suggestion_color = {gui = "#808080", cterm = 244},
--   execlude_filetypes = {"TelescopePrompt"}
-- })
--
-- local tabnine = require('cmp_tabnine.config')
--
-- tabnine:setup({
-- 	max_lines = 1000,
-- 	max_num_results = 20,
-- 	sort = true,
-- 	run_on_every_keystroke = true,
-- 	snippet_placeholder = '..',
-- 	ignored_file_types = {
-- 		-- default is not to ignore
-- 		-- uncomment to ignore in lua:
-- 		-- lua = true
-- 	},
-- 	show_prediction_strength = false
-- })

-- FTERM
vim.keymap.set('n', '<A-\\>', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<A-\\>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')

-- VIMTEX

-- This is necessary for VimTeX to load properly.
vim.cmd('filetype plugin indent on')

-- This enables Vim's and neovim's syntax-related features. 
vim.cmd('syntax enable')

-- Or with a generic interface.
vim.g.vimtex_view_general_viewer = 'okular'
vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'

-- COPY TO SYSTEM CLIPBOARD
-- vim.keymap.set('v', '<leader>y', function()
--     vim.cmd('w !wl-copy')
--     vim.api.nvim_input('<CR>')
-- end, {silent = true})

-- JUPYTER CELL EXECUTION
-- Select a jupyter cell marked with the "# %%" format
local select_jupyter_cell = function()
  local current_line = vim.fn.getline('.')
  -- if on marker select up to next marker
  if current_line:match('^# %%') then
    vim.cmd('normal! V')
    vim.cmd('/# %%\\|\\%$')
  -- if not on marker go to marker above and select
  else
    vim.cmd('?# %%')
    vim.cmd('normal! V')
    vim.cmd('/# %%\\|\\%$')
  end
  -- don't select the bottom marker
  if vim.fn.getline('.') == '# %%' then
    vim.cmd('normal! k')
  end
  -- turn off search highlighting
  vim.cmd('nohlsearch')
end
-- map function to 'vcc'
vim.keymap.set('n', 'vcc', select_jupyter_cell, { silent = true })

-- Map '<leader>cc' to run the select_jupyter_cell function and then trigger vim-slime
vim.keymap.set('n', '<leader>cc', function()
  select_jupyter_cell()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c><C-c>', true, false, true), 'm', true)
end, { silent = true })

-- Function to move to the next cell, select it, and run it
vim.keymap.set('n', '<leader>cx', function()
  -- Move to the next cell
  vim.cmd('/# %%\\|\\%$')
  -- Select and run the next cell
  select_jupyter_cell()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-c><C-c>', true, false, true), 'm', true)
end, { silent = true })
