#!/bin/bash
set +x

###
### Utility vars and functions
### Intended to be sourced by scripts
###

# Example:  ${red} some red text ${end}

blk=$'\e[30m'
red=$'\e[31m'
grn=$'\e[32m'
yel=$'\e[33m'
blu=$'\e[34m'
mag=$'\e[35m'
cyn=$'\e[36m'
end=$'\e[0m'

dim=$'\e[2m'
bold=$'\e[1m'
normal=$'\e[0m]'


msg_info() { 
    local msg=$1
    printf "\n%s\n" "${bold}${grn}==> ${msg} ${end}${end}" 1>&2
}

msg_info_dim() {
    local msg=$1
    printf "\n%s\n" "${dim}==> ${msg} ${end}" 1>&2
}

msg_error() {
    local msg=$1
    printf "\n%s\n\n" "${bold}${red}*** ERROR: ${msg} ${end}${end}" 1>&2
}

msg_warn() {
    local msg=$1
    printf "\n%s\n\n" "${bold}${yel}*** WARNING: ${msg} ${end}${end}" 1>&2 
}

msg_fatal() {
    local msg=$1
    printf "\n%s\n\n" "${bold}${red}### FATAL: ${msg} ${end}${end}" 1>&2 
    exit 1
}


#
# is_root() 
#
# Example usage:  
#
#     SUDO=''
#     if ! is_root ; then SUDO='sudo' ; fi 
#     SUDO some_command
#
# OR:
#    if [[ "$(is_root)" == "true" ]] ; then ...
#
#
is_root () {
   if [ “$(id -u)” == “0” ] ; then 
        echo "true"
        return 0 
   else 
        echo "false"
        return 1 
   fi
}

#
# Usage: 
#   if [[ "$(has_sudo_privileges($user))" == "true" ]] ; then
#       ... ; 
#   fi
#
has_sudo_privileges()
{
   local user=$1
   if [[ $(sudo -l -U ${user} | grep -c "not allowed to run sudo") -eq 1 ]] ; then
       echo "false"
       return 1
   else 
       echo "true"
       return 0
   fi
}

has_sudo_privileges_nopassword()
{
   local user=$1
   if [[ "$(has_sudo_privileges ${user})" == "false" ]] ; then
       echo "false"
       return 1
   fi
   # TODO: need to refine grep for different cases (which commands?)
   if [[ $(sudo -l -U ${user} | grep -c "NOPASSWD") -eq 1 ]] ; then
       echo "true"
       return 0
   else
       echo "false"
       return 1
   fi
}


# Check if user can establish key-based connection
check_ssh()
{
   local username=$1
   local hostname=$2
   #  default = 5, unless we receive optional 3rd arg
   local timeout=${3:-5}

   ssh -q -o ConnectTimeout=$timeout $username@$hostname exit
   if [[ $? -ne 0 ]] ; then
      msg_error "ssh failed: cannot establish key-based ssh using $username@$hostname"
   fi
}

# check if a dependency is installed 
check_exe()
{
    local dep="$1"
    if [[ $# -eq 2 ]] ; then
       exit_msg="$2"
    else
       exit_msg=" "
    fi

    if ! command -v ${dep} >/dev/null 2>&1 ; then
      msg_fatal "${dep} must be installed. ${exit_msg}" 
    fi 
}

check_package()
{
    local pkg=$1 
    if [[ $# -eq 2 ]] ; then
       exit_msg="$2"
    else
       exit_msg=" "
    fi

    if [[ $(rpm -qa | grep -c "${pkg}") -gt 0 ]]  ; then
      msg_fatal "${pkg} must be installed. ${exit_msg}" 
    fi 
}


# trim a string variable
trim_whitespace() {
   local var="$*"
   var="${var#"${var%%[![:space:]]*}"}"   # remove leading whitespace characters
   var="${var%"${var##*[![:space:]]}"}"   # remove trailing whitespace characters
   echo -n "$var"
}

# Example usage: append_path PATH $MY_PROJECT/bin
append_path() {
   local the_path=$1
   local the_dir=$2
   if [[ "${!the_path}" == "" ]] ; then
      # path doesn't exist, so create new using the_dir
      export $the_path=$the_dir
   elif ! $(echo "${!the_path}" | tr ":" "\n" | grep -qx "$the_dir"); then
      # path exists, so prepend the_dir (maybe should call the prepend_path)
      export $the_path=$the_dir:${!the_path}
   fi
}


