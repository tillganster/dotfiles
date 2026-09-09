-- Custom plugin specs extending LazyVim

return {
  -- Dracula colorscheme (matching the old vimrc)
  { "Mofiqul/dracula.nvim" },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "dracula" },
  },

  -- Yank history with overlay (was mapped to <C-c> in keymaps.lua)
  {
    "ptdewey/yankbank-nvim",
    opts = {},
  },

  -- gitsigns: keep old C-j/C-k hunk navigation + <leader>h* mappings
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation (C-j/C-k chosen over [/] to avoid German keyboard awkwardness)
        map("n", "<C-j>", gs.next_hunk, "Next hunk")
        map("n", "<C-k>", gs.prev_hunk, "Prev hunk")

        -- Hunk operations
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame line")

        -- Toggles
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>td", gs.toggle_deleted, "Toggle deleted")
        map("n", "<leader>tw", gs.toggle_word_diff, "Toggle word diff")
        map("n", "<leader>tf", "<cmd>Git blame<cr>", "Toggle file blame")
      end,
    },
  },

  -- which-key group labels for ported mappings
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>h", group = "git hunk" },
        { "<leader>t", group = "toggle" },
      },
    },
  },

  -- Bash support (no official LazyVim extra): language server + lint/format tools
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          settings = {
            bashIde = {
              shellcheckPath = "shellcheck",
            },
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "bash-language-server",
        "shellcheck",
        "shfmt",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },

  -- Extra plugins ported from vimrc (no LazyVim equivalent)
  { "bazelbuild/vim-bazel", dependencies = { "google/vim-maktaba" } },
  { "cmhamill/vim-jrnl" },
  { "andrewstuart/vim-kubernetes" },
  { "stephpy/vim-yaml" },

  -- DAP: keep the old F-key mappings on top of extras.dap.core defaults
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "DAP Continue" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "DAP Toggle Breakpoint" },
      { "<F10>", function() require("dap").step_over() end, desc = "DAP Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "DAP Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "DAP Step Out" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "DAP Terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "DAP UI Toggle" },
    },
  },
}
