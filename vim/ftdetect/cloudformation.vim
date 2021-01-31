augroup cfn
  au BufRead,BufNewFile template.yml set filetype=yaml.cloudformation
  au BufRead,BufNewFile *.template.yml set filetype=yaml.cloudformation
augroup END
