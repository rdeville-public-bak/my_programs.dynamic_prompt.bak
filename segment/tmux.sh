#!/bin/bash

# Showing tmux info
local TMUX_CHAR="${TMUX_CHAR:-" "}"
local TMUX_FG="${TMUX_FG:-""}"
local TMUX_BG="${TMUX_BG:-""}"

_compute_tmux_info()
{
  if [[ -n "${TMUX}" ]]
  then
    echo "${TMUX_CHAR}tmux"
  fi
}

_compute_tmux_info_short()
{
  if [[ -n "${TMUX}" ]]
  then
    echo "${TMUX_CHAR}"
  fi
}

_tmux_info()
{
  local info=$(_compute_tmux_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${TMUX_FG}"
    info_line_bg[$iSegment]="${TMUX_BG}"
    info_line_clr_switch[$iSegment]="${TMUX_BG/4/3}"
  fi
}

_tmux_info_short()
{
  local info=$(_compute_tmux_info_short)
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
