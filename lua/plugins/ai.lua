return {
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    opts = {
      keymaps = {
        accept_suggestion = "<C-b>",
        -- clear_suggestion = "<C-h>",
        accept_word = "<C-h>",
      },
      log_level = "warn",
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false, -- disables built in keymaps for more manual control
    },
  },
  {
    "Exafunction/windsurf.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      {
        "AstroNvim/astroui",
        ---@type AstroUIOpts
        opts = {
          icons = {
            Codeium = "",
          },
        },
      },
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          return require("astrocore").extend_tbl(opts, {
            mappings = {
              n = {
                ["<Leader>;"] = {
                  desc = require("astroui").get_icon("Codeium", 1, true) .. "Codeium",
                },
                ["<Leader>;o"] = {
                  desc = "Open Chat",
                  function() vim.cmd "Codeium Chat" end,
                },
                ["<Leader>;;"] = {
                  desc = "Toggle codeium",
                  function() vim.cmd "Codeium Toggle" end,
                },
              },
              i = {
                ["<C-g>"] = {
                  function() return vim.fn["codeium#Accept"]() end,
                  expr = true,
                },
                ["<C-;>"] = {
                  function() return vim.fn["codeium#CycleCompletions"](1) end,
                  expr = true,
                },
                ["<C-,>"] = {
                  function() return vim.fn["codeium#CycleCompletions"](-1) end,
                  expr = true,
                },
                ["<C-x>"] = {
                  function() return vim.fn["codeium#Clear"]() end,
                  expr = true,
                },
              },
            },
          })
        end,
      },
    },
    cmd = {
      "Codeium",
      "CodeiumEnable",
      "CodeiumDisable",
      "CodeiumToggle",
      "CodeiumAuto",
      "CodeiumManual",
    },
    event = "BufEnter",
    opts = {
      enable_chat = true,
    },
    specs = {
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        opts = function(_, opts)
          -- Inject codeium into cmp sources, with high priority
          table.insert(opts.sources, 1, {
            name = "codeium",
            group_index = 1,
            priority = 10000,
          })
        end,
      },
      {
        "onsails/lspkind.nvim",
        optional = true,
        -- Adds icon for codeium using lspkind
        opts = function(_, opts)
          if not opts.symbol_map then opts.symbol_map = {} end
          opts.symbol_map.Codeium = require("astroui").get_icon("Codeium", 1, true)
        end,
      },
    },
    config = function() require("codeium").setup {} end,
  },
}
