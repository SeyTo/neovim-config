return {
  -- { "jose-elias-alvarez/typescript.nvim", lazy = true }, -- add lsp plugin
  {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
      setup_handlers = {
        -- add custom handler
        -- tsserver = function(_, opts) require("typescript").setup { server = opts } end,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "yaml-language-server",
        "bash-debug-adapter",
        "markdownlint",
        "marksman",
        "selene",
        "shellcheck",
        "sqlls",
      }, -- automatically install lsp
    },
  },
}
