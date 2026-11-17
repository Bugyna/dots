
return {
  dir = "~/.config/nvim/lua/db-interactive", -- local path
  lazy = false,
  priority = 1000,
  config = function()
    vim.g["db#dbi_window_command"] = "rightbelow 60vnew"
  end,
}
