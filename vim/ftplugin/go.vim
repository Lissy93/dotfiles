if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

let b:ale_linters = ['go build', 'gometalinter', 'gopls']
let b:ale_fixers = ['gofmt', 'goimports', 'trim_whitespace']

setlocal noexpandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4

setlocal nolisp
setlocal autoindent

setlocal nospell

set makeprg=go " point :make to go binary
