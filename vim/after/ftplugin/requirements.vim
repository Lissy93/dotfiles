fu! s:InstallRequirements()
  silent !clear
  execute '!' . 'pip install -r ' . bufname('%')
endfu

:command! -bar InstallRequirements :call s:InstallRequirements()
