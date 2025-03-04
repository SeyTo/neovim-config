---@type LazySpec
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", config = true },
      { "mxsdev/nvim-dap-vscode-js", opts = { debugger_cmd = { "js-debug-adapter" }, adapters = { "pwa-node" } } },
      { "leoluz/nvim-dap-go" },
    },
    config = function()
      local dap = require "dap"
      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/alacritty",
        args = { "-e" },
      }

      local attach_node = {
        type = "node",
        request = "attach",
        name = "Attach",
        processId = function() return require("dap.utils").pick_process() end,
        cwd = "${workspaceFolder}",
        port = "${port}",
      }

      dap.configurations.javascript = {
        {
          type = "node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        attach_node,
      }
      dap.configurations.typescript = {
        {
          type = "node",
          port = "${port}",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "ts-node",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          resolveSourceMapLocations = {
            "${workspaceFolder}/dist/**/*.js",
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        },
        attach_node,
      }

      -- go
      require("dap-go").setup()
      dap.configurations.go = {
        {
          name = "Debug (dlv)",
          request = "launch",
          options = {
            initialize_timeout_sec = 20,
          },
          type = "server",
          port = "${port}",
          executable = {
            command = "dlv",
            args = { "dap", "-l", "127.0.0.1:${port}" },
          },
        },
        {
          name = "Attach",
          type = "go",
          request = "attach",
          mode = "remote",
          processId = require("dap.utils").pick_process,
          port = 40000,
        },
        {
          name = "Debug",
          type = "go",
          request = "launch",
          mode = "debug",
          program = "main.go",
          args = {
            "start",
            -- "--env",
            -- ".env",
          },
        },
        {
          name = "Debug test", -- configuration for debugging test files
          type = "delve",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        -- works with go.mod packages and sub packages
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "python" },
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
        end,
      },
    },
  },
}
-- "mfussenegger/nvim-dap",
-- dependencies = {
--   { "theHamsta/nvim-dap-virtual-text", config = true },
--   { "mxsdev/nvim-dap-vscode-js", opts = { debugger_cmd = { "js-debug-adapter" }, adapters = { "pwa-node" } } },
--   -- { "theHamsta/nvim-dap-virtual-text", config = true },
-- },
--   config = function()
--     local dap = require "dap"
--     -- local NODE_DIR = require("mason-registry").get_package("node-debug2-adapter"):get_install_path()
--     -- .. "/out/src/nodeDebug.js"
--
--     local attach_node = {
--       type = "node",
--       request = "attach",
--       name = "Attach",
--       processId = function() return require("dap.utils").pick_process() end,
--       cwd = "${workspaceFolder}",
--       port = "${port}",
--     }
--
--     dap.configurations.javascript = {
--       {
--         type = "node",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--       },
--       attach_node,
--     }
--     dap.configurations.typescript = {
--       {
--         type = "node",
--         port = "${port}",
--         request = "launch",
--         name = "Launch file",
--         program = "${file}",
--         cwd = "${workspaceFolder}",
--         runtimeExecutable = "ts-node",
--         sourceMaps = true,
--         protocol = "inspector",
--         console = "integratedTerminal",
--         resolveSourceMapLocations = {
--           "${workspaceFolder}/dist/**/*.js",
--           "${workspaceFolder}/**",
--           "!**/node_modules/**",
--         },
--       },
--       attach_node,
--     }
--   end,
--
--   COnfig 4:

