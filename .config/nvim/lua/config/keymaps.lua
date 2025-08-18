-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Paste pop
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")

-- Bind cmd+/ to comment line (gcc)
map("n", "<D-/>", "gcc", { desc = "Comment line", remap = true })
map("v", "<D-/>", "gc", { desc = "Comment selection", remap = true })
