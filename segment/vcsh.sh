#!/bin/bash

# Showing vcsh info
local VCSH_CHAR="${VCSH_CHAR:-" "}"
local VCSH_FG="${VCSH_FG:-""}"
local VCSH_BG="${VCSH_BG:-""}"

_vcsh_info()
{
  if [[ -n "${VCSH_REPO_NAME}" ]]
  then
    echo "${VCSH_CHAR}${VCSH_REPO_NAME}"
  fi
}

_vcsh_info_short()
{
  if [[ -n "${VCSH_REPO_NAME}" ]]
  then
    echo "${VCSH_CHAR}"
  fi
}

# Setting array value
info_line[$iSegment]="$(_vcsh_info)"
info_line_clr[$iSegment]="$(_vcsh_info)"
info_line_short[$iSegment]="$(_vcsh_info_short)"
info_line_clr_short[$iSegment]="$(_vcsh_info_short)"
info_line_fg[$iSegment]="${VCSH_FG}"
info_line_bg[$iSegment]="${VCSH_BG}"
info_line_clr_switch[$iSegment]="${VCSH_BG/4/3}"

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
