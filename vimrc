silent! call plug#begin('~/.vim/plugged')

Plug 'sbdchd/neoformat'

" https://devhints.io/tabular
Plug 'godlygeek/tabular'

Plug 'cespare/vim-toml'

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-fugitive'

call plug#end()

" :Neoformat
let g:neoformat_sql_sqlformat = {
		\ 'exe': 'sqlformat',
		\ 'args': ['--reindent', '--keywords', 'upper', '-'],
		\ 'stdin': 1,
		\ }
let g:neoformat_enabled_sql = ['sqlformat']

let g:neoformat_python_black = {
		\ 'exe': 'black',
		\ 'stdin': 1,
		\ 'args': ['--line-length', '128', '--quiet', '-'],
		\ }
let g:neoformat_python_isort = {
		\ 'exe': 'isort',
		\ 'args': ['-', '--quiet', '--line-length', '128'],
		\ 'stdin': 1,
		\ }
let g:neoformat_enabled_python = ['black', 'isort']

let g:neoformat_enabled_sh = ['shfmt']

let g:neoformat_run_all_formatters = 1
let g:neoformat_verbose = 0

set textwidth=128

augroup auto_filetype
  autocmd!
  autocmd BufRead,BufNewFile gitconfig  set filetype=gitconfig
  autocmd BufRead,BufNewFile *.gradle   set filetype=groovy
  autocmd BufRead,BufNewFile *.sc       set filetype=scala
  autocmd BufRead,BufNewFile *Pipfile*  set filetype=toml
  autocmd BufRead,BufNewFile *.py       set foldmethod=indent foldlevel=1 expandtab
  autocmd BufRead,BufNewFile *.vim      set foldmethod=indent foldlevel=1 expandtab
  autocmd BufRead,BufNewFile Makefile*,*.mk  setlocal listchars=tab:→\ ,trail:·,extends:↷,precedes:↶ filetype=make tabstop=8 noexpandtab list
augroup end
