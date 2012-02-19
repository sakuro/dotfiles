set nocompatible

set runtimepath+=/opt/local/share/vim/vimfiles

syntax on             " Enable syntax highlighting
filetype on           " Enable fieltype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set encoding=utf-8
set hlsearch
set background=dark
colorscheme solarized

set modeline modelines=5
set expandtab noautoindent tabstop=2 shiftwidth=2
set list listchars=tab:>\ ,trail:_

set laststatus=2
set statusline=%y%{'['.(&fenc!=''?&fenc:'?').'-'.&ff.']'}

set paste " to make paste work as expected

highlight! fullwidth_whitespace ctermbg=grey ctermfg=grey guibg=black
match fullwidth_whitespace /　/

augroup filetypedetect
  au! BufRead,BufNewFile Gemfile setfiletype ruby
  au! BufRead,BufNewFile Guardfile setfiletype ruby
  au! BufRead,BufNewFile Thorfile setfiletype ruby
  au! BufRead,BufNewFile config.ru setfiletype ruby
  au! BufRead,BufNewFile *.thor setfiletype ruby
augroup END