--   config = function()
--     local dap = require "dap"
--
--     local debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"
--
--     require("dap-vscode-js").setup {
--       node_path = "node",
--       debugger_path = debugger_path,
--       -- debugger_cmd = { "js-debug-adapter" },
--       adapters = {
--         "pwa-node",
--         "pwa-chrome",
--         "pwa-msedge",
--         "node-terminal",
--         "pwa-extensionHost",
--       }, -- which adapters to register in nvim-dap
--     }
--
--     -- You need to install ts-node globally.
--     -- In your terminal, run `npm install -g ts-node` (You could use another package manager)
--     for _, language in ipairs { "typescript" } do
--       require("dap").configurations[language] = {
--         -- inspiration from
--         -- https://github.com/anasrar/.dotfiles/blob/48ba127aee8d5791de091a7e1757d681ca748b07/neovim/.config/nvim/lua/rin/DAP/languages/typescript.lua#L127-L137
--         {
--           type = "pwa-node",
--           request = "launch",
--           name = "Launch Program (pwa-node with ts-node)",
--           cwd = vim.fn.getcwd(),
--           -- runtimeArgs = { "--loader", "ts-node/esm" },
--           -- runtimeExecutable = "node",
--           runtimeArgs = { "--esm" },
--           runtimeExecutable = "ts-node", -- This is why you need ts-node installed.
--           args = { "${file}" },
--           sourceMaps = true,
--           protocol = "inspector",
--           skipFiles = { "<node_internals>/**", "node_modules/**" },
--           resolveSourceMapLocations = {
--             "${workspaceFolder}/**",
--             "!**/node_modules/**",
--           },
--         },
--         {
--           type = "pwa-node",
--           request = "attach",
--           name = "Attach",
--           processId = require("dap.utils").pick_process,
--           cwd = "${workspaceFolder}",
--         },
--       }
--     end
--
--     for _, language in ipairs { "javascript" } do
--       require("dap").configurations[language] = {
--         {
--           type = "pwa-node",
--           request = "launch",
--           name = "Launch file",
--           program = "${file}",
--           cwd = "${workspaceFolder}",
--         },
--         {
--           type = "pwa-node",
--           request = "attach",
--           name = "Attach",
--           processId = require("dap.utils").pick_process,
--           cwd = "${workspaceFolder}",
--         },
--         {
--           type = "pwa-node",
--           request = "launch",
--           name = "Debug Jest Tests",
--           -- trace = true, -- include debugger info
--           runtimeExecutable = "node",
--           runtimeArgs = {
--             "./node_modules/jest/bin/jest.js",
--             "--runInBand",
--           },
--           rootPath = "${workspaceFolder}",
--           cwd = "${workspaceFolder}",
--           console = "integratedTerminal",
--           internalConsoleOptions = "neverOpen",
--         },
--       }
--     end
--
--     for _, language in ipairs { "typescriptreact", "javascriptreact" } do
--       require("dap").configurations[language] = {
--         {
--           type = "pwa-chrome",
--           name = "Attach - Remote Debugging",
--           request = "attach",
--           program = "${file}",
--           cwd = vim.fn.getcwd(),
--           sourceMaps = true,
--           protocol = "inspector",
--           port = 9222,
--           webRoot = "${workspaceFolder}",
--         },
--         {
--           type = "pwa-chrome",
--           name = "Launch Chrome",
--           request = "launch",
--           url = "http://localhost:3000",
--         },
--       }
--     end
--   end,
-- }

