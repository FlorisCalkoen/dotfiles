" add line numbers
set number

" add shell syntax to symlink file extensions 
" autocmd BufNewFile,BufRead *.symlink set syntax=sh 
" au! BufRead,BufNewFile *.symlink setfiletype sh set
augroup symlink_ft
  au!
  autocmd BufNewFile,BufRead *.symlink set syntax=sh
augroup END
