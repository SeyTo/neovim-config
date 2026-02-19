if true then return {} end

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      instructions_file = "CLAUDE.md",
      provider = "claude",
      -- provider = "ollama",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-6",
          timeout = 30000, -- Timeout in milliseconds
          auth_type = "max",
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
        -- moonshot = {
        --   endpoint = "https://api.moonshot.ai/v1",
        --   model = "kimi-k2-0711-preview",
        --   timeout = 30000, -- Timeout in milliseconds
        --   extra_request_body = {
        --     temperature = 0.75,
        --     max_tokens = 32768,
        --   },
        -- },
        -- ollama = {
        --   endpoint = "http://localhost:11434",
        --   model = "qwen3:latest", -- your desired model (or use gpt-4o, etc.)
        -- },
        --   mistral = {
        --     __inherited_from = "openai",
        --     api_key_name = "MISTRAL_API_KEY",
        --     endpoint = "https://api.mistral.ai/v1/",
        --     model = "mistral-large-latest",
        --     extra_request_body = {
        --       max_tokens = 4096, -- to avoid using max_completion_tokens
        --     },
        --   },
        -- aihubmix = {
        --   model = "gpt-4o-2024-11-20",
        -- },
      },

      -- openai = {
      --   endpoint = "http://localhost:11434",
      --   timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      --   temperature = 0,
      --   max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
      -- },
      input = {
        provider = "snacks", -- workaround: native provider broken by commit 9b72d16
      },
      behaviour = {
        --- ... existing behaviours
        enable_cursor_planning_mode = true, -- enable cursor planning mode!
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    rag_service = {
      enabled = true, -- Enables the RAG service
      host_mount = os.getenv "HOME", -- Host mount path for the rag service
      provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
      llm_model = "qwen3:latest", -- The LLM model to use for RAG service
      embed_model = "", -- The embedding model to use for RAG service
      endpoint = "http://localhost:11434", -- The API endpoint for RAG service
    },
    web_search_engine = {
      provider = "tavily", -- tavily, serpapi, searchapi, google, kagi, brave, or searxng
      proxy = nil, -- proxy support, e.g., http://127.0.0.1:7890
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