-- Config 2:
-- local js_based_languages = {
--   "typescript",
--   "javascript",
--   "typescriptreact",
--   "javascriptreact",
--   "vue",
-- }
--
-- return {
--   {
--     "mfussenegger/nvim-dap",
--     config = function()
--       local dap = require "dap"
--
--       local Config = require "lazyvim.config"
--       vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
--
--       for name, sign in pairs(Config.icons.dap) do
--         sign = type(sign) == "table" and sign or { sign }
--         vim.fn.sign_define(
--           "Dap" .. name,
--           { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
--         )
--       end
--
--       for _, language in ipairs(js_based_languages) do
--         dap.configurations[language] = {
--           -- Debug single nodejs files
--           {
--             type = "pwa-node",
--             request = "launch",
--             name = "Launch file",
--             program = "${file}",
--             cwd = vim.fn.getcwd(),
--             sourceMaps = true,
--           },
--           -- Debug nodejs processes (make sure to add --inspect when you run the process)
--           {
--             type = "pwa-node",
--             request = "attach",
--             name = "Attach",
--             processId = require("dap.utils").pick_process,
--             cwd = vim.fn.getcwd(),
--             sourceMaps = true,
--           },
--           -- Debug web applications (client side)
--           {
--             type = "pwa-chrome",
--             request = "launch",
--             name = "Launch & Debug Chrome",
--             url = function()
--               local co = coroutine.running()
--               return coroutine.create(function()
--                 vim.ui.input({
--                   prompt = "Enter URL: ",
--                   default = "http://localhost:3000",
--                 }, function(url)
--                   if url == nil or url == "" then
--                     return
--                   else
--                     coroutine.resume(co, url)
--                   end
--                 end)
--               end)
--             end,
--             webRoot = vim.fn.getcwd(),
--             protocol = "inspector",
--             sourceMaps = true,
--             userDataDir = false,
--           },
--           -- Divider for the launch.json derived configs
--           {
--             name = "----- ↓ launch.json configs ↓ -----",
--             type = "",
--             request = "launch",
--           },
--         }
--       end
--     end,
--     keys = {
--       {
--         "<leader>dO",
--         function() require("dap").step_out() end,
--         desc = "Step Out",
--       },
--       {
--         "<leader>do",
--         function() require("dap").step_over() end,
--         desc = "Step Over",
--       },
--       {
--         "<leader>da",
--         function()
--           if vim.fn.filereadable ".vscode/launch.json" then
--             local dap_vscode = require "dap.ext.vscode"
--             dap_vscode.load_launchjs(nil, {
--               ["pwa-node"] = js_based_languages,
--               ["node"] = js_based_languages,
--               ["chrome"] = js_based_languages,
--               ["pwa-chrome"] = js_based_languages,
--             })
--           end
--           require("dap").continue()
--         end,
--         desc = "Run with Args",
--       },
--     },
--     dependencies = {
--       -- Install the vscode-js-debug adapter
--       {
--         "microsoft/vscode-js-debug",
--         -- After install, build it and rename the dist directory to out
--         build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
--         version = "1.*",
--       },
--       {
--         "mxsdev/nvim-dap-vscode-js",
--         config = function()
--           ---@diagnostic disable-next-line: missing-fields
--           require("dap-vscode-js").setup {
--             -- Path of node executable. Defaults to $NODE_PATH, and then "node"
--             -- node_path = "node",
--
--             -- Path to vscode-js-debug installation.
--             debugger_path = vim.fn.resolve(vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"),
--
--             -- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
--             -- debugger_cmd = { "js-debug-adapter" },
--
--             -- which adapters to register in nvim-dap
--             adapters = {
--               "chrome",
--               "pwa-node",
--               "pwa-chrome",
--               "pwa-msedge",
--               "pwa-extensionHost",
--               "node-terminal",
--               "node",
--             },
--
--             -- Path for file logging
--             -- log_file_path = "(stdpath cache)/dap_vscode_js.log",
--
--             -- Logging level for output to file. Set to false to disable logging.
--             -- log_file_level = false,
--
--             -- Logging level for output to console. Set to false to disable console output.
--             -- log_console_level = vim.log.levels.ERROR,
--           }
--         end,
--       },
--       -- {
--       --   "Joakker/lua-json5",
--       --   build = "./install.sh",
--       -- },
--     },
--   },
-- }
--
-- Config 3
-- local fn = require "user.util.fn"
-- local telescope = require "user.util.telescope"
--
-- return {
--   "mfussenegger/nvim-dap",
--   enabled = true,
--   dependencies = {
--     -- { "theHamsta/nvim-dap-virtual-text", config = true },
--   },
--   config = function()
--     local dap = require "dap"
--     local CODELLDB_DIR = require("mason-registry").get_package("codelldb"):get_install_path()
--       .. "/extension/adapter/codelldb"
--     local PYTHON_DIR = require("mason-registry").get_package("debugpy"):get_install_path() .. "/venv/Scripts/python"
--     local NODE_DIR = require("mason-registry").get_package("node-debug2-adapter"):get_install_path()
--       .. "/out/src/nodeDebug.js"
--
--     dap.adapters.py = {
--       -- name = 'py',
--       type = "executable",
--       command = PYTHON_DIR,
--       args = { "-m", "debugpy.adapter" },
--       detatched = false,
--     }
--     dap.adapters.node = {
--       type = "executable",
--       command = "node",
--       args = { NODE_DIR },
--     }
--
--     -- configurations --
--
--     dap.configurations.python = {
--       {
--         name = "Launch file",
--         type = "py", -- the type here established the link to the adapter definition: `dap.adapters.python`
--         request = "launch",
--         program = "${file}", -- This configuration will launch the current file if used.
--       },
--     }
--
--     local function set_program()
--       local function set_path(prompt_bufnr, map)
--         telescope.actions.select_default:replace(function()
--           telescope.actions.close(prompt_bufnr)
--           local selected = telescope.actions_state.get_selected_entry()
--           vim.g.dap_program = selected.path
--         end)
--         return true
--       end
--       telescope.run_func_on_file {
--         name = "Executable",
--         attach_mappings = set_path,
--         results = fn.get_files_by_end,
--         results_args = fn.is_win() and "exe" or "",
--       }
--       return true
--     end
--
--     require("astronvim.utils").set_mappings {
--       n = {
--         ["<leader>de"] = { set_program, desc = "Set program path" },
--       },
--     }
--
--     dap.configurations.typescript = {
--       {
--         name = "Launch",
--         type = "node",
--         request = "launch",
--         program = "${file}",
--         cwd = vim.fn.getcwd(),
--         sourceMaps = true,
--         protocol = "inspector",
--         console = "integratedTerminal",
--       },
--       {
--         -- For this to work you need to make sure the node process is started with the `--inspect` flag.
--         name = "Attach to process - test",
--         type = "node",
--         request = "attach",
--         processId = require("dap.utils").pick_process,
--       },
--     }
--   end,
-- }
