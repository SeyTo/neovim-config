local chromium = "/usr/bin/chromium"

return {
  "jay-babu/mason-nvim-dap.nvim",
  event = "VeryLazy",
  dependencies = { "mfussenegger/nvim-dap" },

  opts = {
    ensure_installed = {},

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
      port = 8123,
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          8123,
        },
      },
    }

    local function ask(prompt, default, cb)
      vim.ui.input(
        { prompt = prompt .. " (default: " .. default .. "): " },
        function(inp) cb(inp ~= "" and inp or default) end
      )
    end

    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = 9222,
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "9222",
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
        console = "integratedTerminal",
        skipFiles = { "<node_internals>/**" },
      },
    }

    local function pick_url(callback)
      vim.ui.input(
        { prompt = "URL to debug (default: http://localhost:9000): " },
        function(input) callback(input ~= "" and input or "http://localhost:9000") end
      )
    end

    -- Helper functions
    local function scan_apps()
      local root = vim.fn.getcwd()
      local pattern = root .. "/apps/*"
      local results = vim.fn.glob(pattern, 1, 1)
      local apps = {}

      for _, path in ipairs(results) do
        if vim.fn.isdirectory(path) == 1 then 
          table.insert(apps, path:match "apps/([^/]+)$") 
        end
      end

      return apps
    end

    local function pick_app(apps, callback)
      vim.ui.select(apps, {
        prompt = "Select Next.js app:",
      }, function(choice) callback(choice) end)
    end

    local function ask_port(callback, default_port)
      default_port = default_port or 3000
      vim.ui.input({
        prompt = "Port (default: " .. default_port .. "): ",
      }, function(input)
        if input == nil or input == "" then
          callback(default_port)
        else
          callback(tonumber(input) or default_port)
        end
      end)
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
        runtimeExecutable = chromium,
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
      {
        type = "pwa-node",
        request = "launch",
        name = "Next.js Dev (Interactive)",
        runtimeExecutable = function()
          return coroutine.create(function(coro)
            local apps = scan_apps()
            
            if #apps == 0 then
              print "No apps found under ./apps"
              coroutine.resume(coro, nil)
              return
            end

            pick_app(apps, function(selected_app)
              if not selected_app then
                coroutine.resume(coro, nil)
                return
              end

              ask_port(function(port)
                -- Store values for use in other config fields
                vim.g.dap_nextjs_app = selected_app
                vim.g.dap_nextjs_port = port
                coroutine.resume(coro, "npm")
              end, 3000)
            end)
          end)
        end,
        runtimeArgs = function()
          -- Use the stored values
          local port = vim.g.dap_nextjs_port or 3000
          return { "run", "dev", "--", "-p", tostring(port) }
        end,
        cwd = function()
          local app = vim.g.dap_nextjs_app or "admin"
          return "${workspaceFolder}/apps/" .. app
        end,
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
        outFiles = {
          "${workspaceFolder}/.next/**/*.js",
          "${workspaceFolder}/apps/**/.next/**/*.js",
          "${workspaceFolder}/packages/**/.next/**/*.js",
        },
      },
    }

    dap.configurations.typescriptreact = dap.configurations.javascriptreact

    -- 3) Attach the configuration to filetypes
    dap.configurations.javascript = shared
    dap.configurations.typescript = shared

    local function start_nextjs_debug()
      local apps = scan_apps()

      if #apps == 0 then
        print "No apps found under ./apps"
        return
      end

      pick_app(apps, function(selected_app)
        if not selected_app then return end

        ask_port(
          function(port)
            dap.run {
              type = "pwa-node",
              request = "launch",
              name = "Next.js Turbo Debug",

              cwd = "${workspaceFolder}/apps/" .. selected_app,

              runtimeExecutable = "npm",
              runtimeArgs = { "run", "dev" },

              env = {
                NODE_OPTIONS = "--inspect=" .. port,
              },

              console = "integratedTerminal",

              sourceMaps = true,
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              },
            }
          end,
          9229
        )
      end)
    end

    vim.keymap.set("n", "<leader>dn", start_nextjs_debug, { desc = "Debug Next.js (Turbo)" })
  end,
}

-- For typescript debugging, you can use the following configuration:
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
