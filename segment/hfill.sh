#!/bin/bash

# Showing vcsh info
local HFILL_FG="${DEFAULT_FG:-""}"
local HFILL_BG="${DEFAULT_BG:-""}"

# Setting array value
_hfill_info()
{
  hfill=""
  all_info=$1
  hfill=$(( ${COLUMNS} - ${#all_info} ))
  idx_total=0
  info_line_shorten=()
  info_line_removed=()
  gain=${hfill}
  idx=${idx_start}
  while [[ ${gain} -lt 5 ]] && [[ ${#info_line_removed[@]} -ne ${#segment[@]} ]]
  do
    iSegment="${segment_priority[idx]}"
    if ! [[ " ${info_line_shorten[@]} " =~ " ${iSegment} " ]]
    then
      _${iSegment}_info_short ${gain}
      if [[ -n "${info_line_clr_switch[$iSegment]}" ]]
      then
        info_line_segment_full_short[$iSegment]="${prompt_env_right} ${info_line_short[$iSegment]} ${prompt_env_left}"
      elif [[ -n "${info_line[$iSegment]}" ]]
      then
        info_line_segment_full_short[$iSegment]=" ${info_line_short[$iSegment]} "
      fi
      gain=$(( gain + (${#info_line_segment_full[$iSegment]} - ${#info_line_segment_full_short[$iSegment]}) ))

      info_line[$iSegment]=${info_line_short[$iSegment]}
      info_line_clr[$iSegment]=${info_line_clr_short[$iSegment]}

      info_line_shorten+=("${iSegment}")

      echo $E_NORMAL${iSegment}${gain}
    else
      gain=$(( gain + ${#info_line_segment_full_short[$iSegment]} ))
      if [[ " ${segment_priority[@]} " =~ "pwd" ]]
      then
        _pwd_info_short ${gain}
        if [[ -n "${info_line_clr_switch[pwd]}" ]]
        then
          info_line_segment_full_short[pwd]="${prompt_env_right} ${info_line_short[pwd]} ${prompt_env_left}"
        elif [[ -n "${info_line[pwd]}" ]]
        then
          info_line_segment_full_short[pwd]=" ${info_line_short[pwd]} "
        fi
        info_line[pwd]=${info_line_short[pwd]}
        info_line_clr[pwd]=${info_line_clr_short[pwd]}
        echo "${E_NORMAL}${info_line[pwd]}'='='='='='"
      fi
      info_line[$iSegment]=""
      info_line_clr[$iSegment]=""
      info_line_removed+=("${iSegment}")
    fi
    idx=$(( idx + 1 ))
    if [[ $idx -ge ${idx_stop_priority} ]]
    then
      idx=${idx_start}
    fi
  done
  # Compute the space that will be stored in hfill
  hfill="$(_prompt_printf " " ${gain})"
  echo ${hfill}:${info_line_shorten}:${info_line_removed}
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
