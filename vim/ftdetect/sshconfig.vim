augroup sshconfig_ft
  au BufNewFile,BufRead *ssh/config            setfiletype sshconfig
  au BufNewFile,BufRead *ssh/config.d/*.config setfiletype sshconfig
augroup END
