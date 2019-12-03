#!/bin/bash

# Showing keepass info
local KEEPASS_CHAR="${KEEPASS_CHAR:-" "}"
local KEEPASS_FG="${KEEPASS_FG:-""}"
local KEEPASS_BG="${KEEPASS_BG:-""}"

_keepass_info()
{
  if [[ -n ${KEEPASS_TYPE} ]]
  then
    echo "${KEEPASS_CHAR}${KEEPASS_TYPE}"
  fi
}

_keepass_info_short()
{
  if [[ -n ${KEEPASS_TYPE} ]]
  then
    echo "${KEEPASS_CHAR}"
  fi
}

_keepass_info_clr()
{
  echo $(_keepass_info)
}

_keepass_info_clr_short()
{
  echo $(_keepass_info_short)
}

_keepass_colorswitch()
{
  echo "${KEEPASS_BG/4/3}"
}

_keepass_bg()
{
  echo "${KEEPASS_BG}"
}

_keepass_fg()
{
  echo "${KEEPASS_FG}"
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
