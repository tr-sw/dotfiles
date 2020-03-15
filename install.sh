#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
set +o xtrace
# this is reset in exit handler
# TODO: preserve existing setting
shopt -u expand_aliases

####################################################################################
usage() { cat << EOF

  Installs dotfiles, including vim plugins (for vim8)

  Usage: 
    install.sh [options]

  Options:
    --all            Install all (j,ag,ack,fzf,ycm,gitconfig) 
    --no-j           No autojump
    --no-ag          No ag (the_silver_searcher)
    --no-ack         No ack advanced grep
    --no-fzf         No fzf fuzzy file finder
    --no-ycm         No YouCompleteMe' vim plugin (requires sudo privileges)
    --no-gitconfig   Don't touch .gitconfig. Otherwise, set include.path = .gitconfig.d files 

  Examples:

    To install all options
       $ cd ~
       $ ./dotfiles/install.sh -all

    To install everything except ack and YouCompleteMe (ycm):
       $ cd ~
       $ ./dotfiles/install.sh --no-ack --no-ycm

  NOTE:
    1. This will create .gitconfig with "[include] .gitconfig.d/*.inc"
       if and only if the git user.name and user.email are not currently set
    2. This install will NOT backup your existing dotfiles.
    3. Autojump, AG, and YouCompleteMe require sudo privileges

EOF
exit 1
}
####################################################################################

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
START_DIR=$(pwd)
source ${DIR}/link/bin/lib.bash


#-------------------------------------------
# Globals
#-------------------------------------------

### defaults
_INSTALL_AG=1
_INSTALL_ACK=1
_INSTALL_FZF=1
_INSTALL_YCM=1
_INSTALL_GITCONFIG=1
_INSTALL_AUTOJUMP=1

### Fuzzy file finder
# don't change this without also changing env.d/00-setenv-fzf.bash
declare -r FZF_HOME=${HOME}/.fzf
declare -r FZF_REPO="https://github.com/junegunn/fzf.git"

### Ack
declare -r ACK_VERSION="3.3.1"
declare -r ACK_URL="https://beyondgrep.com/ack-v${ACK_VERSION}"


#-------------------------------------------
# Dirs and Files
#-------------------------------------------

# for git.user and git.email
declare -r GITCONFIG_BACKUP_DIR="${HOME}/.gitconfig.backup"

declare -r _DOTFILES=( \
  bashrc \
  inputrc \
  vimrc \
)

declare -r _DOTFILE_DIRS=( \
  bash \
  vim \
  gitconfig.files\
  gitconfig.d \
)

declare -r _ENVFILES=( \
  00-setenv-aliases.bash \
  00-setenv-path.bash \
  00-setenv-fzf.bash \
)

declare _BINFILES=( \
  lib.bash \
  ycm-config.py \
  ls-largest-subdirs \
  ls-largest-files\
)


#-------------------------------------------
# Functions
#-------------------------------------------

link_dotfiles()
{
   msg_info "Linking dotfiles:"

   for dotfile in "${_DOTFILES[@]}" ; do
      printf "${dim}   %-24s --> %s ${end}\n"  "~/.${dotfile}" "${DIR}/link/${dotfile}"
      ln -sf "${DIR}/link/${dotfile}" "${HOME}/.${dotfile}"
      [[ $? -eq 0 ]] || {
          msg_fatal "Cannot create soft link: ~/.${dotfile} --> ${DIR}/link/${dotfile}"
      }
   done
}


link_dotfile_dirs()
{
   msg_info "Linking dotfile dirs:"

   for dotfile_dir in "${_DOTFILE_DIRS[@]}" ; do
      printf "${dim}   %-24s --> %s ${end}\n"  "~/.${dotfile_dir}" "${DIR}/link/${dotfile_dir}"
      ln -sf "${DIR}/link/${dotfile_dir}" "${HOME}/.${dotfile_dir}"
      [[ $? -eq 0 ]] || {
          msg_fatal "Cannot create soft link: ~/.${dotfile_dir} --> ${DIR}/link/${dotfile_dir}"
      }
   done
}


link_binfiles()
{
   msg_info "Linking 'bin' files"

   [[ -d ${HOME}/bin ]] || {
       mkdir -p ${HOME}/bin >/dev/null 2>&1
   }

   for binfile in "${_BINFILES[@]}" ; do
      printf "${dim}   ~/bin/%-18s --> %s ${end}\n"  "${binfile}" "${DIR}/bin/${binfile}"
      ln -sf "${DIR}/link/bin/${binfile}" "${HOME}/bin/${binfile}"
      [[ $? -eq 0 ]] || {
          msg_fatal "Cannot create soft link: ~/bin/${binfile} --> ${DIR}/bin/${binfile}"
      }
   done
}


