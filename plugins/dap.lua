return {
  "mfussenegger/nvim-dap",
  dependencies = {
    { "mxsdev/nvim-dap-vscode-js", opts = { debugger_cmd = { "js-debug-adapter" }, adapters = { "pwa-node" } } },
    { "theHamsta/nvim-dap-virtual-text", config = true },
  },
  config = function()
    local dap = require "dap"
    -- local NODE_DIR = require("mason-registry").get_package("node-debug2-adapter"):get_install_path()
    -- .. "/out/src/nodeDebug.js"

    local attach_node = {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = function() return require("dap.utils").pick_process() end,
      cwd = "${workspaceFolder}",
      port = "${port}",
    }

    dap.configurations.javascript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
      attach_node,
    }
    dap.configurations.typescript = {
      {
        type = "pwa-node",
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
    dap.configurations.go = {
      {
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
    }

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug",
        request = "launch",
        mode = "debug",
        program = "main.go",
        args = {
          "start",
        },
      },
      {
        type = "delve",
        name = "Debug (delve)",
        request = "launch",
        program = "main.go",
        args = {
          "start",
          -- "--env",
          -- ".env",
        },
      },
      {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
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
}
