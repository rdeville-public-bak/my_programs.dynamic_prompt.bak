#!/bin/bash

# Showing whoami info
local USER_CHAR="${USER_CHAR:-" "}"
local USER_FG="${USER_FG:-""}"
local USER_BG="${USER_BG:-""}"

_whoami_info()
{
  echo "${USER_CHAR}$(whoami)"
}

_whoami_info_short()
{
  echo "${USER_CHAR}"
}

_whoami_info_clr()
{
  echo "$(_whoami_info)"
}

_whoami_info_clr_short()
{
  echo "$(_whoami_info_short)"
}

_whoami_colorswitch()
{
  echo "${USER_BG/4/3}"
}

_whoami_bg()
{
  echo "${USER_BG}"
}

_whoami_fg()
{
  echo "${USER_FG}"
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
