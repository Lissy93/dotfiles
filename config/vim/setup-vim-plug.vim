""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets up all Vim / Neovim Plugins via Vim Plug                      "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Installs and imports Vim Plug, updates and loads listed plugins    "
" For more info, see docs at: https://github.com/lissy93/dotfiles    "
" Licensed under MIT (C) Alicia Sykes 2022 <https://aliciasykes.com> "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set paths for plug.vim and directory for plugins
if has('nvim')
  let vim_plug_location=$XDG_DATA_HOME."/nvim/autoload/plug.vim"
  let vim_plug_plugins_dir = $XDG_DATA_HOME."/nvim/plugins"
else
  let vim_plug_location=$HOME.'/.vim/autoload/plug.vim'
  let vim_plug_plugins_dir = $XDG_DATA_HOME."/vim/plugins"
endif

" If vim-plug not present, install it now
if !filereadable(expand(vim_plug_location))
  echom "Vim Plug not found, downloading to '" . vim_plug_location . "'"
  execute '!curl -o ' . vim_plug_location . ' --create-dirs' .
  \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  echom "Next, run :PlugInstall to install all plugins"
endif

" If Plugins directory not yet exist, create it
if empty(vim_plug_plugins_dir)
  call mkdir(vim_plug_plugins_dir, 'p')
endif

" Initialize Vim Plugged
call plug#begin(vim_plug_plugins_dir)
  " Light-weight status line
  Plug 'vim-airline/vim-airline'
  " A tree explorer plugin for vim
  Plug 'preservim/nerdtree'
  " Highlight, navigate, and operate on sets of matching text
  Plug 'andymass/vim-matchup'
  " Displays and browse tags in a file
  Plug 'preservim/tagbar'
  " Fuzzy-file finder in vim
  Plug 'junegunn/fzf'
  " Smoothe scrolling
  Plug 'psliwka/vim-smoothie'
  " File icons for most languages
  Plug 'ryanoasis/vim-devicons'
  " Easy comments in most languages
  Plug 'preservim/nerdcommenter'
  " Check syntax in real-time
  Plug 'dense-analysis/ale'
  " Surround selected text with brackets, quotes, tags etc
  Plug 'tpope/vim-surround'
  " Better incremenal searching
  Plug 'haya14busa/incsearch.vim'
  " Multi-cursor support
  Plug 'mg979/vim-visual-multi'
  " Easily generate number/ letter sequences
  Plug 'triglav/vim-visual-increment'
  " Wraper for running tests
  Plug 'janko/vim-test'
call plug#end()
  