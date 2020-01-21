#!/bin/bash

# Showing pwd info
local PWD_CHAR="${PWD_CHAR:-" "}"
local PWD_FG="${PWD_FG:-""}"
local PWD_BG="${PWD_BG:-""}"

_compute_pwd_info()
{
  # Compute pwd and echo it.
  # Replace /home/$(whoami) by ~/ if not root and /root by ~/ if root
  local pwd_info
  pwd_info=$(pwd)
  pwd_info="${PWD_CHAR}${pwd_info/${HOME}/"~"}"
  echo "${pwd_info}"
}

_compute_pwd_info_short()
{
  # Showing pwd info
  local local_hfill=$1
  # Compute pwd and echo it.
  # Replace /home/$(whoami) by ~/ if not root and /root by ~/ if root
  local pwd_info
  local start_prefix_pos
  local start_suffix_pos
  local prefix_size
  local suffix_size
  local max_shorten

  pwd_info=$(_compute_pwd_info)

  prefix_size=$(( local_hfill * -1 + 10 ))
  if [[ "${pwd_info}" != "${PWD_CHAR}~" ]]
  then
    if [[ "$pwd_info" =~ \~ ]]
    then
      start_prefix_pos=$(( ${#PWD_CHAR} + 2 ))
    else
      start_prefix_pos=$(( ${#PWD_CHAR} + 1 ))
    fi
    max_shorten="${pwd_info:0:$start_prefix_pos}...${pwd_info:$(( ${#pwd_info} - 5 ))}"
    if [[ $(( ${#pwd_info} - prefix_size )) -lt ${#max_shorten} ]]
    then
      pwd_info="${max_shorten}"
    else
      start_suffix_pos=$(( start_prefix_pos + prefix_size + 1 ))
      suffix_size=$(( ${#pwd_info} - start_suffix_pos ))
      pwd_prefix="${pwd_info:$start_prefix_pos:$prefix_size}"
      pwd_info="${pwd_info/$pwd_prefix/...}"
    fi
  fi
  echo "${pwd_info}"
}

_pwd_info(){
  info_line[$iSegment]="$(_compute_pwd_info)"
  info_line_clr[$iSegment]="$(_compute_pwd_info)"
  info_line_fg[$iSegment]="${PWD_FG}"
  info_line_bg[$iSegment]="${PWD_BG}"
  info_line_clr_switch[$iSegment]="${PWD_BG/4/3}"
}

# Setting array value
_pwd_info_short()
{
  info_line_short[$iSegment]="$(_compute_pwd_info_short $1)"
  info_line_clr_short[$iSegment]="$(_compute_pwd_info_short $1)"
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
