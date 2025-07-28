-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- disable netrw file explorer (advised by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazy").setup({
  -- Mason package manager
  {
    'williamboman/mason.nvim',
    build = ":MasonUpdate",
    config = function()
      require('mason').setup()
    end,
  },

  -- Mason LSP config
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup {
        ensure_installed = { 'pylsp', 'lua_ls' },
      }
    end,
  },

  -- Useful status updates for LSP
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require("fidget").setup {}
    end,
  },

  -- Additional lua configuration, makes nvim stuff amazing
  'folke/neodev.nvim',

  -- LSP Configuration & Plugins
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim',
      'folke/neodev.nvim',
    },
    config = function()
      -- Setup neovim lua configuration
      require('neodev').setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- LSP settings.
      -- This function gets run when an LSP connects to a particular buffer.
      local on_attach = function(_, bufnr)
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
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('KK', vim.lsp.buf.signature_help, 'Signature Documentation')
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

      -- Manual server setup since mason-lspconfig may not be ready for setup_handlers
      local lspconfig = require('lspconfig')
      
      -- Python LSP
      lspconfig.pylsp.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = {
                ignore = {'E501'},
                maxLineLength = 100
              },
            },
          },
        },
      }

      -- Lua LSP
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      }
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
  },

  -- -- Tabnine AI autocompletion
  -- { 'codota/tabnine-nvim', build = "./dl_binaries.sh" },
  -- {
  --   'tzachar/cmp-tabnine',
  --   build = './install.sh',
  --   dependencies = { 'hrsh7th/nvim-cmp' }
  -- },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = { 'c', 'cpp', 'lua', 'python', 'vim' },
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        
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
    end,
  },

  -- Additional text objects via treesitter
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- Highlight TODO, FIX, HACK, etc.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  },

  -- Github Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false,
          keymap = {
            accept = "<M-p>",
            accept_word = false,
            accept_line = false,
            next = "<M-[>",
            prev = "<M-]>",
            dismiss = false,
          },

        },
        panel = { enabled = false },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end
  },

  -- Github Copilot integration
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },

  -- -- Codeium (unofficial with nvim-cmp support)
  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --       "nvim-lua/plenary.nvim",
  --       "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --       require("codeium").setup({
  --       })
  --   end
  -- },

  -- -- Codeium (official with virtual text)
  -- -- 'Exafunction/codeium.vim',
  -- {
  --   'Exafunction/codeium.vim',
  --   config = function ()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set('i', '<leader><Tab>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
  --   end
  -- },

  -- LLM chat suppport in a Neovim-native style
  {
    "robitx/gp.nvim",
    config = function()
    end,
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      }
    end,
  },

  -- VimTex
  'lervag/vimtex',

  -- colorschemes
  'navarasu/onedark.nvim', -- Theme inspired by Atom
  'marko-cerovac/material.nvim',
  'EdenEast/nightfox.nvim',
  'tiagovla/tokyodark.nvim',

  'nvim-lualine/lualine.nvim', -- Fancier statusline
  'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'undg/telescope-gp-agent-picker.nvim',
    }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = function() return vim.fn.executable 'make' == 1 end },

  -- Move seamlessly between vin and tmux panes using C+[hjkl] 
  'christoomey/vim-tmux-navigator',

  -- Run selected code in neighboring tmux pane e.g. ipython
  { 'jpalardy/vim-slime', ft = 'python' },

  -- Faster motions
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },

  -- Floating terminal
  "numToStr/FTerm.nvim",

  -- File explorer
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    version = "*" -- Use for stability; updated every week. (see issue #1193)
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  -- Debugging
  'mfussenegger/nvim-dap',
  'mfussenegger/nvim-dap-python',
  { "rcarriga/nvim-dap-ui", dependencies = {"nvim-neotest/nvim-nio"} },
  'rcarriga/cmp-dap',
  -- 'jayp0521/mason-nvim-dap.nvim',

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

-- Additional features/extensions to load post-setup
require('telescope').load_extension('gp_picker') -- Only include this if gp_picker defined as an available extension

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


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

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

-- Set up autocommand to set slime_python_ipython for Markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.b.slime_python_ipython = 1

    -- Define an escape function for Markdown that calls the Python escape function
    vim.cmd([[
      function! _EscapeText_markdown(text)
        return call('_EscapeText_python', [a:text])
      endfunction
    ]])
  end
})

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
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    -- Use default mappings
    api.config.mappings.default_on_attach(bufnr)
    -- Add custom mapping
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
  end,
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


