-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Finders (LazyVim uses snacks picker; keeps behavior of old Telescope maps)
map("n", "<C-p>", LazyVim.pick("files"), { desc = "Find files" })
map("n", "<C-f>", LazyVim.pick("live_grep"), { desc = "Live grep" })
map("n", "<C-m>", LazyVim.pick("buffers"), { desc = "Buffers" })
map("n", "<leader><Space>", LazyVim.pick("grep_word"), { desc = "Grep word under cursor" })
map("n", "<leader>?", LazyVim.pick("keymaps"), { desc = "Search all keymaps" })
map({ "n", "i" }, "<C-S-p>", LazyVim.pick("keymaps"), { desc = "Command palette (keymaps)" })

-- Yank history
map("n", "<C-c>", "<cmd>YankBank<cr>", { desc = "Yank history" })

-- Tabs / buffers
map("n", "t", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<C-t>", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<S-k>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-j>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<C-x>", "<cmd>q!<cr>", { desc = "Quit!" })

-- Save
map("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })

-- Window navigation from insert mode
map("i", "<C-w>", "<Esc><C-w>", { desc = "Window command" })

-- LSP code actions (port of the old coc bindings; LazyVim default is <leader>ca)
map({ "n", "x" }, "<leader>.", vim.lsp.buf.code_action, { desc = "Code action" })
map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>qf", function()
  vim.lsp.buf.code_action({ context = { only = { "quickfix" } } })
end, { desc = "Quick-fix current" })

-- Organize imports (old coc `:OR`)
local function organize_imports()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" }, diagnostics = {} },
    apply = true,
  })
end
map("n", "<leader>oi", organize_imports, { desc = "Organize imports" })
vim.api.nvim_create_user_command("OR", organize_imports, {})
