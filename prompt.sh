#!/usr/bin/env sh
# *****************************************************************************
# File    : ~/.shellrc.d/lib/prompt.sh
# License : GNU General Public License v3.0
# Author  : Romain Deville <contact@romaindeville.fr>
# *****************************************************************************

# DESCRIPTION:
# =============================================================================
# Basic method to load and display the choosen version of my prompt.

# METHODS
# =============================================================================

export PROMPT_DIR="$(cd `dirname $0` && pwd)"

which_term(){
  # Method to determine which terminal emulator is used. Also set supported list
  # of terminal emulator that support unicode char.
  # Main resource come from :
  # https://askubuntu.com/questions/476641/how-can-i-get-the-name-of-the-current-terminal-from-command-line
  if who am i | grep tty &> /dev/null
  then
    term="tty"
  elif ! command -v xdotool &> /dev/null || ! xdotool getactivewindow &> /dev/null
  then
    term="unkown"
  else
    term=$(perl -lpe 's/\0/ /g' \
           /proc/$(xdotool getwindowpid $(xdotool getactivewindow))/cmdline)

    ## Enable extended globbing patterns
    #shopt -s extglob
    case $term in
        ## If this terminal is a python or perl program,
        ## then the emulator's name is likely the second
        ## part of it
        */python*|*/perl* )
         term=$(basename "$(readlink -f $(echo "$term" | cut -d ' ' -f 2))")
         ;;
        ## The special case of gnome-terminal
        *gnome-terminal-server* )
          term="gnome-terminal"
        ;;
        ## For other cases, just take the 1st
        ## field of $term
        * )
          term=${term/% */}
        ;;
    esac
  fi
  echo ${term}
}


# COLORING ECHO OUTPUT
# ==============================================================================
# Some exported variable I sometimes use in my script to echo information in
# colors. Base on only 8 colors to ensure portability of color when in tty
export E_NORMAL_FG="\e[38;5;15m"
export E_NORMAL_BG="\e[48;5;0m"
export E_NORMAL="\e[0m"
export E_BOLD="\e[1m"
export E_INFO="\e[0;38;5;2m"
export E_WARNING="\e[0;38;5;3m"
export E_ERROR="\e[0;38;5;1m"
export SHELL_APP="$(which_term)"
if [[ -n "${SHELL_APP}" ]] && [[ "${SHELL_APP}" == "tty" ]]
then
  # If terminal is tty, force V1 of prompt that is more readable when in TTY
  PROMPT_VERSION=1
fi

# Source the desired prompt. DEBUG_MODE var should be set automatically using
# direnv
if [[ -n ${DEBUG_MODE} ]] && [[ ${DEBUG_MODE} == true ]]
then
  echo "[LOG] Sourcing ${SHELL_DIR}/lib/prompt/debug.sh"
  source "${SHELL_DIR}/lib/prompt/debug.sh"
  echo "Sourcing ${SHELL_DIR}/lib/prompt/v${PROMPT_VERSION}_debug.sh"
  source "${SHELL_DIR}/lib/prompt/v${PROMPT_VERSION}_debug.sh"
else
  source "${SHELL_DIR}/lib/prompt/debug.sh"
  source "${SHELL_DIR}/lib/prompt/v${PROMPT_VERSION}.sh"
fi

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************