-- GP.NVIM

local gp_conf = {
  -- For customization, refer to Install > Configuration in the Documentation/Readme
  providers = {
    openai = {
      endpoint = "https://api.openai.com/v1/chat/completions",
      secret = os.getenv("OPENAI_API_KEY"),
    },
    copilot = {
      endpoint = "https://api.githubcopilot.com/chat/completions",
      secret = {
        "bash",
        "-c",
        "cat ~/.config/github-copilot/hosts.json | sed -e 's/.*oauth_token...//;s/\".*//'",
      },
    },
    anthropic = {
      endpoint = "https://api.anthropic.com/v1/messages",
      secret = os.getenv("ANTHROPIC_API_KEY"),
    },
  },

  agents = {
    {
      name = "ExampleDisabledAgent",
      disable = true,
    },
    {
      name = "ChatGPT4o",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "openai",
      name = "ChatGPT4o-mini",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "openai",
      name = "ChatChatGPT4o",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "chatgpt-4o-latest", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "copilot",
      name = "ChatCopilot",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "ChatClaude-3-7-Sonnet",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-7-sonnet-latest", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "ChatClaude-Sonnet-4",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "claude-sonnet-4-20250514", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "anthropic",
      name = "ChatClaude-3-Haiku",
      chat = true,
      command = false,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-haiku-20240307", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").chat_system_prompt,
    },
    {
      provider = "openai",
      name = "CodeGPT4o",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "openai",
      name = "CodeGPT4o-mini",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o-mini", temperature = 0.7, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
    },
    {
      provider = "openai",
      name = "CodeChatGPT4o",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "chatgpt-4o-latest", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "copilot",
      name = "CodeCopilot",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4o", temperature = 0.8, top_p = 1, n = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = require("gp.defaults").code_system_prompt,
    },
    {
      provider = "anthropic",
      name = "CodeClaude-3-7-Sonnet",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "claude-3-7-sonnet-latest", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
    },
    {
      provider = "anthropic",
      name = "CodeClaude-Sonnet-4",
      chat = false,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "claude-sonnet-4-20250514", temperature = 0.8, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "Please return ONLY code snippets.\nSTART AND END YOUR ANSWER WITH:\n\n```",
    },
  },

  -- directory for storing chat files
  chat_dir = "/home/fs/data/opt_files/gp.nvim/chats",

  -- image generation settings
  image = {
    store_dir = "/home/fs/data/opt_files/gp.nvim/images",
  },

  -- (be careful to choose something which will work across specified modes)
  chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-q><C-q>" },
  chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-q>d" },
  chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-q>s" },
  chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<C-q>c" },

  whisper = {
    -- you can disable whisper completely by whisper = {disable = true}
    disable = false,

    -- OpenAI audio/transcriptions api endpoint to transcribe audio to text
    endpoint = "https://api.openai.com/v1/audio/transcriptions",
    -- directory for storing whisper files
    store_dir = (os.getenv("TMPDIR") or os.getenv("TEMP") or "/tmp") .. "/gp_whisper",
    -- multiplier of RMS level dB for threshold used by sox to detect silence vs speech
    -- decibels are negative, the recording is normalized to -3dB =>
    -- increase this number to pick up more (weaker) sounds as possible speech
    -- decrease this number to pick up only louder sounds as possible speech
    -- you can disable silence trimming by setting this a very high number (like 1000.0)
    silence = "1.75",
    -- whisper tempo (1.0 is normal speed)
    tempo = "1.75",
    -- The language of the input audio, in ISO-639-1 format.
    language = "en",
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
require("gp").setup(gp_conf)

-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
local function keymapOptionsGp(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
end
-- Chat commands
-- many commands have both a <C-q> and <leader>q binding on purpose (test)
-- GpChatNew
vim.keymap.set({"n", "i"}, "<C-q>n", "<cmd>GpChatNew<cr>", keymapOptionsGp("New Chat"))
vim.keymap.set({"n"}, "<leader>qn", "<cmd>GpChatNew<cr>", keymapOptionsGp("New Chat"))
vim.keymap.set("v", "<C-q>n", ":<C-u>'<,'>GpChatNew<cr>", keymapOptionsGp("Visual Chat New"))
vim.keymap.set("v", "<leader>qn", ":<C-u>'<,'>GpChatNew<cr>", keymapOptionsGp("Visual Chat New"))
-- GpChatToggle
vim.keymap.set({"n", "i"}, "<C-q>t", "<cmd>GpChatToggle<cr>", keymapOptionsGp("Toggle Chat"))
vim.keymap.set({"n"}, "<leader>qt", "<cmd>GpChatToggle<cr>", keymapOptionsGp("Toggle Chat"))
vim.keymap.set("v", "<C-q>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptionsGp("Visual Toggle Chat"))
vim.keymap.set("v", "<leader>qt", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptionsGp("Visual Toggle Chat"))
-- GpChatFinder
vim.keymap.set({"n", "i"}, "<C-q>f", "<cmd>GpChatFinder<cr>", keymapOptionsGp("Chat Finder"))
vim.keymap.set({"n"}, "<leader>qf", "<cmd>GpChatFinder<cr>", keymapOptionsGp("Chat Finder"))
-- GpChatPaste
vim.keymap.set("v", "<C-q>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptionsGp("Visual Chat Paste"))
vim.keymap.set("v", "<leader>qp", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptionsGp("Visual Chat Paste"))
-- GpChatNew split, vsplit, tabnew
vim.keymap.set({ "n", "i" }, "<C-q><C-x>", "<cmd>GpChatNew split<cr>", keymapOptionsGp("New Chat split"))
vim.keymap.set({ "n"}, "<leader>qx", "<cmd>GpChatNew split<cr>", keymapOptionsGp("New Chat split"))
vim.keymap.set({ "n", "i" }, "<C-q><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptionsGp("New Chat vsplit"))
vim.keymap.set({ "n"}, "<leader>qv", "<cmd>GpChatNew vsplit<cr>", keymapOptionsGp("New Chat vsplit"))
vim.keymap.set({ "n", "i" }, "<C-q><C-,>", "<cmd>GpChatNew tabnew<cr>", keymapOptionsGp("New Chat tabnew"))
vim.keymap.set({ "n"}, "<leager>q,", "<cmd>GpChatNew tabnew<cr>", keymapOptionsGp("New Chat tabnew"))
vim.keymap.set("v", "<C-q><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptionsGp("Visual Chat New split"))
vim.keymap.set("v", "<leader>qx", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptionsGp("Visual Chat New split"))
vim.keymap.set("v", "<C-q><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptionsGp("Visual Chat New vsplit"))
vim.keymap.set("v", "<leader>qv", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptionsGp("Visual Chat New vsplit"))
vim.keymap.set("v", "<C-q><C-,>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptionsGp("Visual Chat New tabnew"))
vim.keymap.set("v", "<leader>q,", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptionsGp("Visual Chat New tabnew"))

-- Prompt commands
-- GpRewrite, GpAppend, GpPrepend
vim.keymap.set({"n", "i"}, "<C-q>e", "<cmd>GpRewrite<cr>", keymapOptionsGp("Inline Rewrite"))
vim.keymap.set({"n"}, "<leader>qe", "<cmd>GpRewrite<cr>", keymapOptionsGp("Inline Rewrite"))
vim.keymap.set({"n", "i"}, "<C-q>a", "<cmd>GpAppend<cr>", keymapOptionsGp("Append (after)"))
vim.keymap.set({"n"}, "<leader>qa", "<cmd>GpAppend<cr>", keymapOptionsGp("Append (after)"))
vim.keymap.set({"n", "i"}, "<C-q>z", "<cmd>GpPrepend<cr>", keymapOptionsGp("Prepend (before)"))
vim.keymap.set({"n"}, "<leader>qz", "<cmd>GpPrepend<cr>", keymapOptionsGp("Prepend (before)"))
vim.keymap.set("v", "<C-q>e", ":<C-u>'<,'>GpRewrite<cr>", keymapOptionsGp("Visual Rewrite"))
vim.keymap.set("v", "<leader>qe", ":<C-u>'<,'>GpRewrite<cr>", keymapOptionsGp("Visual Rewrite"))
vim.keymap.set("v", "<C-q>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptionsGp("Visual Append (after)"))
vim.keymap.set("v", "<leader>qa", ":<C-u>'<,'>GpAppend<cr>", keymapOptionsGp("Visual Append (after)"))
vim.keymap.set("v", "<C-q>z", ":<C-u>'<,'>GpPrepend<cr>", keymapOptionsGp("Visual Prepend (before)"))
vim.keymap.set("v", "<leader>qz", ":<C-u>'<,'>GpPrepend<cr>", keymapOptionsGp("Visual Prepend (before)"))
-- vim.keymap.set("v", "<C-q>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptionsGp("Implement selection"))
-- GpPopup, GpEnew, GpNew, GpVnew
-- vim.keymap.set({"n", "i"}, "<C-q>gp", "<cmd>GpPopup<cr>", keymapOptionsGp("Popup"))
-- vim.keymap.set({"n", "i"}, "<C-q>ge", "<cmd>GpEnew<cr>", keymapOptionsGp("GpEnew"))
vim.keymap.set({"n", "i"}, "<C-q>wx", "<cmd>GpNew<cr>", keymapOptionsGp("GpNew"))
vim.keymap.set({"n", "i"}, "<leader>qwx", "<cmd>GpNew<cr>", keymapOptionsGp("GpNew"))
vim.keymap.set({"n", "i"}, "<C-q>wv", "<cmd>GpVnew<cr>", keymapOptionsGp("GpVnew"))
vim.keymap.set({"n", "i"}, "<leader>qwv", "<cmd>GpVnew<cr>", keymapOptionsGp("GpVnew"))
-- vim.keymap.set("v", "<C-q>gp", ":<C-u>'<,'>GpPopup<cr>", keymapOptionsGp("Visual Popup"))
-- vim.keymap.set("v", "<C-q>ge", ":<C-u>'<,'>GpEnew<cr>", keymapOptionsGp("Visual GpEnew"))
vim.keymap.set("v", "<C-q>wx", ":<C-u>'<,'>GpNew<cr>", keymapOptionsGp("Visual GpNew"))
vim.keymap.set("v", "<leader>qwx", ":<C-u>'<,'>GpNew<cr>", keymapOptionsGp("Visual GpNew"))
vim.keymap.set("v", "<C-q>wv", ":<C-u>'<,'>GpVnew<cr>", keymapOptionsGp("Visual GpVnew"))
vim.keymap.set("v", "<leader>qwv", ":<C-u>'<,'>GpVnew<cr>", keymapOptionsGp("Visual GpVnew"))

vim.keymap.set({"n", "i", "v", "x"}, "<C-q>s", "<cmd>GpStop<cr>", keymapOptionsGp("Stop"))
vim.keymap.set({"n", "v", "x"}, "<leader>qs", "<cmd>GpStop<cr>", keymapOptionsGp("Stop"))

-- GP.NVIM Whisper
vim.keymap.set({"n", "i"}, "<C-q>ww", "<cmd>GpWhisper<cr>", keymapOptionsGp("Whisper"))
vim.keymap.set({"n"}, "<leader>ww", "<cmd>GpWhisper<cr>", keymapOptionsGp("Whisper"))
vim.keymap.set("v", "<C-q>ww", ":<C-u>'<,'>GpWhisper<cr>", keymapOptionsGp("Visual Whisper"))
vim.keymap.set("v", "<leader>ww", ":<C-u>'<,'>GpWhisper<cr>", keymapOptionsGp("Visual Whisper"))

-- Setup GP.NVIM-related plugins
-- telescope-gp-agent-picker
vim.keymap.set('n', '<leader>fa', '<cmd>Telescope gp_picker agent<cr>', {desc = 'GP Agent Picker'})
