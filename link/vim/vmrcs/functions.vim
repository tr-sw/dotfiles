"""""""""""""""""""""""""""""""""""""""""""
"
"  Functions
"

function! <SID>StripTrailingWhitespace()
  normal mZ
  let l:chars = col("$")
  %s/\s\+$//e
  if (line("'Z") != line(".")) || (l:chars != col("$"))
      echo "Trailing whitespace stripped\n"
  endif
  normal `Z
endfunction



