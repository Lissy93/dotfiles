scriptencoding utf-8

set fileformats=unix,dos,mac

augroup git_ft_config
  au!
  au BufNewFile,BufRead gitconfig setlocal ft=gitconfig nolist nospell ts=4 sw=4 noet
  au BufNewFile,BufRead .gitconfig* setlocal ft=gitconfig nolist nospell ts=4 sw=4 noet
  au FileType gitcommit setlocal nospell
augroup END

augroup js_ft_settings
  au!
  au BufRead,BufNewFile *.js,*.jsx set et ai ts=4 sts=4 sw=4 tw=79
  au BufRead,BufNewFile *.js,*.jsx match BadWhitespace /^\t\+/
  au BufRead,BufNewFile *.js,*.jsx match BadWhitespace /\s\+$/
  au         BufNewFile *.js,*.jsx set fileformat=unix
  au BufRead,BufNewFile *.js,*.jsx let b:comment_leader = '//'
augroup END

augroup sh_ft_settings
  au!
  au BufNewFile,BufRead *.sh setlocal ai et ts=2 sw=2 sts=2
augroup END

augroup vim_ft_settings
  au!
  au BufNewFile,BufRead *.vim setlocal ai et ts=2 sw=2 sts=2
augroup END

augroup text_ft_settings
  au!
  au BufNewFile,BufRead *.txt setlocal et ts=4 sw=4
augroup END

augroup cpp_ft_settings
  au!
  au BufNewFile,BufRead *.cpp setlocal et ts=2 sw=2
  au BufNewFile,BufRead *.hpp setlocal et ts=2 sw=2
augroup END

augroup json_ft_settings
  au!
  au FileType json setlocal foldmethod=syntax
  au BufNewFile,BufRead *.json setlocal et ts=2 sw=2
augroup END

augroup asciidoc_ft_settings
  au!
  au FileType asciidoc setlocal spell
augroup END
