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
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'vim-scripts/summerfruit256.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rking/ag.vim'
Plugin 'tomasr/molokai'
Plugin 'scrooloose/syntastic'
Plugin 'tomtom/tcomment_vim'
Plugin 'rhysd/vim-clang-format'
Plugin 'vim-ruby/vim-ruby'
Plugin 'mxw/vim-jsx'
" snip mate stuff
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'elixir-lang/vim-elixir'
Plugin 'brendonrapp/smyck-vim'
Plugin 'mtscout6/syntastic-local-eslint.vim'
Plugin 'ternjs/tern_for_vim'
Plugin 'pangloss/vim-javascript'
Plugin 'romainl/flattened'
Plugin 'junegunn/seoul256.vim'
Plugin 'bronson/vim-trailing-whitespace'
call vundle#end()            " required

let g:syntastic_javascript_checkers = ['eslint', 'jscs']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
      \ "mode" : "active",
      \ "passive_filetypes" : [ "go", "javascript" ] ,
      \}


filetype plugin indent on    " required
map <F1> <Esc>
set cc=80
set t_Co=256
set nu
filetype plugin on
filetype indent on
set autoread
set cmdheight=2
let g:hybrid_use_iTerm_colors = 1
"colorscheme flattened_light
let g:seoul256_background = 236
"color seoul256
color solarized
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

" Leader stuff
let mapleader = ','
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>f :CtrlP<CR>
nmap <leader>m :CtrlPMRUFiles<CR>

let g:ctrlp_switch_buffer=1
let g:ctrpl_reuse_window=1
let g:ctrlp_custom_ignore =  'new-commit\|\.a$\|git'
function GetDir()
  return split(getcwd(), "/")[-1]
endfunction
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp-'.GetDir()
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.a"
      \ --ignore "**/*.pyc"
      \ --ignore "**/*.java"
      \ --ignore "android/*"
      \ --ignore "node_modules/*"
      \ -g ""'

" so that go-code does not pop up a scratch
set completeopt-=preview
set completeopt+=longest
" Change cursor shape between insert and normal mode in iTerm2.app
if $TERM_PROGRAM =~ "iTerm"
  let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
  let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif
set clipboard=unnamed
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"all faith vim-go
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au BufRead *.md setlocal spell

autocmd BufWritePre *.md :%s/\s\+$//e

let g:jsx_ext_required = 0

"" experimental vimrc for snipmate
let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']

let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
"
""" Tern for js
let g:tern_map_keys=1
set foldmethod=indent
set foldnestmax=5
set nofoldenable
set foldlevel=2
