-- Options are automatically loaded before lazy.nvim startup
-- mapleader must be set before lazy loads plugins
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- Softtabs, 2 spaces (LazyVim default is 2 as well, kept explicit)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.numberwidth = 5
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- :w and :q capital variants (from old vimrc)
local aliases = {
  Q = "q",
  W = "w",
  WQ = "wq",
  Wq = "wq",
  WA = "wa",
  Wa = "wa",
  QA = "qa",
  Qa = "qa",
  Wqa = "wqa",
  WQa = "wqa",
  WQA = "wqa",
}
for lhs, rhs in pairs(aliases) do
  vim.api.nvim_create_user_command(lhs, rhs, {})
end
