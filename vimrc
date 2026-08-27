" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set encoding=UTF-8

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set nobackup
set nowritebackup
set history=50 " keep 50 lines of command line history
set ruler " show the cursor position all the time
set showcmd " display incomplete commands
set incsearch " do incremental searching
set nowrap " Switch wrap off for everything
set number
set numberwidth=5
set laststatus=2 " Always display the status line

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Tab completion options
" (only complete to the longest unambiguous match, and show a menu)
set completeopt=longest,menu
set wildmode=list:longest,list:full
set complete=.,t

" Remap :w and :q to allow the capital letter versions.
command! Q q
command! W w
command! WQ wq
command! Wq wq
command! WA wa
command! Wa wa
command! QA qa
command! Qa qa
command! Wqa wqa
command! WQa wqa
command! WQA wqa

let mapleader=","
" Instal vim-plug if it doesn't exist.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif



" Load plugins
call plug#begin()

Plug 'cmhamill/vim-jrnl'
Plug 'romgrk/barbar.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'vim-airline/vim-airline', { 'tag': 'v0.10' }

if executable('node')
  Plug 'neoclide/coc.nvim', { 'branch': 'release' }
endif

" telescope for better fzf etc
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'fannheyward/telescope-coc.nvim'

" clipboard history 
Plug 'ptdewey/yankbank-nvim'

Plug 'google/vim-maktaba', { 'tag': 'v0.15.0' }
Plug 'bazelbuild/vim-bazel'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
"Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown', 'do': 'npm install'}
Plug 'stephpy/vim-yaml'
"Plug 'crusoexia/vim-dracula'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ryanoasis/vim-devicons'
Plug 'andrewstuart/vim-kubernetes'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'neoclide/coc-snippets'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.0' }
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py' }
Plug 'easymotion/vim-easymotion'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" git integrations 
Plug 'lewis6991/gitsigns.nvim'
" Debugging 
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-neotest/nvim-nio'

Plug 'mason-org/mason.nvim'
Plug 'jay-babu/mason-nvim-dap.nvim'


" command palette helper stuff
Plug 'folke/which-key.nvim'
call plug#end()




" which-key: shows a popup of available keybindings after you press a
" prefix key (e.g. <leader>) and pause. Also register human-readable names
" for the leader-prefixed groups used throughout this config so the popup
" is legible instead of just showing raw command text.
lua << EOF
local wk = require("which-key")
wk.setup({})
wk.add({
  { "<leader>h", group = "git hunk" },
  { "<leader>t", group = "toggle" },
  { "<leader>l", group = "coc list" },
  { "<leader>a", group = "code action" },
  { "<leader>f", desc = "format selection" },
  { "<leader>.", desc = "code action (cursor)" },
  { "<leader>rn", desc = "rename symbol" },
  { "<leader>qf", desc = "quickfix" },
  { "<leader>K", desc = "coc hover" },
  { "<leader><space>", desc = "grep word under cursor" },
  { "<leader>j", desc = "easymotion down" },
  { "<leader>k", desc = "easymotion up" },
  { "<leader>?", desc = "search all keymaps (Telescope)" },
})
vim.keymap.set("n", "<leader>wk", function() wk.show() end, { desc = "show all keybindings (which-key root)" })
EOF

" Yank history with overlay
lua << EOF
require('yankbank').setup()
EOF

" gitsigns — git hunk navigation and staging
lua << EOF
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
    end

    -- Hunk navigation (C-j/C-k chosen over [/] to avoid German keyboard awkwardness)
    map('n', '<C-j>', gs.next_hunk, 'Next hunk')
    map('n', '<C-k>', gs.prev_hunk, 'Prev hunk')

    -- Hunk operations
    map('n', '<leader>hs', gs.stage_hunk,      'Stage hunk')
    map('n', '<leader>hr', gs.reset_hunk,      'Reset hunk')
    map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
    map('n', '<leader>hp', gs.preview_hunk,    'Preview hunk')
    map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')

    -- Toggle views
    map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle line blame')
    map('n', '<leader>td', gs.toggle_deleted,            'Toggle deleted')
    map('n', '<leader>tw', gs.toggle_word_diff,          'Toggle word diff')
    map('n', '<leader>tf', function() vim.cmd('Git blame') end, 'Toggle file blame')
  end
})
EOF

