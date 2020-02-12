#!/bin/bash

if [[ -z "${DEBUG}" ]]
then
  export DEBUG=1
  export OS_USER_DOMAIN_NAME="DOMAIN"
  export OS_PROJECT_NAME="PROJECT"
  export TMUX="true"
  export KEEPASS_TYPE=perso
  export VIRTUAL_ENV=/home/user/.local/share/virtualenvs/prompt-ABCDEF
  export KUBE_CONTEXT=cluster:namespace
  export VCSH_REPO_NAME=prompt
else
  unset DEBUG
  unset OS_USER_DOMAIN_NAME
  unset OS_PROJECT_NAME
  unset TMUX
  unset KEEPASS_TYPE
  unset VIRTUAL_ENV
  unset KUBE_CONTEXT
  unset VCSH_REPO_NAME
fi


# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
