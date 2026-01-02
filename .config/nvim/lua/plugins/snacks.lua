return {
  {
    "folke/snacks.nvim",
    -- opts = {
    --   picker = {
    --     hidden = true,
    --     ignored = true,
    --     sources = {
    --       files = {
    --         hidden = true,
    --       },
    --     },
    --   },
    -- },
    keys = {
      {
        "<leader>'",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume",
      },
    },
  },
}
