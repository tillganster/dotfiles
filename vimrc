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
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }


Plug 'sheerun/vim-polyglot', { 'tag': 'v4.4.3' }
Plug 'google/vim-maktaba', { 'tag': 'v0.15.0' }
Plug 'bazelbuild/vim-bazel'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'stephpy/vim-yaml'
"Plug 'crusoexia/vim-dracula'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'ryanoasis/vim-devicons'
Plug 'andrewstuart/vim-kubernetes'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-fugitive', { 'tag': 'v3.0' }
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py' }
Plug 'easymotion/vim-easymotion'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" completion 
" For vsnip users.
call plug#end()

" Map ctrl-n to toggle NERDTree.
map <C-n> :NERDTreeToggle<CR>

autocmd FileType nerdtree nnoremap <buffer> <S-k> :tabn<CR>
autocmd FileType nerdtree nnoremap <buffer> <S-j> :tabp<CR>

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
nnoremap <S-k> :tabn<CR>
nnoremap <S-j> :tabp<CR>
nnoremap <C-x> :q!<CR>
" configs for utilssnippt
let g:UltiSnipsExpandTrigger="<Enter>"

nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
inoremap <C-w> <Esc><C-w>
