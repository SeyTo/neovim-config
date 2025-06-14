return {
  'stevearc/overseer.nvim',
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 25,
      max_height = 25,
      default_detail = 1
    },
    templates = {
      "builtin",
      "user.run_script",
    },
  },
  config = function(_, opts)
    local overseer = require("overseer")
    overseer.setup(opts)
    
    -- Register custom task template
    overseer.register_template({
      name = "run_script",
      builder = function()
        local file = vim.fn.expand("%:p")
        local cmd, args
        if vim.bo.filetype == "javascript" then
          cmd, args = "node", { file }
        elseif vim.bo.filetype == "python" then
          cmd, args = "python3", { file }
        elseif vim.bo.filetype == "lua" then
          cmd, args = "lua", { file }
        elseif vim.bo.filetype == "rust" then
          cmd, args = "cargo", { "run" }
        elseif vim.bo.filetype == "go" then
          cmd, args = "go", { "run", file }
        else
          vim.notify("Unsupported filetype: " .. vim.bo.filetype, vim.log.levels.ERROR)
          return nil
        end
        
        return {
          cmd = cmd,
          args = args,
          components = { "default" },
        }
      end,
      condition = {
        filetype = { "javascript", "python", "lua", "rust", "go" },
      },
    })
  end
}
