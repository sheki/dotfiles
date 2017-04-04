set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
" Plugin 'Yggdroot/indentLine'
Plugin 'gmarik/Vundle.vim'
Plugin 'mxw/vim-jsx'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'tomtom/tcomment_vim'
Plugin 'ternjs/tern_for_vim'
Plugin 'pangloss/vim-javascript'
Plugin 'gavocanov/vim-js-indent'
Plugin 'junegunn/seoul256.vim'
Plugin 'AndrewRadev/splitjoin.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'Valloric/YouCompleteMe'
" Plugin 'SirVer/ultisnips'
Plugin 'flowtype/vim-flow'
" Plugin 'lambdatoast/elm.vim'
Plugin 'tpope/vim-surround'
Plugin 'chriskempson/base16-vim'
Plugin 'tpope/vim-rails'
Plugin 'cocopon/iceberg.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tmhedberg/matchit'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'mhinz/vim-startify'
Plugin 'itchyny/lightline.vim'
" Plugin 'vim-airline/vim-airline'
Plugin 'morhetz/gruvbox'
Plugin 'zhaocai/GoldenView.Vim'
Plugin 'w0rp/ale'
Plugin 'junegunn/vim-emoji'
Plugin 'inside/vim-textobj-jsxattr'
Plugin 'majutsushi/tagbar'
call vundle#end()            " required

set lazyredraw
set wildmenu
set cursorline
set incsearch
set hlsearch
nnoremap <leader><space> :nohlsearch<CR>

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '💩'
let g:javascript_plugin_flow = 1
let g:jsx_ext_required = 0
filetype plugin indent on    " required
map <F1> <Esc>
set cc=80
set t_Co=256
set nonumber
filetype plugin on
filetype indent on
set autoread
set cmdheight=2

let g:hybrid_use_iTerm_colors = 1
colorscheme gruvbox
set bg=light

let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
set encoding=utf8
set nobackup
set nowb
set noswapfile
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent

set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set laststatus=2

syntax on
"GO
let g:go_fmt_command="goimports"
let g:go_highlight_operators=1
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_structs=1

let mapleader = "\<Space>"
nmap <leader>b :Buffers<CR>
nmap <leader>m :History<CR>
nmap <leader>f :Files<CR>

" so that go-code does not pop up a scratch
set completeopt-=preview
set completeopt+=longest
" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif
let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode

set clipboard=unnamed
" set relativenumber
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"all faith vim-go
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au BufRead *.md setlocal spell

autocmd BufWritePre *.rb %s/\s\+$//e
autocmd BufWritePre *.md %s/\s\+$//e
autocmd BufWritePre *.js %s/\s\+$//e
autocmd BufWritePre *.jsx %s/\s\+$//e

"" experimental vimrc for snipmate
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']

let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
"
""" Tern for js
let g:tern_map_keys=1

" set foldmethod=indent
" set foldnestmax=5
" set foldlevel=1
" let g:ag_prg="ag --ignore /node_modules/ --ignore \\\*.min.js --vimgrep"
set autowrite

"" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:flow#autoclose = 1
let g:flow#enable = 0
" set so=999
inoremap jj <Esc>
" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endi
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>
let g:indentLine_setColors = 0

" autocmd VimEnter * if
" \ argc() == 0 &&
" \ bufname("%") == "" |
" \   exe "normal! `0" |
" \ endif
"
if &diff
  colorscheme base16-github
  set bg=light
endif
set termguicolors
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '

command! -bang -nargs=* F call fzf#vim#grep(g:rg_command .shellescape(<q-args>), 1, <bang>0)
let g:startify_change_to_dir = 0
runtime macros/matchit.vim
autocmd FileType gitcommit setlocal spell
let g:airline_them = 'gruvbox'
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
let g:ale_sign_column_always = 1
" let g:lightline = {
"       \ 'colorscheme': 'iceberg',
"       \ }
"
if $ITERM_PROFILE =~ "vim"
  colorscheme iceberg
endif
set tags=./git/tags
