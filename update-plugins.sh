#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP=$(basename $0)
source ${DIR}/link/bin/lib.bash

################################################################
usage() {
cat << EOF

     Update one or all vim plugins

     Usage:
       $APP <list|all|plugin>

          list ........... list all plugins being used
          all ............ updates all
          <plugin> ....... update specific plugin

     Example:
       $APP list 
       $APP all 
       $APP fugitive 

EOF
    exit 1
}
################################################################

list_plugins()
{
    msg_info "Current plugins:"

    for plugin in $(cat .gitmodules | grep path | awk '{print $3}') ; do 
        printf "     $(basename ${plugin}) \n" 
    done
}

update_all_plugins()
{
    msg_info "Updating all plugins:"

    cd ${DIR}
    git submodule foreach git pull origin master
    if [[ $? -ne 0 ]] ; then 
        msg_fatal "Could not update all plugins"
    fi
}

update_plugin()
{
    local plugin=$1
    local plugin_dir="${DIR}/link/vim/pack/plugins/start/${plugin}"

    if [[ ! -d ${plugin_dir} ]] ; then
        msg_fatal "Can't find '${plugin}': ${plugin_dir}"
    fi

    msg_info "Updating '${plugin}' plugin"

    cd ${plugin_dir}

    git checkout master && git pull
    if [[ $? -ne 0 ]] ; then 
        msg_fatal "Could not update '${plugin}'"
    fi
}


main()
{
    [[ $# -eq 1 ]] || usage

    case $1 in 
        list) list_plugins ;; 
        all) update_all_plugins ;; 
        *) update_plugin "$1" ;; 
    esac
}

main "$@"

