if exists('b:did_ftplugin')
	finish
endif
let b:did_ftplugin = 1

setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

let b:ale_fix_on_save = 1
let b:ale_fixers = ['prettier', 'trim_whitespace', 'remove_trailing_lines']
