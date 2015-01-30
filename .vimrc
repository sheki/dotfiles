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
Plugin 'zenorocha/dracula-theme'
Plugin 'scrooloose/syntastic'
call vundle#end()            " required

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
"colorscheme solarized 
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"
" " If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"
" " All of your Plugins must be added before the following line

colorscheme solarized 
set background=light
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
nmap <leader>t :CtrlP $HOME/hungry<CR>
nmap <leader>g :CtrlP $HOME/hungry/go/src<CR>
nmap <leader>m :CtrlPMRUFiles<CR>

let g:ctrlp_switch_buffer=1
let g:ctrpl_reuse_window=1
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
" naitik magic
au BufNewFile,BufRead *.go  setlocal makeprg=go\ install\ parse.com/...
" all faith vim-go
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
autocmd BufWritePre *.rb :%s/\s\+$//e
au BufRead *.md setlocal spell

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
au BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"zz" |
  \ endif
augroup END
ab mga Mattieuga
autocmd BufWritePre *.md :%s/\s\+$//e
au BufNewFile,BufRead *.tw set filetype=python

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:syntastic_mode_map = {
  \ "mode": "active",
  \ "active_filetypes": ["ruby", "python"],
  \ "passive_filetypes": ["puppet"] }
