
if !empty($VIRTUAL_ENV)
  let g:ycm_server_python_interpreter = $VIRTUAL_ENV . '/bin/python'
  let lib = finddir('site-packages', $VIRTUAL_ENV . '/lib/*')
  let lib64 = finddir('site-packages', $VIRTUAL_ENV . '/lib64/*')
  let $PYTHONPATH = lib . ':' . lib64 
endif
