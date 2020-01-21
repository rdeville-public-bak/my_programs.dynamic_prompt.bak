#!/bin/bash

# Showing whoami info
local USER_CHAR="${USER_CHAR:-" "}"
local USER_FG="${USER_FG:-""}"
local USER_BG="${USER_BG:-""}"

# Setting array value
_whoami_info()
{
  info_line[$iSegment]="${USER_CHAR}$(whoami)"
  info_line_clr[$iSegment]="${USER_CHAR}$(whoami)"
  info_line_fg[$iSegment]="${USER_FG}"
  info_line_bg[$iSegment]="${USER_BG}"
  info_line_clr_switch[$iSegment]="${USER_BG/4/3}"
}

_whoami_info_short()
{
  info_line_short[$iSegment]="${USER_CHAR}"
  info_line_clr_short[$iSegment]="${USER_CHAR}"
}
# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
