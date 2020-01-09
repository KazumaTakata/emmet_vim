



"silent !ls
"redraw!

fun! Runcmd(cmd)
    silent! exe "noautocmd botright pedit ".a:cmd
    noautocmd wincmd P
    set buftype=nofile
    exe "noautocmd r! ".a:cmd
    noautocmd wincmd p
endfun

command! -nargs=1 Runcmd call Runcmd("<args>")
