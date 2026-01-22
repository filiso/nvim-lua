-- dap.lua
--
-- Custom Debug Adapter Protocol (DAP) configuration for Python debugging
-- Focuses on Python with per-project debugpy installation

return {
  -- Main DAP plugin
  'mfussenegger/nvim-dap',
  dependencies = {
    -- UI for the debugger
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Python adapter
    'mfussenegger/nvim-dap-python',

    -- Mason integration for DAP (optional but useful)
    'jay-babu/mason-nvim-dap.nvim',
  },

  -- Keybindings for debugging
  keys = {
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end,
      desc = 'Debug: Set Conditional Breakpoint',
    },
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle UI',
    },
    {
      '<F8>',
      function()
        require('dap').terminate()
      end,
      desc = 'Debug: Terminate',
    },
  },

  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Setup DAP UI
    dapui.setup({
      -- Icons that work in most terminals
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    })

    -- Setup Python debugging
    -- Uses 'python' command which automatically respects active virtualenv/conda env
    require('dap-python').setup('python')

    -- Automatically open/close DAP UI when debugging starts/stops
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
