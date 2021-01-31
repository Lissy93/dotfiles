scriptencoding utf-8

" Copyright 2018-2020 @ kornicameister

" define the plugins
call plug#begin('~/.vim/plugged')

" vim compatibility
if !has('nvim')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" theme
Plug 'dracula/vim', { 'as': 'dracula' }

" fzf
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

" git plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'octref/rootignore'
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-git'

" ale plugin
Plug 'vim-scripts/dbext.vim', { 'for': ['sql'] }
Plug 'dense-analysis/ale'
Plug 'da-x/depree', { 'do': './rebuild.sh' }

" deoplete
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim', { 'do': '!pip install --user --upgrade neovim' }
endif

Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/neco-vim', { 'for': ['vim', 'viminfo'] }
Plug 'deoplete-plugins/deoplete-jedi', { 'for': ['python'] }
Plug 'deoplete-plugins/deoplete-tag'
Plug 'deoplete-plugins/deoplete-docker'
Plug 'deoplete-plugins/deoplete-zsh', { 'for': ['zsh'] }

" asynchronous execution library
Plug 'Shougo/vimproc.vim', { 'do' : 'make' }

" general editor related plugins
Plug 'luochen1990/rainbow'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'psliwka/vim-smoothie'

" javascript & typescript plugins
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'mxw/vim-jsx', { 'for' : ['jsx'] }
Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript'] }

" docker
Plug 'ekalinin/Dockerfile.vim', { 'for': ['dockerfile', 'docker-compose', 'Dockerfile'], 'do': 'make install' }

" elm
" per recommendation at: https://github.com/elm-tooling/elm-vim/blob/master/README.md
Plug 'andys8/vim-elm-syntax', {'for': ['elm']}

" python
Plug 'tmhedberg/SimpylFold', {'for': ['python']}
Plug 'lambdalisue/vim-pyenv', {'for': ['python']}
Plug 'vim-scripts/indentpython.vim', {'for': ['python']}
Plug 'raimon49/requirements.txt.vim', {'for': ['requirements']}
if has('nvim')
    Plug 'kalekseev/vim-coverage.py', { 'do': ':UpdateRemotePlugins', 'for': ['python'] }
    Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'kalekseev/vim-coverage.py', { 'do': '!pip install --user --upgrade neovim', 'for': ['python']}
endif

" go
Plug 'arp242/gopher.vim', { 'for': ['go'] }
Plug 'deoplete-plugins/deoplete-go', { 'for': ['go'], 'do': 'make' }

" json
Plug 'elzr/vim-json', {'for': ['json']}

" markdown
Plug 'gabrielelana/vim-markdown', {'for': ['markdown']}
Plug 'mzlogin/vim-markdown-toc', {'for': ['markdown']}

" tex
Plug 'lervag/vimtex', { 'for': ['tex'] }

" various
Plug 'wakatime/vim-wakatime'                        " track what I am doing when using vim
Plug 'ryanoasis/vim-devicons'                       " cool icons
Plug 'haya14busa/incsearch.vim'                     " incremental searching
Plug 'ap/vim-css-color'                             " colors for colors
Plug 'farmergreg/vim-lastplace'                     " open editor where it was
Plug 'zinit-zsh/zinit-vim-syntax'                   " zinit power
Plug 'mustache/vim-mustache-handlebars'
Plug 'triglav/vim-visual-increment'

" nginx
Plug 'chr4/nginx.vim'

" tags
Plug 'majutsushi/tagbar'                            " visiting tags as pro
Plug 'ludovicchabant/vim-gutentags'

" testing made fun
Plug 'janko/vim-test'

call plug#end()

" Plugin Customizations
" =====================