#
# The env.d files are copied so that they can be modified.
# Any re-install of dotfiles will not overwrite these files
copy_envfiles()
{
   msg_info "Copying 'env.d' files"

   [[ -d ${HOME}/env.d ]] || {
       mkdir ${HOME}/env.d >/dev/null 2>&1
   }

   for envfile in "${_ENVFILES[@]}" ; do
      printf "${dim}   %-24s to-> %s\n ${end}"  "${envfile}" "${HOME}/env.d/${envfile}"
      cp ${DIR}/copy/env.d/${envfile} ${HOME}/env.d/${envfile} >/dev/null 2>&1
      [[ $? -eq 0 ]] ||  {
          msg_error "Could not copy env.d file: ${DIR}/copy/env.d/${envfile} to-> $~/env.d/${envfile}"
      }
   done
}


# fuzzy file finder
install_fzf()
{
    msg_info "Downloading 'fzf' (fuzzy file finder)"

    if [[ ! -d ${FZF_HOME} ]] ; then
        git clone --depth 1 ${FZF_REPO} ${FZF_HOME}
    else
        cd ${FZF_HOME}
        git fetch --depth 1
        git reset --hard origin/master
        cd -
    fi

    [[ $? -eq 0 && -f ${FZF_HOME}/install ]] || {
        msg_error "Could not install fzf (fuzzy file finder)" ;
        return 1
    }

    chmod +x ${FZF_HOME}/install >/dev/null 2>&1

    msg_info "Installing 'fzf' (fuzzy file finder)"

    ${FZF_HOME}/install --bin --64 --no-update-rc
    [[ $? -eq 0 && -f ${FZF_HOME}/bin/fzf ]] || {
        msg_error "Could not install fzf binary" ;
        return 1
    }

    chmod +x ${FZF_HOME}/bin/fzf >/dev/null 2>&1
}


install_autojump()
{
    if command -v autojump >/dev/null 2>&1 ; then
       msg_info "Installing autojump ... already installed."
       return 0
    fi

    [[ "$(has_sudo_privileges $(whoami))" == "true" ]] || {
        msg_error "You need sudo privileges to install autojump with this script"
        return 1
    }

    msg_info "Installing 'autojump': sudo yum install -y autojump"
    sudo yum install -y autojump
    [[ $? -eq 0 ]] || {
        msg_error "Could not install autojump"
        return 1
    }
}


install_ag()
{
    if command -v ag >/dev/null 2>&1 ; then
       msg_info "Installing ag ... 'silver searcher' already installed."
       return 0
    fi

    [[ "$(has_sudo_privileges $(whoami))" == "true" ]] || {
        msg_error "You need sudo privileges to install ag with this script"
        return 1
    }

    msg_info "Installing 'ag': sudo yum install -y the_silver_searcher"
    sudo install -y the_silver_searcher
    [[ $? -eq 0 ]] || {
        msg_error "Could not install ag"
    }
}



install_ack()
{
    msg_info "Installing 'ack' (advanced grep)"

    mkdir -p ${HOME}/bin >/dev/null 2>&1

    wget "${ACK_URL}" -O ${DIR}/link/bin/ack

    [[ $? -eq 0 && -f ${DIR}/link/bin/ack ]] || {
        msg_error "Could not download ack: ${ACK_URL}" ;
        return 1
    }
    chmod +x "${DIR}/link/bin/ack" >/dev/null 2>&1

    [[ -d ${HOME}/bin ]] || {
        msg_error "${HOME}/bin not fouund."
        return 1
    }

    [[ -d ${HOME}/bin ]] || {
        mkdir -p ${HOME}/bin >/dev/null 2>&1
    }

    msg_info "Adding link:  ~/bin/ack --> ${DIR}/link/bin/ack"
    ln -sf ${DIR}/link/bin/ack ${HOME}/bin/ack
    [[ $? -eq 0 ]] || {
          msg_error "Could not add link for ack" ;
          return 1
    }
}


install_vim_plugins()
{
   msg_info "Installing vim plugins (this can take a while...)"

   cd ${DIR}

   git submodule init >/dev/null 2>&1
   [[ $? -eq 0  ]] || msg_error "git submodule init failed"

   git submodule update --init --recursive  >/dev/null 2>&1
   [[ $? -eq 0  ]] || msg_error "git submodule update failed"
}


check_ycm_requirements()
{
    declare -a pkg_missing
    pkg_required=(python3 cmake gcc-c++ python-devel python3-devel)

    msg_info "Checking YouCompleteMe system requirements"

    for pkg in "${pkg_required[@]}" ; do
      if [[ $(rpm -qa | grep -c "${pkg}") -eq 0 ]]  ; then
         pkg_missing+=(${pkg})
      fi
    done

    if [[ "${#pkg_missing[@]}" != "0" ]] ; then
       if [[ "$(has_sudo_privileges $(whoami))" == "true" ]] ; then
           msg_info "Installing YCM dependencies"
           sudo yum install -y "${pkg_missing[@]}"
           [[ $? -eq 0 ]] || {
               msg_fatal "Could not install depdendencies: ${pkg_missing[@]}"
           }
       fi
    fi
}


