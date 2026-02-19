---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- install language servers
        "lua-language-server",
        "gopls",
        "marksman",
        "sqlls",
        -- install formatters
        "stylua",
        "yaml-language-server",
        "bash-debug-adapter",
        "selene",
        "shellcheck",
        -- install debuggers
        "debugpy",
        "delve",
        "chrome-debug-adapter",
        "node-debug2-adapter",
        -- install any other package
        "tree-sitter-cli",
        "stylua",
        -- "eslint_d",
        "jsonlint",
        "quick-lint-js",
        "fixjson",
        "prettierd",
        -- "luacheck",
        "markdownlint",
      },
    },
  },
}
