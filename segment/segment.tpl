#!/bin/bash

# Showing TPL_SEGMENT_LOWER info
local TPL_SEGMENT_UPPER_CHAR="${TPL_SEGMENT_UPPER_CHAR:-"X"}"
local TPL_SEGMENT_UPPER_FG="${TPL_SEGMENT_UPPER_FG:-37}"
local TPL_SEGMENT_UPPER_BG="${TPL_SEGMENT_UPPER_BG:-40}"

_compute_TPL_SEGMENT_LOWER_info()
{
  echo -e "${TPL_SEGMENT_UPPER_CHAR} segment_content"
}

_compute_TPL_SEGMENT_LOWER_info_short()
{
  echo -e "${TPL_SEGMENT_UPPER_CHAR}"
}

# Setting array value
_TPL_SEGMENT_LOWER_info()
{
  # Required method to get segment in long format
  # Update arrays used by v1.sh and v2.sh which held long and color segment and
  # colors segment information
  # NO PARAM
  local info=$(_compute_TPL_SEGMENT_LOWER_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${TPL_SEGMENT_UPPER_FG}"
    info_line_bg[$iSegment]="${TPL_SEGMENT_UPPER_BG}"
    info_line_clr_switch[$iSegment]="${TPL_SEGMENT_UPPER_BG/4/3}"
  fi
}

_TPL_SEGMENT_LOWER_info_short()
{
  # Required method to get segment in short format
  # Update arrays used by v1.sh and v2.sh which held short version of segment
  # NO PARAM
  local info=$(_compute_TPL_SEGMENT_LOWER_info_short)
  if [[ -n "${info}" ]]
  then
    info_line_short[$iSegment]="${TPL_SEGMENT_UPPER_CHAR}"
    info_line_clr_short[$iSegment]="${TPL_SEGMENT_UPPER_CHAR}"
  fi
}
# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