" Map ctrl-c to toggle yankbank 
map <C-c> :YankBank<CR>

" Map ctrl-n to toggle NERDTree.
map <C-n> :NERDTreeToggle<CR>

autocmd FileType nerdtree nnoremap <buffer> <S-k> :BufferNext<CR>
autocmd FileType nerdtree nnoremap <buffer> <S-j> :BufferPrevious<CR>

" case only matters with mixed case expressions
set ignorecase
set smartcase
if exists("&wildignorecase")
  set wildignorecase
endif

set mouse=a " Enable mouse.

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running"))
  syntax on
  set hlsearch

  " Color scheme
  syntax enable
  set termguicolors
  colorscheme dracula
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  set cino=N-s " do not indent after C++ namespace
  " Set File type to 'text' for files ending in .txt
  autocmd BufNewFile,BufRead *.txt setfiletype text
  " Enable soft-wrapping for text files
  autocmd FileType text,markdown,html,xhtml,eruby setlocal wrap linebreak nolist
  " Set default tab width to 4 spaces in Python and Bazel
  au Filetype python,bzl setl et ts=4 sw=4
  " Set shell script syntax highlighting for zsh-theme files
  au BufRead,BufNewFile *.zsh-theme set syntax=sh
  " For Haml
  au! BufRead,BufNewFile *.haml setfiletype haml

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
    " Automatically load .vimrc source when saved
    autocmd BufWritePost .vimrc nested source $MYVIMRC
  augroup END
else
  " always set autoindenting on
  set autoindent
endif " has("autocmd")

if executable('rg')
  set grepprg=rg\ --vimgrep\ --color=never\ --no-heading\ --hidden
endif
" Telescope mappings
nnoremap <silent> <C-p> :<C-u>Telescope find_files hidden=true<CR>
nnoremap <silent> <C-f> :<C-u>Telescope live_grep<CR>
nnoremap <silent> <leader><Space> :<C-u>Telescope grep_string<CR>
nnoremap <silent> <C-m> :<C-u>Telescope buffers<CR>
" Fuzzy-searchable list of all keymaps (with descriptions) - use this when
" you don't remember a shortcut and want to search by name instead of
" browsing the which-key tree.
nnoremap <silent> <leader>? :<C-u>Telescope keymaps<CR>
" VSCode-style command palette shortcut. Note: most terminals don't
" distinguish Ctrl-Shift-p from Ctrl-p unless they send full Kitty/CSI-u
" keycodes (Kitty, WezTerm, some iTerm2/Alacritty setups) - if this doesn't
" fire, check your terminal's keyboard protocol support.
nnoremap <silent> <C-S-p> :<C-u>Telescope keymaps<CR>
inoremap <silent> <C-S-p> <Esc>:<C-u>Telescope keymaps<CR>

" Set up vim airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_buffers = 0

" coc.nvim config
if filereadable(glob("~/.vimrc.coc"))
  source ~/.vimrc.coc
endif

" dap debugger conf 
if filereadable(glob("~/.vimrc.dap"))
  source ~/.vimrc.dap
endif

" Local config
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

let g:coc_disable_startup_warning = 1

" tabmotions  //t to open empty new tab
nnoremap t :tabnew<CR>
nnoremap <C-t> :tabclose<CR>
nnoremap <S-k> :BufferNext<CR>
nnoremap <S-j> :BufferPrevious<CR>
nnoremap <C-x> :q!<CR>
" configs for utilssnippt
let g:UltiSnipsExpandTrigger="<Enter>"

nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
inoremap <C-w> <Esc><C-w>

