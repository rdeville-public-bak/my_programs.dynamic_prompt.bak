#!/usr/bin/env sh
# *****************************************************************************
# File    : ~/.shellrc.d/lib/prompt.sh
# License : GNU General Public License v3.0
# Author  : Romain Deville <contact@romaindeville.fr>
# *****************************************************************************

# DESCRIPTION:
# =============================================================================
# Basic method for my shell prompt

# METHODS
# =============================================================================

precmd()
{
  _prompt_printf()
  {
    # Repeat a string $1 for $2 amount of times
    str=$1
    num=$2
    v=$(printf "%-${num}s" "$str")
    echo "${v// /$str}"
    return
  }

  _prompt_info_line()
  {

    # Prompt the first line with information such as pwd, keepass, user,
    # hostname
    local termsize
    local hfill
    local all_info
    local prompt_right
    local prompt_left
    local idx_start
    local idx_stop
    local idx_stop_prioriy
    local clr_switch
    local clr_fg
    local segment_idx
    local segment
    local segment_priority
    local info_line
    local info_line_fg
    local info_line_color
    local info_line_shorten
    local first_line_prompt=false

    if [[ $1 -eq 0 ]]
    then
      first_line_prompt=true
    fi

    if [[ ${SHELL} == bash ]]
    then
      segment_idx=$1
      IFS=', ' read -r -a segment <<< "${SEGMENT[$segment_idx]}"
      IFS=', ' read -r -a segment_priority <<< "${SEGMENT_PRIORITY[$segment_idx]}"
      idx_start=0
      idx_stop=${#segment[@]}
      idx_stop_prioriy=${#segment_priority[@]}
      declare -A info_line
      declare -A info_line_fg
      declare -A info_line_color
    else
      segment_idx=$(( $1 + 1 ))
      IFS=', ' read -r -A segment <<< "${SEGMENT[$segment_idx]}"
      IFS=', ' read -r -A segment_priority <<< "${SEGMENT_PRIORITY[$segment_idx]}"
      idx_start=1
      idx_stop=$(( ${#segment[@]} + 1 ))
      idx_stop_prioriy=${#segment_priority[@]}
      typeset -A info_line
      typeset -A info_line_fg
      typeset -A info_line_color
    fi

    # Loag segment source files
    all_info=""
    for iSegment in "${segment[@]}"
    do
      if [[ ${iSegment} != "hfill" ]]
      then
        source <(cat "${SHELL_DIR}/lib/prompt/segment/${iSegment}.sh")
        info="$(_${iSegment}_info)"
        if [[ -n ${info} ]]
        then
          info_line[$iSegment]="$(_${iSegment}_info)"
          info_line_color[$iSegment]="$(_${iSegment}_info_clr)"
          info_line_fg[$iSegment]="$(_${iSegment}_fg)"
          # Do not print PROMPT_ENV (i.e. bracket by default) on first line of
          # prompt
          if [[ ${first_line_prompt} == true ]]
          then
            all_info+=" ${info_line[$iSegment]} "
          else
            all_info+="${PROMPT_ENV_LEFT}${info_line[$iSegment]}${PROMPT_ENV_RIGHT}"
          fi
        fi
      fi
    done

    if [[ ${info_line[@]} == "" ]]
    then
      echo ""
      return
    fi

    # Compute size of terminal
    termsize=$(tput cols)
    # Compute size of blank space
    hfill=$(( termsize - ${#all_info} ))
    # Shorten line if not enough place
    idx_total=0
    info_line_shorten=()
    while [[ ${hfill} -lt 5 ]] && [[ ${#all_info} -gt 0 ]]
    do
      shorten=false
      idx=${idx_start}
      # While no segment shorten or not pass through all priority
      while [[ ${idx} -le ${idx_stop_prioriy} ]] && [[ ${shorten} == false ]]
      do
        iSegment="${segment_priority[idx]}"
        # If segment not empty
        if [[ -n "${info_line[$iSegment]}" ]]
        then
          # Compare current segment with shorten verion and empty string
          iSegment_curr="${info_line[$iSegment]}"
          iSegment_short="$(_${iSegment}_info_short ${hfill})"
          # If current segment is not empty
          if [[ -n ${iSegment_curr} ]]
          then
            # If current segment is not already the shorten version
            if ! [[ "${info_line_shorten[@]}" =~ ${iSegment} ]]
            then
              info_line[$iSegment]="${iSegment_short}"
              info_line_color[$iSegment]="${iSegment_short}"
              info_line_shorten+=("${iSegment}")
              shorten=true
            # If all segment have already been shorten
            elif [[ "${#info_line_shorten[@]}" == "$(( ${#segment[@]} - 1 ))" ]]
            then
              info_line[$iSegment]=""
              info_line_color[$iSegment]=""
              shorten=true
            fi
          fi
        fi
        # Update segment separator
        idx=$(( idx + 1 ))
      done
      # Construct line from newly computed segment
      all_info=""
      for iSegment in "${segment[@]}"
      do
        if [[ -n ${info_line[${iSegment}]} ]] && [[ ${iSegment} != "hfill" ]]
        then
          if [[ ${first_line_prompt} == true ]]
          then
            all_info+="${PROMPT_ENV_LEFT}${info_line[$iSegment]}${PROMPT_ENV_RIGHT}"
          else
            all_info+=" ${info_line[$iSegment]} "
          fi
        fi
      done
      all_info+=" "
      hfill=$(( termsize - ${#all_info} + 1 ))
    done
    # Compute the space that will be stored in hfill
    hfill="$(_prompt_printf " " ${hfill})"

    # Compute the line depending on the shell (bash or zsh) and the user.
    # If user is root, the full line will be BOLD
    local color_switch=""
    all_info=""
    if [[ "$(whoami)" == root ]]
    then
      all_info="${BOLD}"
    fi
    if [[ ${first_line_prompt} == true ]]
    then
      all_info+="${CLR_PREFIX}${DEFAULT_BG}${CLR_SUFFIX}"
    else
      all_info+="${E_NORMAL}"
    fi
    # Generate first line without colors
    for ((idx=${idx_start}; idx < ${idx_stop}; idx++))
    do
      iSegment="${segment[idx]}"
      if [[ ${iSegment} != "hfill" ]]
      then
        temp_idx=$(( idx + 1 ))
        iNext_segment="${segment[temp_idx]}"
        while [[ "$(( temp_idx ))" -lt "${idx_stop}" ]] \
            && [[ "${iNext_segment}" != "hfill" ]] \
            && [[ -z "${info_line_color[$iNext_segment]}" ]]
        do
          temp_idx=$(( temp_idx + 1 ))
          iNext_segment="${segment[temp_idx]}"
        done
        # Get info colored
        info="${info_line_color[$iSegment]}"
        if [[ -n "${info}" ]]
        then
          # Reset segment separator
          prompt_right=""
          prompt_left=""
          # Get colors
          if [[ -n "${info_line_fg[$iSegment]}" ]]
          then
            clr_fg="${CLR_PREFIX}${info_line_fg[$iSegment]}${CLR_SUFFIX}"
          else
            clr_fg="${CLR_PREFIX}${DEFAULT_FG}${CLR_SUFFIX}"
          fi
          # Comput segment separator colors
          # Add colored info to line
          if [[ ${first_line_prompt} == true ]]
          then
            all_info+="${clr_fg} ${info} "
          else
            all_info+="${clr_fg}${PROMPT_ENV_LEFT}${info}${PROMPT_ENV_RIGHT}"
          fi
        fi
      else
        if [[ ${first_line_prompt} == true ]]
        then
          all_info+="${hfill}"
        else
          all_info+="${hfill}"
        fi
      fi
    done
    all_info+="${E_NORMAL}"
    echo -e "${all_info}"
    return
  }

  local host_dir="${SHELL_DIR}/hosts"
  local HOST=$(hostname)

  if [ -f "${host_dir}/common.sh" ]
  then
    # shellcheck disable=SC1090
    # SC1090: Can't follow non-constant source. Use a directive to specify
    #         location.
    source <(cat "${host_dir}/common.sh")
  fi

  if [ -f "${host_dir}/${HOST}.sh" ]
  then
    # shellcheck disable=SC1090
    # SC1090: Can't follow non-constant source. Use a directive to specify
    #         location.
    source <(cat "${host_dir}/${HOST}.sh")
  fi

  # PROMPT VARIABLE THAT CAN BE OVERLOADED BY THE USER
  # ==========================================================================
  # Setting environment variable
  if [[ -z ${SEGMENT} ]]
  then
    local SEGMENT=(
      "pwd, hfill, keepass, whoami, hostname"
      "tmux, virtualenv, vcs, hfill, kube, openstack"
    )
  fi
  if [[ -z ${SEGMENT_PRIORITY} ]]
  then
    local SEGMENT_PRIORITY=(
      "whoami, hostname, keepass, pwd"
      "tmux, virtualenv, vcs, hfill, kube, openstack"
    )
  fi

  if [[ "${TRUE_COLOR_TERM[@]}" =~ ${SHELL_APP} ]]
  then
    if [[ "${SHELL}" == bash ]]
    then
      local CLR_PREFIX="\x1b["
      local CLR_SUFFIX="m"
      local BASE_CLR_PREFIX="\[\e["
      local BASE_CLR_SUFFIX="m\]"
    elif [[ "${SHELL}" == zsh ]]
    then
      local CLR_PREFIX="%{\x1b["
      local CLR_SUFFIX="m%}"
      local BASE_CLR_PREFIX="%{\033["
      local BASE_CLR_SUFFIX="m%}"
    fi
    local DEFAULT_CLR_FG="38;2;255;255;255"
    local DEFAULT_CLR_BG="48;2;0;0;0"
    local DEFAULT_NORMAL="0"
    local DEFAULT_BOLD="1"
  else
    if [[ "${SHELL}" == bash ]]
    then
      local CLR_PREFIX="\[\e["
      local CLR_SUFFIX="m\]"
      local BASE_CLR_PREFIX="\[\e["
      local BASE_CLR_SUFFIX="m\]"
    elif [[ "${SHELL}" == zsh ]]
    then
      local CLR_PREFIX="%{\033["
      local CLR_SUFFIX="m%}"
      local BASE_CLR_PREFIX="%{\033["
      local BASE_CLR_SUFFIX="m%}"
    fi
    local DEFAULT_CLR_FG="38;5;15"
    local DEFAULT_CLR_BG="48;5;0"
    local DEFAULT_NORMAL="0"
    local DEFAULT_BOLD="1"
  fi

  local NORMAL="${BASE_CLR_PREFIX}${NORMAL:-${DEFAULT_NORMAL}}${BASE_CLR_SUFFIX}"
  local BOLD="${BASE_CLR_PREFIX}${BOLD:-${DEFAULT_BOLD}}${BASE_CLR_SUFFIX}"
  local REVERSE="${BASE_CLR_PREFIX}${REVERSE:-${DEFAULT_REVERSE}}${BASE_CLR_SUFFIX}"

  # Prompt Colors
  local RETURN_CODE_FG="${RETURN_CODE_FG:-${DEFAULT_CLR_FG}}"
  local CORRECT_WRONG_FG="${CORRECT_WRONG_FG:-${DEFAULT_CLR_FG}}"
  local CORRECT_RIGHT_FG="${CORRECT_RIGHT_FG:-${DEFAULT_CLR_FG}}"
  local DEFAULT_BG="${DEFAULT_BG:-${DEFAULT_CLR_BG}}"
  local DEFAULT_FG="${DEFAULT_FG:-${DEFAULT_CLR_FG}}"
  local PROMPT_ENV_LEFT="${PROMPT_ENV_LEFT:-[}"
  local PROMPT_ENV_RIGHT="${PROMPT_ENV_RIGHT:-]}"

  # Compute final prompt
  local final_prompt
  for (( idx=0;idx<${#SEGMENT[@]};idx++))
  do
    line="$(_prompt_info_line ${idx})"
    if [[ -n ${line} ]]
    then
      if  [[ $(tput cols) -lt 25 ]]
      then
        final_prompt+="${line}\n"
      else
        final_prompt+="${line}"
      fi
    fi
  done
  # Compute end of final prompt  depending on the terminal
  if [[ "${SHELL}" =~ bash ]]
  then
    final_prompt+="$(echo -e "\n${CLR_PREFIX}${RETURN_CODE_FG}${CLR_SUFFIX} \$? ↵ ${NORMAL}﬌ ")"
    export PS1=${final_prompt}
  elif [[ "${SHELL}" =~ zsh ]]
  then
    final_prompt+="$(echo -e "\n ﬌ ")"
    export PROMPT=${final_prompt}
    export RPROMPT=$(echo -e "${CLR_PREFIX}${RETURN_CODE_FG}${CLR_SUFFIX}%(?..%? ↵)%{${E_NORMAL}%}")
    export SPROMPT=$(echo -e "Correct ${CLR_PREFIX}${CORRECT_WRONG_FG}${CLR_SUFFIX}%R%f to ${CLR_PREFIX}${CORRECT_RIGHT_FG}${CLR_SUFFIX}%r%f [nyae]? ")
  fi

  # Unset function to not be shown as autocompletion
  unset -f _prompt_printf
  unset -f _prompt_info_line
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
