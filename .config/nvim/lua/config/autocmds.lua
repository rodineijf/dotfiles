-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*.clj", "*.cljc", "*.cljs", "!*/project.clj" },
  callback = function()
    vim.notify("Buffer written", vim.log.levels.INFO, {
      title = "Conjure Auto-eval",
      timeout = 1000,
    })

    -- Check if Conjure is available
    if vim.fn.exists(":ConjureEvalBuf") ~= 2 then
      vim.notify("Conjure is not available", vim.log.levels.WARN, {
        title = "Conjure Auto-eval",
        timeout = 1000,
      })
      return
    end

    -- Check if we're in a Clojure buffer and Conjure is active
    local filetype = vim.bo.filetype
    if not (filetype == "clojure" or filetype == "clojurescript") then
      vim.notify("Not a Clojure buffer", vim.log.levels.WARN, {
        title = "Conjure Auto-eval",
        timeout = 1000,
      })
      return
    end

    -- Try to evaluate with better error handling and feedback
    local ok, result = pcall(vim.cmd, "ConjureEvalBuf")
    if not ok then
      -- Show a subtle message if evaluation failed
      vim.notify("Conjure evaluation failed - ensure REPL is connected", vim.log.levels.WARN, {
        title = "Conjure Auto-eval",
        timeout = 3000,
      })
    else
      -- Optional: Show a brief success notification (can be removed if too noisy)
      vim.notify("Buffer evaluated", vim.log.levels.INFO, {
        title = "Conjure Auto-eval",
        timeout = 1000,
      })
    end
  end,
  desc = "Auto-evaluate Clojure buffer on save with Conjure",
})
