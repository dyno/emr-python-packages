silent! call plug#begin('~/.vim/plugged')

Plug 'sbdchd/neoformat'

" https://devhints.io/tabular
Plug 'godlygeek/tabular'

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
		\ 'args': ['--line-length', '120', '--quiet', '-'],
		\ }
let g:neoformat_enabled_python = ['black', 'isort']

let g:neoformat_enabled_sh = ['shfmt']

let g:neoformat_run_all_formatters = 1
let g:neoformat_verbose = 0
