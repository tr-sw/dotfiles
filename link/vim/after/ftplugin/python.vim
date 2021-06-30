
if !empty($VIRTUAL_ENV)
  let g:ycm_server_python_interpreter = $VIRTUAL_ENV . '/bin/python'
  let _lib = finddir('site-packages', $VIRTUAL_ENV . '/lib/*')
  let _lib64 = finddir('site-packages', $VIRTUAL_ENV . '/lib64/*')
  let $PYTHONPATH = '.' . ':' . _lib . ':' . _lib64
  unlet _lib
  unlet _lib64
endif
