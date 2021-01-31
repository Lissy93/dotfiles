scriptencoding utf-8

" Copyright 2018-2020 @ kornicameister

" save from typing :
nnoremap ; :

" general settings for editor
syntax on

set smartindent
set noerrorbells
set novisualbell
set timeoutlen=500

" searching stuff
nnoremap n nzzzv                            " center line on next search
nnoremap N Nzzzv                            " -----------//------------

" no temp or backup files
set noswapfile
set nobackup
set nowritebackup

set nowrap              " do not wrap lines

" tabs settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

" indentation settings
set autoindent
set copyindent

" disable modelines
set modelines=0
set nomodeline

" set title
set title

" make searching smart
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor\ --vimgrep
  set grepformat^=%f:%l:%c:%m
endif
set ignorecase
set smartcase

" Make the keyboard fast
set ttyfast
set timeout timeoutlen=1000 ttimeoutlen=50

" backspace fix
set backspace=indent,eol,start

" wrap movement
set whichwrap+=<,>,h,l,[,]

" Show linenumbers
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
set ruler

" make whitespaces, tabs visible
set list
set listchars-=nbsp:+
set listchars-=trail-
set listchars+=trail:•,nbsp:~,eol:↵
highlight BadWhitespace ctermbg=red guibg=red

" always display status line
set laststatus=2
set cmdheight=1

" enable filetypes plugins
filetype plugin indent on

" spelling
setlocal nospell
map <silent> <leader>ss :setlocal spell!<cr>
hi SpellBad cterm=underline,bold ctermfg=red

" tabs keybindings
map <C-t><up> :tabr<cr>
map <C-t><down> :tabl<cr>
map <C-left> :tabp<cr>
map <C-right> :tabn<cr>

" splitting windows settings
set splitbelow
set splitright

" quicker navigation
nnoremap <silent> <C-J> <C-W><C-J>
nnoremap <silent> <C-K> <C-W><C-K>
nnoremap <silent> <C-L> <C-W><C-L>
nnoremap <silent> <C-H> <C-W><C-H>
" quicker resizing with arrows
nnoremap <silent> <C-Left> :vertical resize +2<CR>
nnoremap <silent> <C-Right> :vertical resize -2<CR>
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <Space> za
vnoremap <Space> za

" quickly edit/reload vimrc
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" do not close the buffer, hide them to preserve
" markers, undo etc
set hidden

set history=1000                      " increase history size
set undolevels=1000                   " ----------//---------

" in case we forgot sudo
cmap w!! w !sudo tee % >/dev/null

" normal OS clipboard interaction
set clipboard+=unnamedplus

" wilderness
set wildignore+=*.BACKUP.*,*.BASE.*,*.LOCAL.*,*.REMOTE.*
set wildignore+=/tmp/**
set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.log,*.pyc,*.sqlite,*.sqlite3,*.min.js,*.min.css,*.tags
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.pdf,*.dmg,*.app,*.ipa,*.apk,*.mobi,*.epub
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.doc,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*/.git/*,*/.svn/*,*.DS_Store
set wildignore+=*/node_modules/*,*/nginx_runtime/*,*/build/*,*/logs/*,*/dist/*,*/tmp/*
set wildignore+=*/elm-stuff/*
set wildignore+=*/.aws-sam/*

set wildmode=longest:full,full
set wildmenu

" netrw (file browser)
let g:netrw_banner=0                              " disable annoying banner
let g:netrw_browse_split=4                        " open in prior window
let g:netrw_altv=1                                " open splits to the right
let g:netrw_liststyle=3                           " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" navigate through the buffers
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>
nnoremap <silent> <leader>q :bd<cr>gT
nnoremap <silent> <leader>Q :bufdo bd<CR>
nnoremap <silent> <leader>r :e<CR>
nnoremap <silent> <leader>R :e!<CR>

augroup save_on_focus_out
  autocmd!
  au FocusLost * :wa
  set autoread
augroup END

augroup help_vertical
  au!
  command! -nargs=* -complete=help Help vertical belowright help <args>
  autocmd FileType help wincmd L
augroup END

augroup colorscheme_customization
  au!

  if has('termguicolors')
    set termguicolors
  endif

  if has_key(g:plugs, 'dracula')
    let g:dracula_bold = 1
    let g:dracula_italic = 1
    let g:dracula_colorterm = 0

    set background=dark
    colorscheme dracula

    if has_key(g:plugs, 'vim-airline')
      let g:airline_theme = 'dracula'
      call airline#load_theme() | call airline#update_statusline()
    endif

  endif

augroup END
