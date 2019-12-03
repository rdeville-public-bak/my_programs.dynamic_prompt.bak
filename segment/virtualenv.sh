#!/bin/bash

# Showing virtualenv info
local VIRTUALENV_CHAR="${VIRTUALENV_CHAR:-" "}"
local VIRTUALENV_FG="${VIRTUALENV_FG:-""}"
local VIRTUALENV_BG="${VIRTUALENV_BG:-""}"

_virtualenv_info()
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

_virtualenv_info_short()
{
  echo "${VIRTUALENV_CHAR}"
}

_virtualenv_info_clr()
{
  echo "$(_virtualenv_info)"
}

_virtualenv_info_clr_short()
{
  echo "$(_virtualenv_info_short)"
}

_virtualenv_colorswitch()
{
  echo "${VIRTUALENV_BG/4/3}"
}

_virtualenv_bg()
{
  echo "${VIRTUALENV_BG}"
}

_virtualenv_fg()
{
  echo "${VIRTUALENV_FG}"
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
