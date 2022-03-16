
" Get version of Vim running
if has('nvim') | let vim_type='nvim' | else | let vim_type='vim' | endif

let vim_rc=$XDG_CONFIG_HOME.'/vim/vimrc'

" Location of vim plug script
let vim_plug_location=$XDG_DATA_HOME."/".vim_type."/autoload/plug.vim"

" If vim-plug not present, install it now
if !filereadable(expand(vim_plug_location))
  echom "Vim Plug not found, downloading to '" . vim_plug_location . "'"
  execute '!curl -o ' . vim_plug_location . ' --create-dirs' .
  \ ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | exec 'source ' . vim_rc
  \| endif

