#!/bin/bash

# Showing openstack info
local OPENSTACK_CHAR="${OPENSTACK_CHAR:-" "}"
local OPENSTACK_FG="${OPENSTACK_FG:-""}"
local OPENSTACK_BG="${OPENSTACK_BG:-""}"

_openstack_info()
{
  # Compute the openstack information
  local openstack_info=""
  if [[ -n "${OS_PROJECT_NAME}" ]] && [[ -n "${OS_USER_DOMAIN_NAME}" ]]
  then
    openstack_info="${OPENSTACK_CHAR}${OS_PROJECT_NAME}:${OS_USER_DOMAIN_NAME}"
  fi
  echo "${openstack_info}"
}


_openstack_info_short()
{
  if [[ -n "${OS_PROJECT_NAME}" ]] && [[ -n "${OS_USER_DOMAIN_NAME}" ]]
  then
    echo "${OPENSTACK_CHAR}"
  fi
}

_openstack_info_clr()
{
  echo "$(_openstack_info)"
}

_openstack_info_clr_short()
{
  echo "$(_openstack_info_short)"
}

_openstack_colorswitch()
{
  echo "${OPENSTACK_BG/4/3}"
}

_openstack_bg()
{
  echo "${OPENSTACK_BG}"
}

_openstack_fg()
{
  echo "${OPENSTACK_FG}"
}


# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
