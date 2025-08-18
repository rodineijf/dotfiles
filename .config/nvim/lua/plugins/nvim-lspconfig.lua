return {
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gD", function() Snacks.picker.lsp_references() end, nowait = true, desc = "+References", },
      })
    end,
  },
}
