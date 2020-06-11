" Pulkit's vimrc
set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

silent! call plug#begin('~/.vim/plugged')

" ------------------------ plugins ------------------------
""" looks
Plug 'sickill/vim-monokai'  "color-theme
Plug 'AlessandroYorba/Sierra'  "color-theme
"Plug 'noahfrederick/vim-hemisu'
"Plug 'ambv/black'
Plug 'itchyny/lightline.vim'  "status-bar
Plug 'jeffkreeftmeijer/vim-numbertoggle'  "line numbers
Plug 'nathanaelkane/vim-indent-guides'  "show indentation

""" moving around
Plug 'matze/vim-move'  "move lines
Plug 'terryma/vim-multiple-cursors'  "sublime like
Plug 'terryma/vim-expand-region'  "select incrementally larger regions

""" window navigation
Plug 'scrooloose/nerdtree'  "file-explorer
Plug 'jistr/vim-nerdtree-tabs'  "nerd-tree addon
"Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }  "file-explorer
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jlanzarotta/bufexplorer'  "recent files
"Plug 'jlanzarotta/bufexplorer'  , { 'on': 'BufExplorer'}  "recent files
Plug 'mhinz/vim-startify'  "startup-page
Plug 'wincent/command-t'  "fuzzy search
Plug 'mhinz/vim-grepper'  "code search

""" programming
Plug 'tpope/vim-fugitive'
"Plug 'valloric/youcompleteme' "code completion
Plug 'SirVer/ultisnips'  "code snippets
Plug 'honza/vim-snippets'  "snippets
Plug 'mhinz/vim-signify'  "show diff
Plug 'vim-syntastic/syntastic'  "syntax checker
"Plug 'tmhedberg/SimpylFold' "Python code folding
Plug 'tpope/vim-surround'  "surround with parathesis
Plug 'FooSoft/vim-argwrap'  "argument wrapping
Plug 'scrooloose/nerdcommenter'  "enhanced commenting
Plug 'lervag/vimtex'  "enhanced latex editing
Plug 'christoomey/vim-sort-motion'  "sorting
Plug 'michaeljsmith/vim-indent-object'  "working with indent
Plug 'tell-k/vim-autopep8'  "autopep8 for python
"Plug 'dbeniamine/cheat.sh-vim'  "cheat-sheet

