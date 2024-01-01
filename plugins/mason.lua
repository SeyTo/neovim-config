-- customize mason plugins
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = {
        "lua_ls",
        "clangd",
        "cssls",
        "gopls",
        "html",
        -- "marksman",
        "neocmake",
        "jsonls",
        "pyright",
        "sqlls",
        "tsserver",
        "yamlls",
      },
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = { "shellcheck", "stylua", "black", "isort", "prettierd" },
    },
    config = function(_, opts)
      local mason_null_ls = require "mason-null-ls"
      -- local null_ls = require "null-ls"
      mason_null_ls.setup(opts)
      -- mason_null_ls.setup_handlers {
      --   taplo = function()
      --   end, -- disable taplo in null-ls, it's taken care of by lspconfig
      --   prettierd = function()
      --     null_ls.register(
      --       null_ls.builtins.formatting.prettierd.with { extra_filetypes = { "markdown", "rmd", "qmd" } }
      --     )
      --   end,
      -- }
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    -- overrides `require("mason-nvim-dap").setup(...)`
    opts = {
      ensure_installed = { "bash", "delve", "js", "python" },
    },
    config = function(_, opts)
      local mason_nvim_dap = require "mason-nvim-dap"
      mason_nvim_dap.setup(opts) -- run setup
      -- do more configuration as needed
      -- mason_nvim_dap.setup_handlers {
      --   python = function(_)
      --     local dap = require "dap"
      --     dap.adapters.python = {
      --       type = "executable",
      --       command = "/usr/bin/python3",
      --       args = {
      --         "-m",
      --         "debugpy.adapter",
      --       },
      --     }
      --
      --     dap.configurations.python = {
      --       {
      --         type = "python",
      --         request = "launch",
      --         name = "Launch file",
      --         program = "${file}", -- This configuration will launch the current file if used.
      --       },
      --     }
      --   end,
      -- }
    end,
  },
}
