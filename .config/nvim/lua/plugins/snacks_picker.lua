return {
  {
    "folke/snacks.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>'", function() Snacks.picker.resume() end, desc = "Resume", },
    },
  },
}
