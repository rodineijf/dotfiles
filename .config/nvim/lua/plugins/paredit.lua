return {
  -- Disable nvim-treesitter-sexp due to compatibility issues with Neovim 0.11+
  {
    "PaterJason/nvim-treesitter-sexp",
    enabled = false,
  },

  -- Add paredit for structural editing
  {
    "julienvincent/nvim-paredit",
    config = function()
      require("nvim-paredit").setup({
        -- Enable paredit for lisp-like languages
        filetypes = { "clojure", "fennel", "lisp", "scheme", "racket" },

        use_default_keys = true,

        -- Key mappings
        keys = {}

      })
    end,
    ft = { "clojure", "fennel", "lisp", "scheme", "racket" },
  },
}
