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

# Setting array value
info_line[$iSegment]="$(_keepass_info)"
info_line_clr[$iSegment]="$(_keepass_info)"
info_line_short[$iSegment]="$(_keepass_info_short)"
info_line_clr_short[$iSegment]="$(_keepass_info_short)"
info_line_fg[$iSegment]="${KEEPASS_FG}"
info_line_bg[$iSegment]="${KEEPASS_BG}"
info_line_clr_switch[$iSegment]="${KEEPASS_BG/4/3}"


# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
