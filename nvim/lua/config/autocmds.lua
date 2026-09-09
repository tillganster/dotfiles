-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 4 spaces in Python and Bazel
autocmd("FileType", {
  group = augroup("indent4", { clear = true }),
  pattern = { "python", "bzl" },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
  end,
})

-- Shell highlighting for *.zsh-theme
autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("zsh_theme", { clear = true }),
  pattern = "*.zsh-theme",
  callback = function()
    vim.bo.syntax = "sh"
  end,
})

-- Auto-organize imports on save (TS/JS/Go), like coc's OR
autocmd("BufWritePre", {
  group = augroup("organize_imports", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.go" },
  callback = function()
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" }, diagnostics = {} },
      apply = true,
    })
  end,
})

-- Soft-wrap prose files
autocmd("FileType", {
  group = augroup("prose_wrap", { clear = true }),
  pattern = { "text", "markdown", "html", "xhtml", "eruby" },
  callback = function()
    vim.wo.wrap = true
    vim.wo.linebreak = true
    vim.opt_local.list = false
  end,
})