""" misc
Plug 'vim-scripts/vimwiki'  "for personal vim-notes(,ww)


call plug#end()


" ------------------------ configuration of operations ------------------------
" disable tab character and replace it by 4 spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set ttyfast

set mouse=a " enable mouse scrolling
set title
set showcmd
" disable bell and beep sound
set noerrorbells
" incremental search
set incsearch

" highlight all the matched search
set hlsearch
set ignorecase
set smartcase

set wildmenu
" always split on the right or below
set splitright
set splitbelow
" remove barrier for backspace in some cases
set backspace=indent,eol,start

" fold
"set foldenable " enable folding
"set foldlevelstart=10 " open most folds by default
"set foldnestmax=10 " 10 nested fold max
"set foldmethod=indent " fold based on indent level

" disable swap files
set noswapfile

set number relativenumber  "for vim-numbertoggle
set cursorline  "highlight current line

set colorcolumn=85

set wildmode=list:longest,full
set completeopt=menu,longest,preview
" display incomplete commands
set showcmd
set confirm

" Auto resize windows
autocmd VimResized * wincmd =

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

" set working dir to the dir of current openned file
autocmd BufEnter * silent! lcd %:p:h

"set t_ti=""  "hide vim session buffer on exit

" ------------------------ config keybind remap ------------------------
" set leader
let mapleader=','

" more ways to ESC
inoremap jk <ESC>
inoremap kj <ESC>
"inoremap <C-[> <ESC>

" clipboard settings
set clipboard=unnamed
noremap <leader>y "*y
noremap <leader>p "*p
noremap <leader>Y "+y
noremap <leader>P "+p

" use 0 to get to first char
map 0 ^
" damn Shift key
cmap W w
cmap Q q
cmap q1 q!

" Send chars deleted with 'x' to the black hole
nnoremap x "_x

" reselect the recently pasted text
nnoremap <leader>v V`]
nnoremap / /\v
vnoremap / /\v

" (yaf) to yank a file
onoremap af :<C-u>normal! ggVG<CR>

" <F1> to copy in normal/visual mode
"nmap <F1> :.w !pbcopy<CR><CR>
"vmap <F1> :w !pbcopy<CR><CR>
" <F2> to paste in normal/insert mode
"nmap <F2> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
"imap <F2> <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
"nnoremap <C-p> :call setreg("\"", system("pbpaste"))p

" Get off my lawn
"nnoremap <Left> :echoe "Use h"<CR>
"nnoremap <Right> :echoe "Use l"<CR>
"nnoremap <Up> :echoe "Use k"<CR>
"nnoremap <Down> :echoe "Use j"<CR>

" open editor to shortcut file
nnoremap <leader>ev :vsplit ~/.vimrc<CR>
nnoremap <leader>eb :vsplit ~/.bash_profile<CR>
nnoremap <leader>ea :vsplit ~/.aliases<CR>
nnoremap <leader>ee :vsplit ~/.extra<CR>

" for terminal of vim8
nnoremap th :ter<CR>
nnoremap tv :vert ter<CR>

" (,|) to vsplit
nmap <leader><bar> :vsplit<CR><C-w>l
" merge windws
nnoremap fo :only<CR>

" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

" no highlight
nnoremap <leader><space> :noh<cr>

" tab to move to matching paranthesis
nnoremap <tab> %
vnoremap <tab> %
" tab to autocomplete in insert mode
"inoremap <tab> <c-n>

" Center screen on search results
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz
nnoremap { {zz
nnoremap } }zz
nnoremap g; g;zz
nnoremap g, g,zz

" move between windows, used by vim-move
nnoremap <Left> <C-w>h
nnoremap <Right> <C-w>l
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j

" Move a line of text using ALT+[jk] or Command+[jk] on mac
"nnoremap ∆ :m .+1<CR>==
"nnoremap ˚ :m .-2<CR>==
"inoremap ∆ <Esc>:m .+1<CR>==gi
"inoremap ˚ <Esc>:m .-2<CR>==gi
"vnoremap ∆ :m '>+1<CR>gv=gv
"vnoremap ˚ :m '<-2<CR>gv=gv

"let g:indent_guides_guide_size=1
"let g:indent_guides_enable_on_vim_startup = 1

" Replace tabs with spaces.
nnoremap <leader>rts :%s/	/    /g<CR>

" ------------------------ functions ------------------------
" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    ":%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

noremap <leader>ss :call StripWhitespace()<CR>

" Delete trailing white space on save, useful for some filetypes ;)
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call StripWhitespace()
endif

" ------------------------ config appearance ------------------------
syntax enable

colorscheme monokai
"colorscheme hemisu
"let g:sierra_Midnight = 1
"colorscheme sierra

" ------------------------ configuration of plugins------------------------
"  [nerdtree]
" open NERDTree (tr)
map tr :NERDTreeToggle<CR>
"map <leader>nn :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right" " open on right
let g:NERDTreeWinSize = 50
"let NERDTreeMapOpenInTab='<ENTER>' " open new tab on Enter
"
" open a NERDTree automatically when vim starts up if no files were specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" open NERDTree automatically when vim starts up on opening a directory
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if the only window left open is a NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

"  [vim-nerdtree-tabs]
let g:nerdtree_tabs_open_on_gui_startup = 0

"  [ultisnips]
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsEnableSnipMate='no'
let g:UltiSnipsSnippetDirectories=[$HOME . '/.vim/snippets']

"  [vim-sort-motion]
let g:sort_motion_flags = 'u' " Remove duplicates while sorting.

"  [syntastic]
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_python_checkers=['python']
"let g:syntastic_mode_map = {'mode': 'passive'}  "off by default
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs=1
let g:syntastic_enable_highlighting = 0

"  [bufferexplorer]
nnoremap tt :BufExplorer<CR>

"  [vim-move]
let g:move_key_modifier = 'C'

"  [vim-argwrap]
nnoremap <silent> <leader>a :ArgWrap<CR>

"  [vim-grepper]
nnoremap <Leader>/ :Grepper<CR>
nnoremap <Leader>* :Grepper -cword -noprompt<CR>

"  [vim-autopep8]
let g:autopep8_max_line_length=150
let g:autopep8_ignore="E731"
let g:autopep8_diff_type='vertical'
"let g:autopep8_on_save = 1

"  [lightline]
set laststatus=2
set noshowmode  "lightline already shows mode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }
" add branch name in statusline
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head'
            \ },
            \ }

