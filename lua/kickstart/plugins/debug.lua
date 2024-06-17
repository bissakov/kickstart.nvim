return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      {
        '<leader>b',
        dap.toggle_breakpoint,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      {
        '<leader>e',
        function()
          dapui.eval(vim.fn.input '[Expression] > ')
        end,
        desc = 'Debug: Evaluate expression',
      },

      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'delve',
        'python',
        'codelldb',
      },
    }

    --- @diagnostic disable-next-line: missing-fields
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      --- @diagnostic disable-next-line: missing-fields
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
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }

    vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
    vim.fn.sign_define('DapBreakpoint', {
      text = '',
      texthl = 'DapBreakpoint',
      linehl = 'DapBreakpoint',
      numhl = 'DapBreakpoint',
    })

    require('dap-go').setup()
    require('dap-python').setup(
      require('mason-registry').get_package('debugpy'):get_install_path()
        .. '\\venv\\Scripts\\pythonw.exe'
    )

    dap.configurations.python = {
      {
        justMyCode = false,
        type = 'python',
        request = 'launch',
        name = 'Module',
        console = 'internalConsole',
        module = function()
          return vim.fn.input 'Module: '
        end,
        cwd = '${workspaceFolder}',
        pythonPath = function()
          local virtual_env = os.getenv 'VIRTUAL_ENV'
          if virtual_env ~= nil then
            return virtual_env .. '/Scripts/pythonw.exe'
          else
            return 'pythonw'
          end
        end,
      },
    }
  end,
}
