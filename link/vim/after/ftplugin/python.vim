""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" See Vim Tip 1546: 
" https://vim.fandom.com/wiki/Automatically_add_Python_paths_to_Vim_path
"
" This allows you to use gf or Ctrl-W Ctrl-F to open the file under the cursor. 
" It works pretty well. particularly for imports of the form:
"
"      import abc.def.module
"
" But not so well with: 
"
"      from abc.def import module"
"

python << EOF
import os
import sys
import vim
for p in sys.path:
    # Add each directory in sys.path, if it exists.
    if os.path.isdir(p):
        # Command 'set' needs backslash before each space.
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
