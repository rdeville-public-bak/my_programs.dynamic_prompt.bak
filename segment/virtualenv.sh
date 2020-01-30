#!/bin/bash

# Showing virtualenv info
local VIRTUALENV_CHAR="${VIRTUALENV_CHAR:-" "}"
local VIRTUALENV_FG="${VIRTUALENV_FG:-""}"
local VIRTUALENV_BG="${VIRTUALENV_BG:-""}"

_compute_virtualenv_info()
{
  # Compute the virtual environment info
  local virtualenv
  local version
  local virtualenv_info=""

  if [[ -n "${VIRTUAL_ENV}" ]]
  then
    virtualenv=${VIRTUAL_ENV##*/}
    virtualenv=${virtualenv%%-*}
    # Redirection to handle Python2 that output version on stderr
    version=$(python -V 2>&1)
    version=${version##* }
    virtualenv_info="${VIRTUALENV_CHAR}v${version}:${virtualenv}"
  fi
  echo "${virtualenv_info}"
}

_compute_virtualenv_info_short()
{
  echo "${VIRTUALENV_CHAR}"
}


_virtualenv_info()
{
  local info=$(_compute_virtualenv_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${VIRTUALENV_FG}"
    info_line_bg[$iSegment]="${VIRTUALENV_BG}"
    info_line_clr_switch[$iSegment]="${VIRTUALENV_BG/4/3}"
  fi
}

_virtualenv_info_short()
{
  local info=$(_compute_virtualenv_info_short)
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
