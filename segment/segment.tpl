#!/bin/bash

# Showing whoami info
local TPL_SEGMENT_UPPER_CHAR="${TPL_SEGMENT_UPPER_CHAR:-"??"}"
local TPL_SEGMENT_UPPER_FG="${TPL_SEGMENT_UPPER_FG:-""}"
local TPL_SEGMENT_UPPER_BG="${TPL_SEGMENT_UPPER_BG:-""}"

_TPL_SEGMENT_LOWER()
{
  echo "segment_content"
}

_TPL_SEGMENT_LOWER_color()
{
  echo -e "${CLR_PREFIX}${TPL_SEGMENT_UPPER_PARAM_FG}${CLR_SUFFIX}segment_content${CLR_PREFIX}${TPL_SEGMENT_UPPER_FG}${CLR_SUFFIX}"
}


# Setting array value
_TPL_SEGMENT_LOWER_info()
{
  info_line[$iSegment]="${TPL_SEGMENT_UPPER_CHAR}$(_TPL_SEGMENT_LOWER)"
  info_line_clr[$iSegment]="${TPL_SEGMENT_UPPER_CHAR}$(_TPL_SEGMENT_LOWER_color)"
  info_line_fg[$iSegment]="${TPL_SEGMENT_UPPER_FG}"
  info_line_bg[$iSegment]="${TPL_SEGMENT_UPPER_BG}"
  info_line_clr_switch[$iSegment]="${TPL_SEGMENT_UPPER_BG/4/3}"
}

_TPL_SEGMENT_LOWER_info_short()
{
  info_line_short[$iSegment]="${TPL_SEGMENT_UPPER_CHAR}"
  info_line_clr_short[$iSegment]="${TPL_SEGMENT_UPPER_CHAR}"
}
# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
