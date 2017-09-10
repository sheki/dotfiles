set nocompatible              " be iMproved, required
filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'mxw/vim-jsx'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'tomtom/tcomment_vim'
Plugin 'ternjs/tern_for_vim'
Plugin 'pangloss/vim-javascript'
Plugin 'gavocanov/vim-js-indent'
Plugin 'AndrewRadev/splitjoin.vim'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'flowtype/vim-flow'
Plugin 'chriskempson/base16-vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-rails'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tmhedberg/matchit'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'mhinz/vim-startify'
Plugin 'w0rp/ale'
Plugin 'inside/vim-textobj-jsxattr'
Plugin 'majutsushi/tagbar'
Plugin 'benmills/vimux'
Plugin 'janko-m/vim-test'
Plugin 'tpope/vim-rhubarb'
Plugin 'SirVer/ultisnips'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-fireplace'
Plugin 'vim-scripts/dbext.vim'
Plugin 'mtth/scratch.vim'
call vundle#end()            " required
let test#strategy = "vimux"

set lazyredraw
set wildmenu

set cursorline
set incsearch
nnoremap <leader>c :nohlsearch<CR>

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
let base16colorspace=256 
color base16-gruvbox-dark-hard

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

" syntax on
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

set clipboard+=unnamed
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

set autowrite

"" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:flow#autoclose = 1
let g:flow#enable = 0
" set so=999
inoremap jj <Esc>
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>
let g:indentLine_setColors = 0

" autocmd VimEnter * if
" \ argc() == 0 &&
" \ bufname("%") == "" |
" \   exe "normal! `0" |
" \ endif
"
let g:rg_command = '
  \ rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --color "always"
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf}"
  \ -g "!{.git,node_modules,vendor}/*" '

let g:startify_change_to_dir = 0
runtime macros/matchit.vim
autocmd FileType gitcommit setlocal spell
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)


set tags=./git/tags
noremap <silent><Leader>ag :Ag <C-R><C-W><CR>
noremap <silent><Leader>fg :Files <CR><C-W><CR>

nnoremap <F5> "=strftime("%Y/%m/%d")<CR>P
inoremap <F5> <C-R>=strftime("%Y/%m/%d")<CR>
set splitright

let g:ale_fixers = {
\ 'javascript': ['prettier']
\}
" \ 'ruby': ['rubocop']
let g:ale_javascript_prettier_options = '--trailing-comma es5 --no-bracket-spacing'
let g:ale_fix_on_save = 1

" fzf settings
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif
let g:airline#extensions#ale#enabled = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:dbext_default_profile_flexport_development='type=pgsql:host=localhost:user=postgres:dsnname=flexport_development:dbname=flexport_development'
let g:dbext_default_profile='flexport_development'
