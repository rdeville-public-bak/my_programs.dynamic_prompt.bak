#!/usr/bin/env bash
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

  _load_segment()
  {
    local segment=$1
    cat "${PROMPT_DIR}/segment/${segment}.sh"
  }

  _load_all_segment()
  {
    for iSegment in ${segment[@]}
    do
      _load_segment ${iSegment} &
    done
    wait
  }

  _prompt_info_line()
  {
    # Prompt the first line with information such as pwd, keepass, user,
    # hostname
    local termsize
    local hfill
    local all_info
    local prompt_env_right
    local prompt_env_left
    local prompt_right
    local prompt_left
    local idx_start
    local idx_stop
    local idx_stop_prioriy
    local clr_switch
    local clr_bg
    local clr_fg
    local segment_idx
    local segment
    local segment_priority
    local info_line
    local info_line_short
    local info_line_clr
    local info_line_clr_short
    local info_line_shorten
    local info_line_removed
    local info_line_segment_full
    local info_line_segment_full_short
    local first_line_prompt=false
    local options
    local declaration

    # Set variable and associative array depending on the shell
    segment_idx=$1
    case ${SHELL} in
      *bash)
        options="-a"
        declaration="declare"
        declare -A info_line
        declare -A info_line_segment_full
        declare -A info_line_segment_full_short
        declare -A info_line_short
        declare -A info_line_clr
        declare -A info_line_clr_short
        declare -A info_line_fg
        declare -A info_line_bg
        declare -A info_line_clr_switch
        declare -A pids
        if [[ $1 -eq 0 ]]
        then
          first_line_prompt="true"
        fi
        IFS=', ' read -r -a segment <<< "${SEGMENT[$segment_idx]}"
        IFS=', ' read -r -a segment_priority <<< "${SEGMENT_PRIORITY[$segment_idx]}"
        ;;
      *zsh)
        typeset -A info_line
        typeset -A info_line_segment_full
        typeset -A info_line_segment_full_short
        typeset -A info_line_short
        typeset -A info_line_clr
        typeset -A info_line_clr_short
        typeset -A info_line_fg
        typeset -A info_line_bg
        typeset -A info_line_clr_switch
        typeset -A pids
        IFS=', ' read -r -A segment <<< "${SEGMENT[$segment_idx]}"
        IFS=', ' read -r -A segment_priority <<< "${SEGMENT_PRIORITY[$segment_idx]}"
        if [[ ${segment_idx} -eq 1 ]]
        then
          first_line_prompt="true"
        fi
    esac
    idx_start=0
    idx_stop=${#segment[@]}
    idx_stop_priority=${#segment_priority[@]}
    case ${SHELL} in
      *zsh)
        idx_start=$(( idx_start + 1 ))
        idx_stop=$(( idx_stop + 1 ))
        idx_stop_priority=$(( idx_stop_priority + 1 ))
        ;;
    esac

    # Loag segment source files
    all_info=""
    prompt_env_right=""
    prompt_env_left="${PROMPT_ENV_LEFT}"
    source <(_load_all_segment)

    for iSegment in ${segment[@]}
    do
      if [[ $iSegment != "hfill" ]]
      then
        _${iSegment}_info ${iSegment}
        _${iSegment}_info_short
      fi
    done

    if [[ "${#info_line[@]}" -eq 0 ]]
    then
      echo ""
      return
    fi

    for iSegment in ${segment[@]}
    do
      if [[ ${iSegment} != "hfill" ]] && [[ -n ${info_line[$iSegment]} ]]
      then
        if [[ -n "${info_line_clr_switch[$iSegment]}" ]]
        then
          info_line_segment_full[$iSegment]="${prompt_env_right} ${info_line[$iSegment]} ${prompt_env_left}"
        else
          info_line_segment_full[$iSegment]=" ${info_line[$iSegment]} "
        fi
        all_info+="${info_line_segment_full[$iSegment]}"
      else
        prompt_env_left=""
        prompt_env_right="${PROMPT_ENV_RIGHT}"
      fi
    done

    if [[ " ${segment[@]} " =~ " hfill " ]]
    then
      # Showing vcsh info
      local HFILL_FG="${DEFAULT_FG:-""}"
      local HFILL_BG="${DEFAULT_BG:-""}"
      local hfill=""
      local hfill=$(( ${COLUMNS} - ${#all_info} ))
      local idx_total=0
      local info_line_shorten=()
      local info_line_removed=()
      local gain=${hfill}
      local idx=${idx_start}
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
    else
      hfill=false
    fi

    # Compute the line depending on the shell (bash or zsh) and the user.
    # If user is root, the full line will be BOLD
    all_info=""
    if [[ "$(whoami)" == root ]]
    then
      all_info="${BOLD}"
    fi

    if [[ "${first_line_prompt}" == "true" ]]
    then
      all_info+="${CLR_PREFIX}${DEFAULT_BG}${CLR_SUFFIX}"
    fi
    # Generate first line without colors
    prompt_env_right=""
    prompt_env_left="${PROMPT_ENV_LEFT}"
    for ((idx=${idx_start}; idx < ${idx_stop}; idx++))
    do
      iSegment="${segment[idx]}"
      if [[ ${iSegment} != "hfill" ]]
      then
        if [[ -n "${info_line[$iSegment]}" ]] \
          && ! [[ " ${info_line_removed[@]} " =~ " ${iSegment} " ]]
        then
          clr_next_bg=""
          temp_idx=$(( idx + 1 ))
          iNext_segment="${segment[temp_idx]}"
          while [[ "$(( temp_idx ))" -lt "${idx_stop}" ]] \
            && [[ "${iNext_segment}" != "hfill" ]] \
            && [[ -z "${info_line[$iNext_segment]}" ]]
          do
            temp_idx=$(( temp_idx + 1 ))
            iNext_segment="${segment[temp_idx]}"
          done
          if [[ "${iNext_segment}" == "hfill" ]]
          then
            if [[ "${first_line_prompt}" == "true" ]]
            then
              clr_next_bg="${CLR_PREFIX}${DEFAULT_BG}${CLR_SUFFIX}"
            else
              clr_next_bg="${E_NORMAL}${CLR_PREFIX}${info_line_bg[$iSegment]/4/3}${CLR_SUFFIX}"
            fi
          elif [[ -n "${iNext_segment}" ]]
          then
            if [[ -n "${info_line_bg[$iNext_segment]}" ]]
            then
              clr_next_bg="${CLR_PREFIX}${info_line_bg[$iNext_segment]}${CLR_SUFFIX}"
            else
              clr_next_bg=""
            fi
          else
            clr_next_bg=""
          fi
          # Get info colored
          if [[ " ${info_line_shorten} " =~ " ${iSegment} " ]]
          then
            info="${info_line_clr_short[$iSegment]}"
          else
            info="${info_line_clr[$iSegment]}"
          fi
          if [[ -n "${info}" ]]
          then
            # Get colors
            if [[ -n "${info_line_clr_switch[$iSegment]}" ]]
            then
              clr_switch="${CLR_PREFIX}${info_line_clr_switch[$iSegment]}${CLR_SUFFIX}"
            fi
            if [[ -n "${info_line_bg[$iSegment]}" ]]
            then
              clr_bg="${CLR_PREFIX}${info_line_bg[$iSegment]}${CLR_SUFFIX}"
            else
              clr_bg="${CLR_PREFIX}${DEFAULT_BG}${CLR_SUFFIX}"
            fi
            if [[ -n "${info_line_fg[$iSegment]}" ]]
            then
              clr_fg="${CLR_PREFIX}${info_line_fg[$iSegment]}${CLR_SUFFIX}"
            else
              clr_fg="${CLR_PREFIX}${DEFAULT_FG}${CLR_SUFFIX}"
            fi
            # Comput segment separator colors
            if [[ -n ${info_line_clr_switch[$iSegment]} ]]
            then
              if [[ -n "${prompt_env_right}" ]]
              then
                prompt_right="${CLR_PREFIX}${info_line_clr_switch[$iSegment]}${CLR_SUFFIX}${prompt_env_right}"
              fi
              if [[ -n "${prompt_env_left}" ]]
              then
                prompt_left="${CLR_PREFIX}${info_line_clr_switch[$iSegment]}${CLR_SUFFIX}${clr_next_bg}${prompt_env_left}"
              fi
            fi
            # Add colored info to line
            all_info+="${prompt_right}${clr_fg}${clr_bg} ${info} ${prompt_left}"
          fi
        fi
      else
        # Reset segment separator
        prompt_right=""
        prompt_left=""
        if [[ ${first_line_prompt} == "true" ]]
        then
          clr_switch="${CLR_PREFIX}${DEFAULT_BG/4/3}${CLR_SUFFIX}"
          all_info+="${clr_switch}${CLR_PREFIX}${DEFAULT_BG}${CLR_SUFFIX}${hfill}"
          clr_switch=""
        else
          if [[ $(whoami) == "root" ]]
          then
            all_info+="${E_NORMAL}${E_BOLD}${hfill}"
          else
            all_info+="${E_NORMAL}${hfill}"
          fi
          clr_switch=""
        fi
        prompt_env_right="${PROMPT_ENV_RIGHT}"
        prompt_env_left=""
      fi
    done
    if [[ ${hfill} == false ]]
    then
      clr_next_bg="${E_NORMAL}${CLR_PREFIX}${info_line_bg[$iSegment]/4/3}${CLR_SUFFIX}"
      clr_switch="${CLR_PREFIX}${info_line_clr_switch[$iSegment]}${CLR_SUFFIX}"
      clr_fg="${CLR_PREFIX}${info_line_fg[$iSegment]}${CLR_SUFFIX}"
      clr_bg="${CLR_PREFIX}${info_line_bg[$iSegment]}${CLR_SUFFIX}"
      prompt_right="${CLR_PREFIX}${info_line_clr_switch[$iSegment]}${CLR_SUFFIX}${prompt_env_right}"
      all_info+="${prompt_right}${clr_fg}${clr_bg} ${info} ${prompt_left}"
    fi
    echo -e "${all_info}${E_NORMAL}"
    return
  }

  local HOST=$(hostname)
  local UNICODE_SUPPORTED_TERM=("st" "terminator" "xterm")
  local TRUE_COLOR_TERM=("st" "terminator")

  if [ -f "${PROMPT_DIR}/hosts/common.sh" ]
  then
    # shellcheck disable=SC1090
    # SC1090: Can't follow non-constant source. Use a directive to specify
    #         location.
    source <(cat "${PROMPT_DIR}/hosts/common.sh")
  fi

  if [ -f "${PROMPT_DIR}/hosts/${HOST}.sh" ]
  then
    # shellcheck disable=SC1090
    # SC1090: Can't follow non-constant source. Use a directive to specify
    #         location.
    source <(cat "${PROMPT_DIR}/hosts/${HOST}.sh")
  fi

  # PROMPT VARIABLE THAT CAN BE OVERLOADED BY THE USER
  # ==========================================================================
  # Setting environment variable
  if [[ -z ${SEGMENT} ]]
  then
    local SEGMENT=(
      "tmux, pwd, hfill, keepass, whoami, hostname"
      "vcsh, virtualenv, vcs, kube, openstack, hfill"
    )
  fi
  if [[ -z ${SEGMENT_PRIORITY} ]]
  then
    local SEGMENT_PRIORITY=(
      "tmux, whoami, hostname, keepass, pwd"
      "vcsh, virtualenv, kube, openstack, vcs"
    )
  fi

  if [[ "${TRUE_COLOR_TERM[@]}" =~ ${SHELL_APP} ]]
  then
    case ${SHELL} in
      *bash)
        local CLR_PREFIX="\x1b["
        local CLR_SUFFIX="m"
        local BASE_CLR_PREFIX="\[\e["
        local BASE_CLR_SUFFIX="m\]"
        ;;
      *zsh)
        local CLR_PREFIX="%{\x1b["
        local CLR_SUFFIX="m%}"
        local BASE_CLR_PREFIX="%{\033["
        local BASE_CLR_SUFFIX="m%}"
        ;;
    esac
    local DEFAULT_CLR_FG="38;2;255;255;255"
    local DEFAULT_CLR_BG="48;2;0;0;0"
    local DEFAULT_NORMAL="0"
    local DEFAULT_BOLD="1"
  else
    case ${SHELL} in
      *bash)
        local CLR_PREFIX="\[\e["
        local CLR_SUFFIX="m\]"
        local BASE_CLR_PREFIX="\[\e["
        local BASE_CLR_SUFFIX="m\]"
        ;;
      *zsh)
        local CLR_PREFIX="%{\033["
        local CLR_SUFFIX="m%}"
        local BASE_CLR_PREFIX="%{\033["
        local BASE_CLR_SUFFIX="m%}"
    esac
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
#  local PROMPT_ENV_LEFT="${PROMPT_ENV_LEFT:- }"
#  local PROMPT_ENV_RIGHT="${PROMPT_ENV_RIGHT:- }"
  local PROMPT_ENV_LEFT="${PROMPT_ENV_LEFT:-""}"
  local PROMPT_ENV_RIGHT="${PROMPT_ENV_RIGHT:-""}"

  # Compute final prompt
  local final_prompt
  local idx_start_segment
  local idx_stop_segment
  case ${SHELL} in
    *bash)
      idx_start_segment=0
      idx_stop_segment=${#SEGMENT[@]}
      ;;
    *zsh)
      idx_start_segment=1
      idx_stop_segment=$(( ${#SEGMENT[@]} + 1 ))
      ;;
  esac
  debug "for (( idx=$(( ${idx_stop_segment} - 1 )); idx >= ${idx_start_segment} ; idx--))"
  for (( idx=$(( ${idx_stop_segment} - 1 )); idx >= ${idx_start_segment} ; idx--))
  do
    local start_info_line=$(date +%S%N)
    line="$(_prompt_info_line ${idx})"
    if [[ -n "${line}" ]]
    then
      final_prompt="${line}\n${final_prompt}"
    fi
  done

  # Compute end of final prompt  depending on the terminal
  case ${SHELL} in
    *bash)
      if [[ $(whoami) == "root" ]]
      then
        final_prompt+="$(echo -e " ${BOLD}${CLR_PREFIX}${RETURN_CODE_FG}${CLR_SUFFIX}\$? ↵ ${NORMAL}${BOLD}﬌ ")"
      else
        final_prompt+="$(echo -e " ${CLR_PREFIX}${RETURN_CODE_FG}${CLR_SUFFIX}\$? ↵ ${NORMAL}﬌ ")"
      fi
      export PS1=$(echo -e "${final_prompt}")
      ;;
    *zsh)
      if [[ $(whoami) == "root" ]]
      then
        zle_highlight=(default:bold)
      else
        zle_highlight=(default:normal)
      fi
      final_prompt+="$(echo -e "﬌ ")"
      export PROMPT=$(echo -e "${final_prompt}")
      export RPROMPT=$(echo -e "${CLR_PREFIX}${RETURN_CODE_FG}${CLR_SUFFIX}%(?..%? ↵)%{${E_NORMAL}%}")
      export SPROMPT=$(echo -e "Correct ${CLR_PREFIX}${CORRECT_WRONG_FG}${CLR_SUFFIX}%R%f to ${CLR_PREFIX}${CORRECT_RIGHT_FG}${CLR_SUFFIX}%r%f [nyae]? ")
  esac

  # Unset function to not be shown as autocompletion
  unset -f _prompt_printf
  unset -f _prompt_info_line
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
