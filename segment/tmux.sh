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

_tmux_info_clr()
{
  echo "$(_tmux_info)"
}

_tmux_info_clr_short()
{
  echo "$(_tmux_info_short)"
}

_tmux_colorswitch()
{
  echo "${TMUX_BG/4/3}"
}

_tmux_bg()
{
  echo "${TMUX_BG}"
}

_tmux_fg()
{
  echo "${TMUX_FG}"
}


# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