augroup vim_test_settings
  autocmd!
  let g:test#strategy = 'neovim'
  let g:test#neovim#term_position = 'vertical'

  " integrate with coverage tool
  let g:test#python#pytest#options = '--cov-branch --cov-context=test'

  " disable vim-projectionist
  let g:test#no_alternate = 1

  nmap <silent> <C-t>n :TestNearest<CR>
  nmap <silent> <C-t>f :TestFile<CR>
  nmap <silent> <C-t>s :TestSuite<CR>
  nmap <silent> <C-t>l :TestLast<CR>
  nmap <silent> <C-t>v :TestVisit<CR>

augroup end

augroup tagbar_plugin_settins
    autocmd!
    let g:tagbar_ctags_bin='ctags'
    let g:tagbar_iconchars = ['►', '▼']
    let g:tagbar_autoclose = 1

    let g:tagbar_type_markdown = {
        \ 'ctagstype' : 'markdown',
        \ 'kinds' : [
            \ 'h:headings',
            \ 'l:links',
            \ 'i:images'
        \ ],
    \ }
    let g:tagbar_type_sh = {
        \ 'ctagstype' : 'sh',
        \ 'kinds' : [
            \ 'f:functions',
            \ 'v:variables',
        \ ],
    \ }
    let g:tagbar_type_elm = {
        \ 'ctagstype' : 'elm',
        \ 'kinds'     : [
            \ 'm:module',
            \ 'i:imports',
            \ 't:types',
            \ 'C:constructors',
            \ 'c:constants',
            \ 'f:functions',
            \ 'p:ports'
        \ ],
    \ }
    let g:tagbar_type_ansible = {
        \ 'ctagstype' : 'ansible',
        \ 'kinds' : [
          \ 't:tasks'
        \ ],
    \ }

    nmap <F8> :TagbarToggle<CR>
augroup END

" always color brackets
let g:rainbow_active = 1

if has_key(g:plugs, 'vim-airline')
  augroup airline_plugin_settings
    autocmd!

    let g:airline_powerline_fonts = 1
    let g:airline_left_sep='›'          " Slightly fancier than '>'
    let g:airline_right_sep='‹'         " Slightly fancier than '<'

    let g:airline#extensions#ale#enabled = 1

    let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep=' '
    let g:airline#extensions#tabline#left_alt_sep=' '
    let g:airline#extensions#tabline#buffer_nr_format = '%s '
    let g:airline#extensions#tabline#buffer_nr_show = 1
  augroup END
endif

augroup elm_plugin_settings
  autocmd!
  let g:elm_setup_keybindings = 0
  let g:elm_format_autosave = 0
augroup END

" commit msg - very nerdy
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Scroll the diff window from insert mode
    " Map <C-n> and <C-p>
    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction

" python
let python_highlight_all = 1
let g:pyenv#auto_create_ctags = 1
let g:pyenv#auto_assign_ctags = 1

" gutter
augroup gitgutter_options
    autocmd!
    let g:gitgutter_diff_args = '-w'    " ignore whitespace changes
    let g:gitgutter_sign_added = ''

    let g:gitgutter_sign_modified = ''
    let g:gitgutter_sign_modified_removed = ''

    let g:gitgutter_sign_removed = ''
    let g:gitgutter_sign_removed_first_line = ''

    let g:gitgutter_highlight_linenrs = 1

    nmap <A-,> <Plug>(GitGutterUndoHunk)
    nmap <A-.> <Plug>(GitGutterStageHunk)
    nmap <A-/> <Plug>(GitGutterPreviewHunk)
augroup END

augroup incremental_search_options
    autocmd!

    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)

    " automatically turn off hlsearch
    set hlsearch
    let g:incsearch#auto_nohlsearch = 1

    " and deal in some mappings
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
    map *  <Plug>(incsearch-nohl-*)
    map #  <Plug>(incsearch-nohl-#)
    map g* <Plug>(incsearch-nohl-g*)
    map g# <Plug>(incsearch-nohl-g#)

    " do not persist search end
    let g:incsearch#do_not_save_error_message_history = 1

    " different highlight colors
    let g:incsearch#separate_highlight = 1

