return {
  -- { "jose-elias-alvarez/typescript.nvim", lazy = true }, -- add lsp plugin
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      setup_handlers = {
        -- add custom handler
        tsserver = function(_, opts) require("typescript").setup { server = opts } end,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "yaml-language-server",
        "bash-debug-adapter",
        "css-lsp",
        "debugpy",
        "delve",
        "eslint_d",
        "fixjson",
        "gofumpt",
        "goimports",
        "gopls",
        "html-lsp",
        "js-debug-adapter",
        "json-lsp",
        "jsonlint",
        "lua-language-server",
        "markdownlint",
        "marksman",
        "prettierd",
        "quick-lint-js",
        "selene",
        "shellcheck",
        "sqlls",
        "stylua",
      }, -- automatically install lsp
    },
  },
}
