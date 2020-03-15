
if has("autocmd")
augroup autoinsert
  au!
  autocmd BufNewFile *.sh call s:Template("sh")
  autocmd BufNewFile *.gawk call s:Template("gawk")
  autocmd BufNewFile *.awk call s:Template("awk")
  autocmd BufNewFile *.c call s:Template("c")
  autocmd BufNewFile *.h call s:Template("h")
  autocmd BufNewFile Makefile call s:Template("make")
augroup END
endif

function s:Template(argument)
        if (a:argument == "help")
                echo "Currently available templates:"
                echo " sh               - Plain bash Template"
                echo " gawk             - Plain gawk Template"
                echo " awk              - Plain awk Template"
                echo " sh               - Plain bash Template"
                echo " c                - Plain C Template"
                echo " h                - Plain H Template"
                echo " make             - Makefile Template"
        else
                " First delete all in the current buffer
                %d
 
                " The Makefile variants
                if (a:argument == "make")
                        0r ~/.vim/skeletons/template.make
                        set ft=make

                elseif (a:argument == "make-simple-cpp")
                        0r ~/.vim/skeletons/template.make_simple_cpp
                        set ft=make
                        "
                " Stuff for bash 
                elseif (a:argument == "sh")
                        0r ~/.vim/skeletons/template.sh_file
                        set ft=sh

                " Stuff for gawk 
                elseif (a:argument == "gawk")
                        0r ~/.vim/skeletons/template.gawk_file
                        set ft=gawk

                " Stuff for awk 
                elseif (a:argument == "awk")
                        0r ~/.vim/skeletons/template.awk_file
                        set ft=awk

                " Stuff for plain C
                elseif (a:argument == "c")
                        0r ~/.vim/skeletons/template.c_file
                        set ft=c

                elseif (a:argument == "h")
                        0r ~/.vim/skeletons/template.h_file
                        set ft=c
                endif

                silent %!~/.vim/do_header %
        endif
endfunction

command! -nargs=1 Template call s:Template()
