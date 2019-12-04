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

# Setting array value
info_line[$iSegment]="$(_openstack_info)"
info_line_clr[$iSegment]="$(_openstack_info)"
info_line_short[$iSegment]="$(_openstack_info_short)"
info_line_clr_short[$iSegment]="$(_openstack_info_short)"
info_line_fg[$iSegment]="${OPENSTACK_FG}"
info_line_bg[$iSegment]="${OPENSTACK_BG}"
info_line_clr_switch[$iSegment]="${OPENSTACK_BG/4/3}"

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
