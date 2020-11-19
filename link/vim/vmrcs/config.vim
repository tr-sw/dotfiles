""""""""""""""""""""""""""""""""""""""""""""'
"
" Content:
"   -> General
"   -> Key Mapping
"   -> Colors
"   -> Swap & Backup
"   -> Search
"   -> Completion
"   -> Default Indentation
"   -> Coding (e.g. Templates)
"
"

" ==================================================
" ====> General Config
" ==================================================

" Use   Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

set shell=/bin/bash

set enc=utf-8
set fenc=utf-8
set termencoding=utf-8

set autoindent                     " use indentation of previous line
set number                         "Line numbers are good

set backspace=indent,eol,start     "Allow backspace in insert mode
" set whichwrap+=<,>,h,1             " Tip137 - wrap to next line when pressing these keys

set history=1000                   "Store lots of :cmdline history
set showcmd                        "Show incomplete cmds down the bottom
set showmode                       "Show current mode down the bottom

set autoread                       "Reload files changed outside vim
au FocusGained,BufEnter * checktime

" set gcr=a:blinkon0               "Disable cursor blink
" set visualbell                   "No sounds

set showmatch                      " highlight matching"
set mat=2                          " tenths of seconds to blink"

set ffs=unix,dos,mac

" :W sudo saves to file, for handling permission-denied
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" See: http://items.sjbach.com/319/configuring-vim-right
set hidden

set laststatus=2               "need this to show airline status bar"
set ttimeoutlen=50

" Remember info about open buffers on close
set viminfo^=%

" Enable filetype detection. See cusotmizations in ~/.vim/ftplugin
filetype plugin on
filetype plugin indent on


" ===================================================
" ====> Key Mappings
" ===================================================

let mapleader=","                           "all \x commands turn into ,x

" Smart way to move between windows
:map <C-j> <C-W>j
:map <C-k> <C-W>k
:map <C-h> <C-W>h
:map <C-l> <C-W>l

:nnoremap ,w <C-w>                           " ,ws for split  ,wv for vertical split
:nnoremap ,, <C-w><C-w>                     " ,, for moving between splits

:nmap <F3> :w<CR>                           " save file in Normal mode
:imap <F3> <ESC>:w<CR>i                     " save file in Insert mode

:map <C-z> u                                " Undo
:map <C-c> y                                " Yank
:map <C-v> p                                " Paste

" Remove all trailing whitespace by pressing F5
:nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

:nnoremap <F8> :buffers<CR>:buffer<Space>     " open buffers

" Show buffers
:nmap ; :Buffers<CR>
"Show files & tags
nmap <Leader>f :Files<CR>
nmap <Leader>t :Tags<CR>

" Macors
"   1) start recording using qq
"   2) stop using q
"   3) playback by hitting Space bar:
"
:nnoremap <F12> @q


:map <leader>pp :setlocal paste!<CR>         " toggle paste mode on and off

:nnoremap <C-s> :mksession<CR>               " super save = store full session

:nnoremap <leader>s :mksession<CR>           "super save = strores full session

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>

" ==================================================
" ====> Colors
" ==================================================

" highlight Normal ctermbg=NONE guibg=NONE
" highlight NonText ctermbg=NONE guibg=NONE
syntax enable

" For Python
let python_highlight_all=1

" Maiek vim use 256 colors
set t_Co=256

" Set Color Scheme
colorscheme distinguished
"colorscheme monokai
set background=dark
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
"colorscheme solarized

set colorcolumn=120
highlight ColorColumn ctermbg=lightgray

" See: https://sunaku.github.io/vim-256color-bce.html
" set term=screen-256color
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif


" ================================================
" ====> Swap and Backup
" ================================================

set noswapfile

set backup
if !isdirectory($HOME . "/.vim/files/backup")
  call mkdir($HOME . '/.vim/files/backup', 'p', 0700)
endif
set backupdir  =~/.vim/files/backup
set backupskip =

if !isdirectory($HOME . "/.vim/files/swap")
  call mkdir($HOME . '/.vim/files/swap', 'p', 0700)
endif
set directory  =~/.vim/files/swap,~/tmp

set undofile
if !isdirectory($HOME . "/.vim/files/undo")
  call mkdir($HOME . '/.vim/files/undo', 'p', 0700)
endif
set undodir    =~/.vim/files/undo

set writebackup



" ===================================================
" ====> Search
" ===================================================

" extend search path here
set path=$PWD/**,$CPP_INCLUDE_PATH     " For finding files using dir from which you launched vim"

" bind S to find and open filename under cursor
nnoremap S gf

set incsearch       " search for match as we type
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital



" ===================================================
" ====> Completion
" ===================================================

set wildmenu                       "enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:longest

set wildignore=*.o,*.obj,*~        "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/cache/**
set wildignore+=*.gem
" set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.tgz
set wildignore+=*/.git/*,*.exe


" ===================================================
" ====> Default Indentation
" ===================================================

set autoindent
set smartindent
set smarttab
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch                 " highlight matching braces

set textwidth=120             " wrap lines at 120 chars



" ===================================================
" ====> Coding
" ===================================================

" See ~.vim/ftplugin/<language>.vim for others
"
" python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  with open(activate_this) as f:
    exec(f.read(), {'__file__': activate_this})
EOF

set comments=sl:/*,mb:\ *,elx:\ */        " intelligent comments

augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType gitcommit setlocal spell textwidth=72
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter Makefile.inc setlocal noexpandtab
    autocmd FileType Makefile,yml,py autocmd BufWritePre <buffer> %s/\s\+$//e
augroup END

augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/skeletons/template.sh_file
    autocmd BufNewFile *.bash 0r ~/.vim/skeletons/template.sh_file
    autocmd BufNewFile Makefile 0r ~/.vim/skeletons/template.makefile
    autocmd BufNewFile *.awk 0r ~/.vim/skeletons/template.awk_file
    autocmd BufNewFile *.h 0r ~/.vim/skeletons/template.h_file
augroup END
