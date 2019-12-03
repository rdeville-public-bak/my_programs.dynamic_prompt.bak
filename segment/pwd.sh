#!/bin/bash

# Showing pwd info
local PWD_CHAR="${PWD_CHAR:-" "}"
local PWD_FG="${PWD_FG:-""}"
local PWD_BG="${PWD_BG:-""}"

_pwd_info()
{
  # Compute pwd and echo it.
  # Replace /home/$(whoami) by ~/ if not root and /root by ~/ if root
  local pwd_info

  pwd_info=$(pwd)
  if [[ ${pwd_info} =~ ^/home/$(whoami) ]]
  then
    pwd_info="${PWD_CHAR}~${pwd_info##/home/$(whoami)}"
  elif [[ ${pwd_info} =~ /root ]] && [[ $(whoami) == root ]]
  then
    pwd_info="${PWD_CHAR}~${pwd_info##/root}"
  else
    pwd_info="${PWD_CHAR}${pwd_info}"
  fi

  echo "${pwd_info}"
}

_pwd_info_short()
{
  # Showing pwd info
  local PWD_CHAR="${PWD_CHAR:-" "}"
  local SHOW_PWD_INFO="${SHOW_PWD_INFO:-true}"
  local local_hfill="$1"

  # Compute pwd and echo it.
  # Replace /home/$(whoami) by ~/ if not root and /root by ~/ if root
  local pwd_info
  local start_prefix_pos
  local start_suffix_pos
  local prefix_size
  local suffix_size
  local max_shorten

  pwd_info=$(_pwd_info)

  prefix_size=$(( local_hfill * -1 + 10 ))
  if [[ "$pwd_info" =~ \~ ]]
  then
    start_prefix_pos=$(( ${#PWD_CHAR} + 2 ))
  else
    start_prefix_pos=$(( ${#PWD_CHAR} + 1 ))
  fi
  max_shorten="${pwd_info:0:$start_prefix_pos}..."
  if [[ $(( ${#pwd_info} - prefix_size )) -lt ${#max_shorten} ]]
  then
    pwd_info="${pwd_info:0:$start_prefix_pos}..."
  else
    start_suffix_pos=$(( start_prefix_pos + prefix_size + 1 ))
    suffix_size=$(( ${#pwd_info} - start_suffix_pos ))
    pwd_prefix="${pwd_info:$start_prefix_pos:$prefix_size}"
    pwd_info="${pwd_info/$pwd_prefix/...}"
  fi
  echo "${pwd_info}"
}


_pwd_info_clr()
{
  echo "$(_pwd_info)"
}

_pwd_info_clr_short()
{
  echo "$(_pwd_info_short $@)"
}

_pwd_colorswitch()
{
  echo "${PWD_BG/4/3}"
}

_pwd_bg()
{
  echo "${PWD_BG}"
}

_pwd_fg()
{
  echo "${PWD_FG}"
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
