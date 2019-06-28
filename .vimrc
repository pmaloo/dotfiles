set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'vim-syntastic/syntastic'
Plug 'nathanaelkane/vim-indent-guides'
"Plug 'noahfrederick/vim-hemisu'
Plug 'sickill/vim-monokai'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'lervag/vimtex'
Plug 'AlessandroYorba/Sierra'
Plug 'tpope/vim-fugitive'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
"Plug 'ambv/black'
call plug#end()

syntax enable

"colorscheme hemisu
colorscheme monokai
"let g:sierra_Midnight = 1
"colorscheme sierra 

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

"set relativenumber
set number relativenumber
set cursorline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

set title
set showmode
set showcmd
set noerrorbells
set incsearch
set hlsearch
set wildmenu
set splitright
set splitbelow
set clipboard=unnamed

let mapleader=','
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_python_checkers=['python']
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"let g:indent_guides_guide_size=1
"let g:indent_guides_enable_on_vim_startup = 1
" Auto resize windows
autocmd VimResized * wincmd =

inoremap jk <ESC>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" <F1> to paste in normal/insert mode
nmap <F1> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <F1> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
" <F2> to copy in normal/visual mode
nmap <F2> :.w !pbcopy<CR><CR>
vmap <F2> :w !pbcopy<CR><CR>

" Force not to use big W.
cmap W w

set wildmode=list:longest,full
set completeopt=menu,longest,preview
set showcmd

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

