#!/bin/bash

# For fzf (fuzzy file finder

export FZF_HOME=${HOME}/.fzf

export PATH=${PATH}:${FZF_HOME}/bin

if command -v ag >/dev/null 2>&1 ; then
  export FZF_DEFAULT_COMMAND='ag --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  '
fi


if [[ -f ${HOME}/bin/fzf && -f ${FZF_HOME}/shell/completion.bash ]] ; then
  source ${FZF_HOME}/shell/-completion.bash
fi

if [[ -f ${HOME}/bin/fzf && -f ${FZF_HOME}/shell/key-bindings.bash ]] ; then
   source ${FZF_HOME}/shell/fzf-completion.bash
fi