install_ycm()
{
    check_ycm_requirements

    local ycm_dir="${DIR}/link/vim/pack/plugins/start/ycm"

    [[ -d ${ycm_dir} ]] || {
        msg_fatal "YCM plugin not found in installed submodules: ${ycm_dir}"
    }

    msg_info "Compiling YCM plugin support"
cd ${ycm_dir} && python3 ./install.py

    [[ $? -eq 0  ]] || {
        msg_fatal "Could not compile YCM support."
    }
}


set_gitconfig_user()
{
    # don't create if global config already set
    if [[ $(git config --list | egrep -c "^user.email|^user.email") -ne 0 ]] ; then
       msg_info_dim  "Git user information already exists. Skipping modifications to .gitconfig"
       return 0
    fi

    local git_user=unset
    local git_email=unset

    printf "\n${bold}Enter Git user.name and user.email (for .gitconfig) ${end}\n"

    while true ; do

       printf "\n${bold}   Git user.name: ${end}"
       read -r git_user

       printf "${bold}   Git user.email: ${end}"
       read -r git_email

       local config_contents="$(_config_contents ${git_user} ${git_email})"

       msg_info "Ready to update ~/.gitconfig:"
       printf "\n${grn}%s${end}\n" "${config_contents}"

       printf "\n${bold}Continue [c], re-enter [r], or cancel [x]: ${end}"
       read -r response
       case $response in
          [Cc] ) break ;;
          [Rr] ) continue ;;
          [Xx] ) return 1 ;;
             * ) printf "\n${red}Please answer [C|c] to continue or [R|r] to re-enter.${end}"
       esac
    done

    backup_gitconfig

    msg_info "Creating ~/.gitconfig"
    echo "${config_contents}" > ~/.gitconfig
}

_config_contents() {
echo "\
# Created by dotfiles/install.sh - $(date '+%Y-%m-%d %H:%M:%S')
[user]
    name = $1
    email = $2
[include]
    path = .gitconfig.d/aliases.inc
    path = .gitconfig.d/color.inc
    path = .gitconfig.d/core.inc
    path = .gitconfig.d/filter.inc
    path = .gitconfig.d/push.inc
    path = .gitconfig.d/template.inc
    path = .gitconfig.d/web.inc "
}


# This will use [include] to apply the configuarions defined in .gitconfig.d/*.inc
backup_gitconfig()
{
    if [[ -f ~/.gitconfig ]] ; then
        mkdir -p ${GITCONFIG_BACKUP_DIR} >/dev/null 2>&1
        local backup_file="${HOME}/.gitconfig.$(date '+%Y%m%d-%s')"
        msg_info "Backing up existing ~/.gitconfig --> ${GITCONFIG_BACKUP_DIR}/${backup_file}"
        cp ${HOME}/.gitconfig ${GITCONFIG_BACKUP_DIR}/${backup_file}
    fi
}


check_system_requirements()
{
    check_exe "wget"
    check_exe "git"
    check_exe "vim"

    if [[ "$(vim --version | head -1 | cut -d ' ' -f 5 | cut -d '.' -f 1)" -lt 8 ]] ; then
      msg_fatal "This collection of dotfiles requires vim 8 or above."
    fi
}


exit_handler()
{
   shopt -s expand_aliases
   cd ${START_DIR}
   msg_info "Exiting..."
}
trap exit_handler EXIT


parse_opts()
{
  for opt in "$@" ; do
    case $opt in
      -a) ;;
      -all) ;;
      --a) ;;
      --all) ;;
      --no-ag) _INSTALL_AG=0 ;;
      --no-ack) _INSTALL_ACK=0 ;;
      --no-fzf) _INSTALL_FZF=0 ;;
      --no-ycm) _INSTALL_YCM=0 ;;
      --no-j) _INSTALL_AUTOJUMP=0 ;;
      --no-gitconfig) _INSTALL_GITCONFIG=0 ;;
      *) msg_fatal "Invalid option: ${opt}" ; usage ;;
    esac
  done
}


#-------------------------------------------
#  Main
#-------------------------------------------

main()
{
    if [[ $# -eq 0 ]] ; then
        usage
    fi

    if [[ "$(id -u)" == "0" ]] ; then
        msg_fatal "Cannot run this install script as root."
    fi

    check_system_requirements

    parse_opts "$@"

    if [[ ${_INSTALL_AUTOJUMP} -eq 1 ]] ; then
        install_autojump
    fi

    if [[ ${_INSTALL_AG} -eq 1 ]] ; then
        install_ag
    fi

    if [[ ${_INSTALL_ACK} -eq 1 ]] ; then
        install_ack
    fi

    if [[ ${_INSTALL_FZF} -eq 1 ]] ; then
       install_fzf
    fi

    link_dotfiles
    link_dotfile_dirs
    link_binfiles
    copy_envfiles

    install_vim_plugins

    if [[ ${_INSTALL_YCM} -eq 1 ]] ; then
       install_ycm
    fi

    if [[ ${_INSTALL_GITCONFIG} -eq 1 ]] ; then
       set_gitconfig_user
    fi
}

main "$@"
