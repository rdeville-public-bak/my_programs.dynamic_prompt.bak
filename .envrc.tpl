#!/bin/bash

# Automatically activate pipenv 
# - If virtual env is not setup, this will install it
# - This will also automatically load the virtual env
layout_pipenv

# Automatically load Openstack variable. You can find them in your openrc.sh
# file.
export OS_AUTH_URL="<OPENSTACK_URL>"
export OS_USER_DOMAIN_NAME="<OPENSTACK_DOMAIN_NAME>"
if [ -z "$OS_USER_DOMAIN_NAME" ]; then unset OS_USER_DOMAIN_NAME; fi
export OS_PROJECT_DOMAIN_ID="<OPENSTACK_PROJECT_ID>"
if [ -z "$OS_PROJECT_DOMAIN_ID" ]; then unset OS_PROJECT_DOMAIN_ID; fi
unset OS_TENANT_ID
unset OS_TENANT_NAME
export OS_USERNAME=$(cmd to access to the OS_USERNAME)
# If command to access to OS_PASSWORD return 0
if $(cmd to access OS_PASSWORD > /dev/null 2>&1)
then
  export OS_PASSWORD=$(cmd to access of OS_PASSWORD)
else
  echo -e "${E_ERROR}[ERROR] No OS_PASSWORD LOADED${E_NORMAL}" >&2
fi
export OS_REGION_NAME="<OPENSTACK_REGION_NAME>"
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
export OS_INTERFACE="<OPENSTACK_INTERFACE>"
export OS_IDENTITY_API_VERSION=3

# If you work with multiple project in OpenStack
# Replace Project_1 and Project_2 (or more) by your project name. Moreover,
# replace ON and OFF to set default value
# WARNING dialog must be installed
dialog --radiolist "OS Project Selection" 10 40 2 \
  "<Project_1>" "<Project_1>" ON \
  "<Project_2>" "<Project_2>" OFF \
  2> ~/.temp_envrc
export OS_PROJECT_NAME="$(cat ~/.temp_envrc)"
if [ ${OS_PROJECT_NAME} == "<Project_1>" ]
then
  export OS_PROJECT_ID="<THE_HASH_OF_PROJECT_1>"
elif [ ${OS_PROJECT_NAME} == "<Project_2>" ]
then
  export OS_PROJECT_ID="<THE_HASH_OF_PROJECT_2>"
fi

# Setup Ansible configuration file depending on the Openstack project
# Useless if only one environment is used.
if [ ${OS_PROJECT_NAME} == "<Project_1>" ]
then
  export ANSIBLE_CONFIG="${PWD}/<project_1.ansible.cfg>"
elif [ ${OS_PROJECT_NAME} == "<Project_2>" ]
then
  export ANSIBLE_CONFIG="${PWD}/<project_2.ansible.cfg>"
fi

# Setup a variable for testing purpose
export TEST_GITLAB_API_TOKEN="$(cmd to access a working gitlab api for testing)"

#*******************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
#*******************************************************************************
