---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", config = true },
      -- {
      --   "mxsdev/nvim-dap-vscode-js",
      --   opts = { debugger_cmd = { "js-debug-adapter" }, adapters = { "pwa-node", "node" } },
      -- },
      { "leoluz/nvim-dap-go" },
    },
    config = function()
      local dap = require "dap"
      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/alacritty",
        args = { "-e" },
      }
      if not dap.adapters["pwa-node"] then
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = vim.fn.exepath "js-debug-adapter", args = { "${port}" } },
        }
      end
      if not dap.adapters.node then
        dap.adapters.node = function(cb, config)
          if config.type == "node" then config.type = "pwa-node" end
          local pwa_adapter = dap.adapters["pwa-node"]
          if type(pwa_adapter) == "function" then
            pwa_adapter(cb, config)
          else
            cb(pwa_adapter)
          end
        end
      end

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      local js_config = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then dap.configurations[language] = js_config end
      end

      local vscode_filetypes = require("dap.ext.vscode").type_to_filetypes
      vscode_filetypes["node"] = js_filetypes
      vscode_filetypes["pwa-node"] = js_filetypes

      -- local attach_node = {
      --   type = "node",
      --   request = "attach",
      --   name = "Attach",
      --   processId = function() return require("dap.utils").pick_process() end,
      --   cwd = "${workspaceFolder}",
      --   port = "${port}",
      -- }

      -- dap.configurations.javascript = {
      --   {
      --     type = "node",
      --     request = "launch",
      --     name = "Launch file",
      --     program = "${file}",
      --     cwd = "${workspaceFolder}",
      --   },
      --   attach_node,
      -- }
      -- dap.configurations.typescript = {
      --   {
      --     type = "node",
      --     port = "${port}",
      --     request = "launch",
      --     name = "Launch file",
      --     program = "${file}",
      --     cwd = "${workspaceFolder}",
      --     runtimeExecutable = "ts-node",
      --     sourceMaps = true,
      --     protocol = "inspector",
      --     console = "integratedTerminal",
      --     resolveSourceMapLocations = {
      --       "${workspaceFolder}/dist/**/*.js",
      --       "${workspaceFolder}/**",
      --       "!**/node_modules/**",
      --     },
      --   },
      --   {
      --     type = "pwa-node",
      --     request = "launch",
      --     name = "Debug NestJS",
      --     runtimeExecutable = "node",
      --     runtimeArgs = { "--loader", "ts-node/esm" },
      --     program = "${workspaceFolder}/src/main.ts", -- adjust if entrypoint is different
      --     cwd = "${workspaceFolder}",
      --     protocol = "inspector",
      --     console = "integratedTerminal",
      --     internalConsoleOptions = "neverOpen",
      --     sourceMaps = true,
      --     resolveSourceMapLocations = {
      --       "${workspaceFolder}/**",
      --       "!**/node_modules/**",
      --     },
      --     outFiles = {
      --       "${workspaceFolder}/dist/**/*.js",
      --     },
      --     skipFiles = { "<node_internals>/**", "node_modules/**" },
      --   },
      --   {
      --     type = "pwa-node",
      --     request = "attach",
      --     name = "Attach to NestJS",
      --     processId = require("dap.utils").pick_process,
      --     port = 9229,
      --     host = "127.0.0.1",
      --     cwd = "${workspaceFolder}",
      --     protocol = "inspector",
      --     skipFiles = { "<node_internals>/**", "node_modules/**" },
      --   },
      --   attach_node,
      -- }

      -- go
      -- require("dap-go").setup()
      -- dap.configurations.go = {
      --   {
      --     name = "Debug (dlv)",
      --     request = "launch",
      --     options = {
      --       initialize_timeout_sec = 20,
      --     },
      --     type = "server",
      --     port = "${port}",
      --     executable = {
      --       command = "dlv",
      --       args = { "dap", "-l", "127.0.0.1:${port}" },
      --     },
      --   },
      --   {
      --     name = "Attach",
      --     type = "go",
      --     request = "attach",
      --     mode = "remote",
      --     processId = require("dap.utils").pick_process,
      --     port = 40000,
      --   },
      --   {
      --     name = "Debug",
      --     type = "go",
      --     request = "launch",
      --     mode = "debug",
      --     program = "main.go",
      --     args = {
      --       "start",
      --       -- "--env",
      --       -- ".env",
      --     },
      --   },
      --   {
      --     name = "Debug test", -- configuration for debugging test files
      --     type = "delve",
      --     request = "launch",
      --     mode = "test",
      --     program = "${file}",
      --   },
      --   -- works with go.mod packages and sub packages
      --   {
      --     type = "delve",
      --     name = "Debug test (go.mod)",
      --     request = "launch",
      --     mode = "test",
      --     program = "./${relativeFileDirname}",
      --   },
      -- }
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "python", "typescript" },
      handlers = {
        python = function()
          local dap = require "dap"
          -- local cwd = vim.fn.getcwd()
          dap.adapters.python = {
            type = "executable",
            cwd = "${workspaceFolder}",
            port = "${port}",
            command = "./.venv/bin/python",
            -- command = cwd .. "/.venv/bin/python",
            args = {
              "-m",
              "debugpy.adapter",
            },
            -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
          }

          dap.configurations.python = {
            {
              type = "python",
              request = "launch",
              name = "Launch file",
              program = "${file}", -- This configuration will launch the current file if used.
              pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                local cwd = vim.fn.getcwd()
                if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                  return cwd .. "/venv/bin/python"
                elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                  return cwd .. "/.venv/bin/python"
                else
                  return "/usr/bin/python"
                end
              end,
            },
            {
              type = "python",
              request = "attach",
              name = "Attach to Debugpy",
              connect = {
                host = "127.0.0.1", -- Adjust if needed
                port = 5678, -- Default debugpy port
              },
              mode = "client",
            },
          }

          -- local attach_node = {
          --   type = "node",
          --   request = "attach",
          --   name = "Attach",
          --   processId = function() return require("dap.utils").pick_process() end,
          --   cwd = "${workspaceFolder}",
          --   port = "${port}",
          -- }
          -- dap.configurations.typescript = {
          --   {
          --     type = "node",
          --     port = "${port}",
          --     request = "launch",
          --     name = "Launch file",
          --     program = "${file}",
          --     cwd = "${workspaceFolder}",
          --     runtimeExecutable = "ts-node",
          --     sourceMaps = true,
          --     protocol = "inspector",
          --     console = "integratedTerminal",
          --     resolveSourceMapLocations = {
          --       "${workspaceFolder}/dist/**/*.js",
          --       "${workspaceFolder}/**",
          --       "!**/node_modules/**",
          --     },
          --   },
          --   attach_node,
          -- }
        end,
      },
    },
  },
}