augroup END

augroup gutentags_options
  autocmd!
  let g:gutentags_ctags_tagfile = '.git/tags'
  let g:gutentags_file_list_command = {
    \ 'markers': {
      \ '.git': 'git grep --cached -I -l -e $""',
    \ },
  \ }
augroup END

augroup vim_go_options
    autocmd!
    let g:gopher_highlight = ['string-spell', 'string-fmt']
    let g:gometalinter_fast = ''
          \ . ' --enable=vet'
          \ . ' --enable=errcheck'
          \ . ' --enable=ineffassign'
          \ . ' --enable=goimports'
          \ . ' --enable=misspell'
          \ . ' --enable=lll --line-length=120'
    let g:ale_go_gometalinter_options = '--disable-all --tests' . g:gometalinter_fast . ' --enable=golint'
augroup END

" deoplete settings
if has_key(g:plugs, 'deoplete.nvim')
  augroup deoplete_options
      autocmd!

      let g:deoplete#enable_at_startup = 1
      let g:deoplete#enable_fefresh_always = 1

      call deoplete#custom#var('omni', 'input_patterns', {})
      call deoplete#custom#option({
          \ 'auto_complete_delay': 50,
          \ 'smart_case': v:true,
          \ 'max_list': 50,
          \ })

      let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
      let g:deoplete#sources#go#source_importer = 0      " that one is deprecated
      let g:deoplete#sources#go#builtin_objects = 1      " might be useful
      let g:deoplete#sources#go#sort_class = [
            \ 'package',
            \ 'func',
            \ 'type',
            \ 'var',
            \ 'const'
      \]                                                  " sorting matters
      let g:deoplete#sources#go#pointer = 1               " Enable completing of go pointers
      let g:deoplete#sources#go#unimported_packages = 1   " autocomplete unimported packages
  augroup END
endif

if has_key(g:plugs, 'fzf.vim')
  augroup fzf_settings
    autocmd!

    " fzf mappings
    nmap <Leader>t  :Tags<CR>
    nmap <Leader>bt :BTags<CR>
    nmap <Leader>f  :GFiles<CR>
    nmap <Leader>F  :Files<CR>
    nmap <Leader>c  :Commits<CR>
    nmap <Leader>b  :Buffers<CR>
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)

    " floating window
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
  augroup END

  " ale settings
  augroup ale_plugin_settings
    autocmd!

    let g:ale_fix_on_save = 1                   " run on save
    let g:ale_lint_on_save  = 1                 " 2 options allow to lint only when file is saved
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_enter = 1                 " lint when entering the buffer
    let g:ale_completion_enabled = 0            " do not mix up stuff with deoplete
    let g:ale_sign_error = '✖'                  " error sign
    let g:ale_sign_warning = '⚠'                " warning sign
    let g:ale_fixers = ['trim_whitespace', 'remove_trailing_lines']

    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

    let g:ale_set_balloons = 1

    nmap <A-f> <Plug>(ale_fix)<CR>
    nmap <A-l> <Plug>(ale_lint)<CR>
    nmap <A-d> <Plug>(ale_detail)<CR>
    nmap <A-k> <Plug>(ale_previous_wrap)
    nmap <A-j> <Plug>(ale_next_wrap)

    nmap <F3> <Plug>(ale_hover)
    nmap <F4> <Plug>(ale_go_to_definition)

    if has('nvim')
      autocmd VimEnter *
        \ set updatetime=1000 |
        \ let g:ale_lint_on_text_changed = 0
      autocmd CursorHold * call ale#Queue(0)
      autocmd CursorHoldI * call ale#Queue(0)
      autocmd InsertEnter * call ale#Queue(0)
      autocmd InsertLeave * call ale#Queue(0)
    else
      echoerr 'only neovim can handle kornicameister dotfiles'
    endif
  augroup END
endif

