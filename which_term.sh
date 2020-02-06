#!/bin/bash

which_term () {
  local term
  if who am i | grep tty &> /dev/null
  then
    term="tty"
  elif ! command -v xdotool &> /dev/null || ! xdotool getactivewindow &> /dev/null
  then
    term="unkown"
  else
    term=$(perl -lpe 's/\0/ /g' \
      /proc/$(xdotool getwindowpid $(xdotool getactivewindow))/cmdline)
    case ${term} in
      (*/python* | */perl*) term=$(basename "$(readlink -f $(echo "${term}" | cut -d ' ' -f 2))")  ;;
      (*gnome-terminal-server*) term="gnome-terminal"  ;;
      (*) term=${term/% */}  ;;
    esac
  fi
  echo ${term}
}

which_term
# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
