if exists('b:did_ftplugin')
	finish
endif
let b:did_ftplugin = 1

setlocal expandtab
setlocal autoindent
setlocal smartindent
setlocal textwidth=79
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal fileformat=unix

set backspace=indent,eol,start

match BadWhitespace /^\t\+/
match BadWhitespace /\s\+$/

let b:comment_leader = '#'
let b:ale_fix_on_save = 0

let b:ale_linters = ['mypy', 'flake8']
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines']

if isdirectory($VIRTUAL_ENV)
  let s:yapf_bin = expand($VIRTUAL_ENV.'/bin/yapf')
  let s:black_bin = expand($VIRTUAL_ENV.'/bin/black')
  if executable(s:black_bin)
    call add(b:ale_fixers, 'black')
  elseif executable(s:yapf_bin)
    call add(b:ale_fixers, 'yapf')
  endif
elseif executable('yapf')
  call add(b:ale_fixers, 'yapf')
elseif executable('black')
  call add(b:ale_fixers, 'black')
endif

" if enabled, it makes flake8 loose its configuration file in project root
let b:ale_python_flake8_change_directory = 0

" always load pyls from neovim3 virtualenv :)
let b:ale_python_pyls_executable = expand(fnamemodify(g:python3_host_prog, ':h') . '/' . 'pyls')
if executable(b:ale_python_pyls_executable)

  call add(b:ale_linters, 'pyls')

  let b:ale_python_pyls_config = {
  \ 'pyls': {
  \   'plugins': {
  \     'flake8': {'enabled': v:true},
  \     'mypy': {'enabled': v:true},
  \     'yapf': {'enabled': v:true},
  \     'pyflakes': {'enabled': v:false},
  \     'pycodestyle': {'enabled': v:false},
  \     'jedi': {'enabled': v:true},
  \     'rope': {'enabled': v:true},
  \     'jedi_definition': {
  \       'follow_imports': v:true,
  \       'follow_builtin_imports': v:true,
  \     },
  \   }
  \ }}

endif

