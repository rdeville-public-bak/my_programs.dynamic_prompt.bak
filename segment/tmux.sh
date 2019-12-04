#!/bin/bash

# Showing tmux info
local TMUX_CHAR="${TMUX_CHAR:-" "}"
local TMUX_FG="${TMUX_FG:-""}"
local TMUX_BG="${TMUX_BG:-""}"

_tmux_info()
{
  if [[ -n "${TMUX}" ]]
  then
    echo "${TMUX_CHAR} tmux"
  fi
}

_tmux_info_short()
{
  if [[ -n "${TMUX}" ]]
  then
    echo "${TMUX_CHAR}"
  fi
}

# Setting array value
info_line[$iSegment]="$(_tmux_info)"
info_line_clr[$iSegment]="$(_tmux_info)"
info_line_short[$iSegment]="$(_tmux_info_short)"
info_line_clr_short[$iSegment]="$(_tmux_info_short)"
info_line_fg[$iSegment]="${TMUX_FG}"
info_line_bg[$iSegment]="${TMUX_BG}"
info_line_clr_switch[$iSegment]="${TMUX_BG/4/3}"

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
