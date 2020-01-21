#!/bin/bash

# Showing keepass info
local KEEPASS_CHAR="${KEEPASS_CHAR:-" "}"
local KEEPASS_FG="${KEEPASS_FG:-""}"
local KEEPASS_BG="${KEEPASS_BG:-""}"

_compute_keepass_info()
{
  if [[ -n ${KEEPASS_TYPE} ]]
  then
    echo "${KEEPASS_CHAR}${KEEPASS_TYPE}"
  fi
}

_compute_keepass_info_short()
{
  if [[ -n ${KEEPASS_TYPE} ]]
  then
    echo "${KEEPASS_CHAR}"
  fi
}

_keepass_info()
{
  local info=$(_compute_keepass_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${KEEPASS_FG}"
    info_line_bg[$iSegment]="${KEEPASS_BG}"
    info_line_clr_switch[$iSegment]="${KEEPASS_BG/4/3}"
  fi
}

_keepass_info_short()
{
  local info=$(_compute_keepass_info_short)
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
