#!/bin/bash

# Showing vcsh info
local VCSH_CHAR="${VCSH_CHAR:-" "}"
local VCSH_FG="${VCSH_FG:-""}"
local VCSH_BG="${VCSH_BG:-""}"

_compute_vcsh_info()
{
  if [[ -n "${VCSH_REPO_NAME}" ]]
  then
    echo "${VCSH_CHAR}${VCSH_REPO_NAME}"
  fi
}

_compute_vcsh_info_short()
{
  if [[ -n "${VCSH_REPO_NAME}" ]]
  then
    echo "${VCSH_CHAR}"
  fi
}

# Setting array value
_vcsh_info()
{
  local info=$(_compute_vcsh_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${VCSH_FG}"
    info_line_bg[$iSegment]="${VCSH_BG}"
    info_line_clr_switch[$iSegment]="${VCSH_BG/4/3}"
  fi
}

_vcsh_info_short()
{
  local info=$(_compute_vcsh_info_short)
  if [[ -n "${info}" ]]
  then
    info_line_short[$iSegment]="${info}"
    info_line_clr_short[$iSegment]="${info}"
  fi
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
