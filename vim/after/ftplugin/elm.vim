setlocal foldmethod=syntax
setlocal nospell

let b:ale_linters = ['elm_ls']
let b:ale_fixers = ['trim_whitespace', 'remove_trailing_lines', 'elm-format']
let b:ale_linters_ignore = { 'elm': ['make'] }

" autocompleting ought to be provided via elm-language-server
" also when coding elm there's an error from deoplete telling
" that elm-oracle is not available
" but then again elm-oracle does not work with 0.19
" issue <| https://github.com/pbogut/deoplete-elm/issues/3
let b:deoplete_disable_auto_complete = 1
let b:ale_completion_enabled = 1
