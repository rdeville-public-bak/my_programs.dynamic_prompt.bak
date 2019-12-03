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

_vcsh_info_clr()
{
  echo "$(_vcsh_info)"
}

_vcsh_info_clr_short()
{
  echo "$(_vcsh_info_short)"
}

_vcsh_colorswitch()
{
  echo "${VCSH_BG/4/3}"
}

_vcsh_bg()
{
  echo "${VCSH_BG}"
}

_vcsh_fg()
{
  echo "${VCSH_FG}"
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
