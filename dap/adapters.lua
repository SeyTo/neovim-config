return {
  go = {
    type = "server",
    port = 12314,
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:" .. 12314 },
    },
    options = {
      initialize_timeout_sec = 20,
    },
    -- type = "executable",
    -- command = "node",
    -- args = { os.getenv "HOME" .. "/dev/golang/vscode-go/dist/debugAdapter.js" },
  },
  -- ["pwa-node"] = {
  --   type = "server",
  --   host = "localhost",
  --   port = "${port}",
  --   -- executable = {
  --   --   command = "js-debug-adapter",
  --   --   args = { "8122" },
  --   -- },
  -- },
}
