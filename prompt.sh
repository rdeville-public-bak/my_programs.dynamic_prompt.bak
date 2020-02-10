#!/usr/bin/env bash
# *****************************************************************************
# License : GNU General Public License v3.0
# Author  : Romain Deville <contact@romaindeville.fr>
# *****************************************************************************

# DESCRIPTION:
# =============================================================================
# Basic method to load and display the choosen version of my prompt.

# METHODS
# =============================================================================
which_term(){
  # Method to determine which terminal emulator is used.
  # Also set supported list of terminal emulator that support unicode char.
  # Main resource come from :
  # https://askubuntu.com/questions/476641/how-can-i-get-the-name-of-the-current-terminal-from-command-line
  local term  
  if who am i | grep tty &> /dev/null && [ "$(uname)" != Darwin ]
  then
    term="tty"
  elif [[ "${TERM_PROGRAM}" == "iTerm.app" ]]
  then
    term=st # plutot ajouter un terminal dans v1.sh / v2.sh
  elif ! command -v xdotool &> /dev/null || ! xdotool getactivewindow &> /dev/null
  then
    term="unkown"
  else
    term=$(perl -lpe 's/\0/ /g' \
           /proc/$(xdotool getwindowpid $(xdotool getactivewindow))/cmdline)
    case ${term} in
        # If this terminal is a python or perl program,  then the emulator's
        # name is likely the second part of it
        */python*|*/perl* )
         term=$(basename "$(readlink -f $(echo "${term}" | cut -d ' ' -f 2))")
         ;;
        # The special case of gnome-terminal
        *gnome-terminal-server* )
          term="gnome-terminal"
        ;;
        # For other cases, just take the 1st field of $term
        * )
          term=${term/% */}
        ;;
    esac
  fi
  echo ${term}
}

debug()
{
  # Method used when debugging script, can take 2 arguments,
  # $1 : String of message to print
  # $2 : Integer, usually used for time in ms
  if [[ -n "${DEBUG_MODE}" ]] && [[ ${DEBUG_MODE} == true ]]
  then
    case ${SHELL} in
      *bash)
        # In bash, sometimes, integers start with leading zero, leading to error
        # like "bash value too great for base (error token is "08" )"
        # In this case, integer are interpreting by bash as octal and not
        # decimal. Following line force bash to interpret integer in decimal.
        # https://stackoverflow.com/questions/24777597/value-too-great-for-base-error-token-is-08
        echo -e "[LOG] $1 ${10#2}" >> ${PROMPT_DIR}/prompt.log
        ;;
      *zsh)
        echo -e "[LOG] $1 $2" >> ${PROMPT_DIR}/prompt.log
        ;;
    esac
  fi
}


# COLORING ECHO OUTPUT
# ==============================================================================
# Some exported variable I sometimes use in my script to echo informations in
# colors. Base on only 8 colors to ensure portability of color when in tty
export E_NORMAL="\e[0m"   # Normal (white fg & transparent bg)
export E_BOLD="\e[1m"     # Bold
export E_ITALiC="\e[3m"   # Italic
export E_UNDER="\e[4m"    # Underline
export E_INFO="\e[32m"    # Green fg
export E_WARNING="\e[33m" # Yellow fg
export E_ERROR="\e[31m"   # Red fg

if [[ -n "${SHELL_APP}" ]]
then
  export SHELL_APP="${SHELL_APP}"
else
  export SHELL_APP="$(which_term)"
fi

# Determine prompt to load
if [[ -z "${SHELL_APP}" ]] \
  || [[ "${SHELL_APP}" == "tty" ]] \
  || [[ "${SHELL_APP}" == "unkown" ]]
then
  # If terminal is tty or unkonwn, force V1 of prompt that is more readable when
  # in TTY
  PROMPT_VERSION=1
fi

# Load the desired prompt.
source "${PROMPT_DIR}/v${PROMPT_VERSION}.sh"

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
