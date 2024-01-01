local attach_node = {
  type = "pwa-node",
  request = "attach",
  name = "Attach",
  processId = function() return require("dap.utils").pick_process() end,
  cwd = "${workspaceFolder}",
}

return {
  javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    attach_node,
  },
  -- typescript = {
  --   {
  --     type = "pwa-node",
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
  -- },
  typescript = {
    {
      type = "node",
      request = "launch",
      name = "Debug Nest Framework",
      args = {
        "${workspaceFolder}/src/main.ts",
      },
      runtimeArgs = {
        "--nolazy",
        "-r",
        "ts-node/register",
        "-r",
        "tsconfig-paths/register",
      },
      sourceMaps = true,
      envFile = "${workspaceFolder}/.env.dev",
      cwd = "${workspaceRoot}",
      console = "integratedTerminal",
      outFiles = {
        "${workspaceFolder}/**/*.js",
        "!**/node_modules/**",
      },
    },
    attach_node,
  },
  go = {
    {
      type = "go",
      name = "Debug.start",
      request = "launch",
      program = "main.go",
      args = {
        "start",
      },
      dlvToolPath = vim.fn.exepath "dlv", -- Adjust to where delve is installed
    },
    -- {
    --   type = "go",
    --   name = "Attach",
    --   mode = "local",
    --   request = "attach",
    --   processId = require("dap.utils").pick_process,
    -- },
  },
  python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      pythonPath = function() return "/usr/bin/python" end,
    },
  },
}
