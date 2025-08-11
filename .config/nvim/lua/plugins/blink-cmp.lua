return {
  "saghen/blink.cmp",

  opts = {
    keymap = {
      -- Override default navigation keys
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },

      -- Use TAB to accept completion
      ["<Tab>"] = { "accept", "fallback" },
    },
  },
}
