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
