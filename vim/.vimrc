set nocompatible
filetype plugin indent on
syntax on

set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent
set autoindent

set ignorecase
set smartcase
set incsearch
set hlsearch

set showmatch
set nowrap
set background=dark
set laststatus=2
set ruler

set hidden
set updatetime=300

if has("termguicolors")
  set termguicolors
endif

hi clear
syntax reset
let g:colors_name = "catppuccin-mocha"
let g:vimwiki_list = [{'path': '~/wiki/', 'syntax': 'markdown'}]

hi Normal       guifg=#cdd6f4 guibg=#1e1e2e
hi CursorLine   guibg=#313244
hi CursorLineNr guifg=#f9e2af guibg=#313244
hi LineNr       guifg=#7f849c guibg=#1e1e2e
hi StatusLine   guifg=#cdd6f4 guibg=#45475a
hi StatusLineNC guifg=#7f849c guibg=#45475a
hi VertSplit    guifg=#45475a guibg=#45475a
hi Visual       guibg=#585b70
hi Search       guifg=#1e1e2e guibg=#f9e2af
hi IncSearch    guifg=#1e1e2e guibg=#fab387
hi MatchParen   guifg=#f38ba8 guibg=#45475a

hi Comment      guifg=#7f849c gui=italic
hi Constant     guifg=#fab387
hi String       guifg=#a6e3a1
hi Identifier   guifg=#89b4fa
hi Statement    guifg=#cba6f7
hi PreProc      guifg=#fab387
hi Type         guifg=#f9e2af
hi Special      guifg=#89dceb
hi Underlined   guifg=#89b4fa gui=underline
hi Todo         guifg=#f9e2af guibg=#45475a gui=bold

autocmd FileType html,css,javascript,typescript,json setlocal tabstop=2 shiftwidth=2 expandtab
autocmd FileType html setlocal matchpairs+=<:>
autocmd FileType css setlocal iskeyword+=-
autocmd FileType javascript,typescript setlocal formatoptions+=cro

let mapleader=" "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>n :set relativenumber!<CR>
nnoremap <leader>r :%s/\<<C-r><C-w>\>/

set foldmethod=syntax
set foldlevelstart=99

inoremap { {}<Left>
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
