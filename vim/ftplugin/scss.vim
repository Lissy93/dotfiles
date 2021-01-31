if exists('b:did_ftplugin')
	finish
endif
let b:did_ftplugin = 1

setlocal autoindent
setlocal expandtab
setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2

" ale fixer settings
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'prettier']
