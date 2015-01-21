set nocompatible

set runtimepath+=/opt/local/share/vim/vimfiles

syntax on             " Enable syntax highlighting
filetype on           " Enable fieltype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set encoding=utf-8
set hlsearch
set background=dark

set modeline modelines=5
set expandtab noautoindent tabstop=2 shiftwidth=2
set list listchars=tab:>\ ,trail:_

set laststatus=2
set statusline=%y%{'['.(&fenc!=''?&fenc:'?').'-'.&ff.']'}

set paste " to make paste work as expected

let g:netrw_liststyle=3
let g:netrw_list_hide='.svn,.git'
let g:netrw_altv=1
let g:netrw_alto=1
