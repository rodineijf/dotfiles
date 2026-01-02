local M = {}

-- URL encode for queries
local function urlencode(str)
  if str == nil then
    return ""
  end
  str = str:gsub("([^%w _%%%-%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
  str = str:gsub(" ", "%%20")
  return str
end

---
---Search github org:nubank for selected text or prompt for input
---
M.search_github_nubank = function()
  local mode = vim.fn.mode()
  local query = nil
  -- Try to get visual selection
  if mode == "v" or mode == "V" or mode == "\22" then
    -- save previous reg
    local prev_reg = vim.fn.getreg("a")
    vim.cmd('normal! "ay')
    query = vim.fn.getreg("a")
    vim.fn.setreg("a", prev_reg) -- restore
    vim.cmd("normal! gv") -- reselect visual
    if query == "" or query == nil then
      query = nil
    end
  end
  if not query then
    vim.ui.input({ prompt = "Search term: " }, function(input)
      query = input or ""
      if #query > 0 then
        local url = "https://github.com/search?q=org:nubank+" .. urlencode(query) .. "&type=code"
        vim.fn.system({ "open", url })
      end
    end)
  else
    local url = "https://github.com/search?q=org:nubank+" .. urlencode(query) .. "&type=code"
    vim.fn.system({ "open", url })
  end
end

return M
