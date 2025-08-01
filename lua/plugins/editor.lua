return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 1,
        width = function() return math.min(120, vim.o.columns * 0.75) end,
        height = 0.9,
        options = {
          number = false,
          relativenumber = true,
          foldcolumn = "0",
          list = false,
          showbreak = "NONE",
          signcolumn = "no",
        },
      },
      plugins = {
        options = {
          cmdheight = 1,
          laststatus = 0,
        },
      },
      on_open = function() -- disable diagnostics and indent blankline
        vim.g.diagnostics_mode_old = vim.g.diagnostics_mode
        vim.g.diagnostics_mode = 1
        -- vim.diagnostic.config(require("astronvim.utils.lsp").diagnostics[0])
        vim.g.indent_blankline_enabled_old = vim.g.indent_blankline_enabled
        vim.g.indent_blankline_enabled = false
      end,
      on_close = function() -- restore diagnostics and indent blankline
        vim.g.diagnostics_mode = vim.g.diagnostics_mode_old
        -- vim.diagnostic.config(require("astronvim.utils.lsp").diagnostics[vim.g.diagnostics_mode])
        vim.g.indent_blankline_enabled = vim.g.indent_blankline_enabled_old
      end,
    },
  },
  { "machakann/vim-sandwich", event = "User AstroFile" },
  -- {
  --   "Exafunction/windsurf.nvim",
  --   commit = "937667b2cadc7905e6b9ba18ecf84694cf227567",
  --   enable = false,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --     {
  --       "AstroNvim/astroui",
  --       ---@type AstroUIOpts
  --       opts = {
  --         icons = {
  --           Codeium = "",
  --         },
  --       },
  --     },
  --     {
  --       "AstroNvim/astrocore",
  --       ---@param opts AstroCoreOpts
  --       opts = function(_, opts)
  --         return require("astrocore").extend_tbl(opts, {
  --           mappings = {
  --             n = {
  --               ["<Leader>;"] = {
  --                 desc = require("astroui").get_icon("Codeium", 1, true) .. "Codeium",
  --               },
  --               ["<Leader>;o"] = {
  --                 desc = "Open Chat",
  --                 function() vim.cmd "Codeium Chat" end,
  --               },
  --               ["<Leader>;;"] = {
  --                 desc = "Toggle codeium",
  --                 function() vim.cmd "Codeium Toggle" end,
  --               },
  --             },
  --             i = {
  --               ["<C-g>"] = {
  --                 function() return vim.fn["codeium#Accept"]() end,
  --                 expr = true,
  --               },
  --               ["<C-;>"] = {
  --                 function() return vim.fn["codeium#CycleCompletions"](1) end,
  --                 expr = true,
  --               },
  --               ["<C-,>"] = {
  --                 function() return vim.fn["codeium#CycleCompletions"](-1) end,
  --                 expr = true,
  --               },
  --               ["<C-x>"] = {
  --                 function() return vim.fn["codeium#Clear"]() end,
  --                 expr = true,
  --               },
  --             },
  --           },
  --         })
  --       end,
  --     },
  --   },
  --   cmd = {
  --     "Codeium",
  --     "CodeiumEnable",
  --     "CodeiumDisable",
  --     "CodeiumToggle",
  --     "CodeiumAuto",
  --     "CodeiumManual",
  --   },
  --   event = "BufEnter",
  --   opts = {
  --     enable_chat = true,
  --   },
  --   specs = {
  --     {
  --       "hrsh7th/nvim-cmp",
  --       optional = true,
  --       opts = function(_, opts)
  --         -- Inject codeium into cmp sources, with high priority
  --         table.insert(opts.sources, 1, {
  --           name = "codeium",
  --           group_index = 1,
  --           priority = 10000,
  --         })
  --       end,
  --     },
  --     {
  --       "onsails/lspkind.nvim",
  --       optional = true,
  --       -- Adds icon for codeium using lspkind
  --       opts = function(_, opts)
  --         if not opts.symbol_map then opts.symbol_map = {} end
  --         opts.symbol_map.Codeium = require("astroui").get_icon("Codeium", 1, true)
  --       end,
  --     },
  --   },
  --   config = function() require("codeium").setup {} end,
  -- },
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function() require("spectre").setup() end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"

      harpoon:setup()

      vim.keymap.set("n", "<Leader>H", function() harpoon:list():add() end)
      vim.keymap.set("n", "<Leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      vim.keymap.set("n", "<Leader>1", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<Leader>2", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<Leader>3", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<Leader>4", function() harpoon:list():select(4) end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<Leader>[", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<Leader>]", function() harpoon:list():next() end)
    end,
  },
  {
    "ggandor/leap.nvim",
    dependencies = {
      { "tpope/vim-repeat" },
    },
    config = function(plugin, opts) require("leap").create_default_mappings() end,
  },
}
