"""""""""""""""""""""""""""""""""""""""""""""""
"
" Configuration for following plugins:
"
"   -> Ack
"   -> Airline-Themes 
"   -> Airline 
"   -> Ansible 
"   -> CtrlP 
"   -> Fzf 
"   -> Fugitive 
"   -> GitGutter 
"   -> Golang
"   -> NerdTree 
"   -> Surround 
"   -> Syntastic 
"
" This one is loaded differently (require build)
"   -> YouCompleteMe 
"
"
"


"==============================================
" => Ack
"==============================================

if executable('ag')   " need to install silversearcher-ag via apt-get (ubuntu) or yum (centos)
  let g:ackprg = 'ag --vimgrep'
endif

" use with bang to avoid default behavior = jump to first result automatically
cnoreabbrev Ack Ack!         
nnoremap <C-a> :Ack!<Space>
nnoremap \ :Ack!<Space>



"==============================================
" => Airline-Themes
"==============================================

" See themes here: https://github.com/vim-airline/vim-airline/wiki/Screenshots 

let g:airline_theme = 'solarized'
let g:airline_theme = 'molokai'
let g:airline_theme = 'base16'
let g:airline_theme = 'minimalist'



"==============================================
" => Airline
"==============================================

" enable fugitive integration
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#branch#displayed_head_limit = 10

" to only show the tail, e.g. a branch 'feature/foo' becomes 'foo', use
" let g:airline#extensions#branch#format = 1

" to truncate all path sections but the last one, e.g. a branch
" 'foo/bar/baz' becomes 'f/b/baz', use
" let g:airline#extensions#branch#format = 2

function! AirlineInit()
  let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
"  let g:airline_section_b = '%{strftime("%c")}'
"  let g:airline_section_c = '%F'
  let g:airline_section_b = airline#section#create(['%-0.20{getcwd()}'])
  let g:airline_section_c = airline#section#create_left(['file'])
  let g:airline_section_x = airline#section#create(['hunks'])
  let g:airline_section_y = 'BN: %{bufnr("%")}'
  let g:airline_section_z = airline#section#create(['%3.3(%c%) : %3.9(%l/%L%)'])
endfunction
autocmd VimEnter * call AirlineInit()

" automaically display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1



"==============================================
" => Ansible
"==============================================
" See https://github.com/pearofducks/ansible-vim

let g:ansible_unindent_after_newline = 0
let g:ansible_attribute_highlight = "ob"
let g:ansible_name_highlight = 'd'
let g:ansible_extra_keywords_highlight = 1
let g:ansible_normal_keywords_highlight = 'Constant'
let g:ansible_with_keywords_highlight = 'Constant'
let g:ansible_template_syntaxes = { '*.j2': 'jinja2' }




"==============================================
" => CtrlP
"==============================================

let g:ctrlp_map = '<C-p>'

" select which mode to start in
" let g:ctrlp_cmd = 'CtrlPMixed'
" let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_cmd = 'CtrlPMRU'
" let g:ctrlp_cmd = 'CtrlP'
 
let g:ctrlp_working_path_mode = 'raw'          "r=nearest ancestor, a=dir of file, w=cwd 
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 'Et' 

" use silverseacher-ag with CtrlP for super fast buffer search
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  " bind K to grep word under cursor
   nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
endif

" ignore .git dirs for faster loading
" unlet g:ctrlp_custom_ignore
let g:ctrlp_custom_ignore= {
  \ 'dir':  '\v[\/]\.(git)$',
  \ 'file': '\v\.(exe|so|dll|tgz|rpm|zip|tar)$'
  \ }

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard'] 

" use silverseacher-ag with CtrlP for super fast buffer search
if executable('ag')
  " set grepprg=ag\ --nogroup\ --nocolor
  let ackprg='ag --nogroup --nocolor --column'
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  unlet g:ctrlp_user_command
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif


"==============================================
" => Fugitive 
"==============================================

" None 


"==============================================
" => Fzf
"==============================================

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" [[B]Commits] Customize the options used by 'git log':
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

" [Tags] Command to generate tags file
let g:fzf_tags_command = 'ctags -R'

" [Commands] --expect expression for directly executing the command
let g:fzf_commands_expect = 'alt-enter,ctrl-x'

" See https://github.com/junegunn/fzf.vim/issues/59
function! s:update_fzf_colors()
  let rules =
  \ { 'fg':      [['Normal',       'fg']],
    \ 'bg':      [['Normal',       'bg']],
    \ 'hl':      [['Comment',      'fg']],
    \ 'fg+':     [['CursorColumn', 'fg'], ['Normal', 'fg']],
    \ 'bg+':     [['CursorColumn', 'bg']],
    \ 'hl+':     [['Statement',    'fg']],
    \ 'info':    [['PreProc',      'fg']],
    \ 'prompt':  [['Conditional',  'fg']],
    \ 'pointer': [['Exception',    'fg']],
    \ 'marker':  [['Keyword',      'fg']],
    \ 'spinner': [['Label',        'fg']],
    \ 'header':  [['Comment',      'fg']] }
  let cols = []
  for [name, pairs] in items(rules)
    for pair in pairs
      let code = synIDattr(synIDtrans(hlID(pair[0])), pair[1])
      if !empty(name) && code > 0
        call add(cols, name.':'.code)
        break
      endif
    endfor
  endfor
  let s:orig_fzf_default_opts = get(s:, 'orig_fzf_default_opts', $FZF_DEFAULT_OPTS)
  let $FZF_DEFAULT_OPTS = s:orig_fzf_default_opts .
        \ empty(cols) ? '' : (' --color='.join(cols, ','))
endfunction

augroup _fzf
  autocmd!
  autocmd ColorScheme * call <sid>update_fzf_colors()
augroup END


"==============================================
" => GitGutter
"==============================================

let g:gitgutter_max_signs = 500

let g:gitgutter_highlight_lines = 1



"==============================================
" => Golang
"==============================================

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" automatically insert import paths, format, etc.
let g:go_fmt_command = "goreturns"

" fix issues with vim-go and syntastic
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = {'mode': 'active', 'passive_filetypes': ['go']}
let g:go_list_file = "quickfix"



"==============================================
" => NerdTree
"==============================================

map <C-n> :NERDTree<CR>

" let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" start NT automatically if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

let NERDTreeShowHidden=1

" Start NerdTree automatically if VIM opens a dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" Close vim if NerdTree is only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif



"==============================================
" => Surround
"==============================================



"==============================================
" => Syntastic
"==============================================

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_shell = "/bin/bash" 
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" For C++:
" Place this file in the root of the project dir (or higher up dir tree)
" and add lines like this:
"    -I/opt/cppkafka/include
"    -I/opt/rdkafka/include
"
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_cpp_config_file = '~/.syntastic_cpp_config' 

" For Java: 
let g:syntastic_javac_config_file = '~/.syntastic_java_config' 

" For Python
" Ignore long lines
let g:syntastic_python_checker_args='--ignore=E501'
let g:syntastic_python_flake8_args='--ignore=E501,E123'
let g:syntastic_python_flake8_post_args='--ignore=E402,E501,E128,E225,E123,E121'



"==============================================
" => YouCompleteMe
"==============================================

" Set path to 3rd party python packages
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/bin/ycm-conf.py'
