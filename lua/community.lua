-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.python.base" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.black" },
  { import = "astrocommunity.pack.python.isort" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },
}
