
if !empty($VIRTUAL_ENV)
  let g:ycm_server_python_interpreter = $VIRTUAL_ENV . '/bin/python'
    let $PYTHONPATH = finddir('site-packages', $VIRTUAL_ENV . '/lib/*')
endif
