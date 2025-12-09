return {
  "jay-babu/mason-nvim-dap.nvim",
  event = "VeryLazy",
  dependencies = { "mfussenegger/nvim-dap" },

  opts = {
    ensure_installed = { "js-debug-adapter" },

    handlers = {
      function(config) require("mason-nvim-dap").default_setup(config) end,
    },
  },

  config = function()
    local dap = require "dap"

    -- 1) Define the pwa-node adapter
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = 9222,
      executable = {
        command = "js-debug-adapter",
        args = { "9222" },
      },
    }

    -- 2) Shared configuration for TS + JS
    local shared = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug File",
        program = "${file}",
        cwd = "${workspaceFolder}",
        runtimeExecutable = "node",
        runtimeArgs = { "-r", "ts-node/register" },
        sourceMaps = true,
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
        skipFiles = { "<node_internals>/**" },
      },
    }

    local function pick_url(callback)
      vim.ui.input(
        { prompt = "URL to debug (default: http://localhost:9000): " },
        function(input) callback(input ~= "" and input or "http://localhost:9000") end
      )
    end

    dap.configurations.javascriptreact = {
      {
        name = "Debug Vite React App",
        type = "pwa-chrome",
        request = "launch",
        url = function()
          return coroutine.create(function(coro)
            pick_url(function(result) coroutine.resume(coro, result) end)
          end)
        end,
        webRoot = "${workspaceFolder}",
        runtimeArgs = {
          "--remote-debugging-port=9222",
        },
        sourceMaps = true,
        trace = true,
      },
      {
        name = "Attach to Chrome (Vite)",
        type = "pwa-chrome",
        request = "attach",
        program = "${file}",
        cwd = "${workspaceFolder}",
        port = 9222,
        webRoot = "${workspaceFolder}",
        url = function()
          return coroutine.create(function(coro)
            pick_url(function(result) coroutine.resume(coro, result) end)
          end)
        end,
      },
    }

    dap.configurations.typescriptreact = dap.configurations.javascriptreact

    -- 3) Attach the configuration to filetypes
    dap.configurations.javascript = shared
    dap.configurations.typescript = shared
  end,
}

--
-- {
--   "compilerOptions": {
--     "rootDir": "./ts",
--     "module": "nodenext",
--     "outDir": "./dist",
--     "target": "esnext",
--     "types": [],
--     "sourceMap": true,
--     "declaration": true,
--     "declarationMap": true,
--     "inlineSources": true,
--     "noUncheckedIndexedAccess": true,
--     "exactOptionalPropertyTypes": true,
--     "strict": true,
--     "jsx": "react-jsx",
--     "verbatimModuleSyntax": true,
--     "isolatedModules": true,
--     "noUncheckedSideEffectImports": true,
--     "moduleDetection": "force",
--     "skipLibCheck": true,
--   },
--   "include": ["ts/**/*.ts", "ts/**/*.tsx"],
-- }
