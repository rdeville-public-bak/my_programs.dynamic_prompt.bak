#!/bin/bash

# Showing hostname info
local HOSTNAME_CHAR="${HOSTNAME_CHAR:-" "}"
local HOSTNAME_FG="${HOSTNAME_FG:-""}"
local HOSTNAME_BG="${HOSTNAME_BG:-""}"

_hostname_info()
{
  echo "${HOSTNAME_CHAR}$(hostname)"
}

_hostname_info_short()
{
  echo "${HOSTNAME_CHAR}"
}

_hostname_info_clr()
{
  echo "$(_hostname_info)"
}

_hostname_info_clr_short()
{
  echo "$(_hostname_info_short)"
}

_hostname_colorswitch()
{
  echo "${HOSTNAME_BG/4/3}"
}

_hostname_bg()
{
  echo "${HOSTNAME_BG}"
}

_hostname_fg()
{
  echo "${HOSTNAME_FG}"
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
