set nocompatible

syntax on             " Enable syntax highlighting
filetype on           " Enable fieltype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set encoding=utf-8
set hlsearch
set ambiwidth=double

set modeline modelines=5
set expandtab noautoindent tabstop=2 shiftwidth=2
set list listchars=tab:>\ ,trail:_

set laststatus=2
set statusline=%y%{'['.(&fenc!=''?&fenc:'?').'-'.&ff.']'}

set paste " to make paste work as expected

set noswapfile nobackup viminfo=
