#!/bin/bash
# *****************************************************************************
# File    : prompt_var.sh
# License : GNU General Public License v3.0
# Author  : Romain Deville <contact@romaindeville.fr>
# *****************************************************************************

# DESCRIPTION:
# =============================================================================
# Setup some variables used in common.example.sh, v1.sh and v2.sh to check if
# terminal emulator support unicode characters and true colors

local HOST=$(hostname)
local UNICODE_SUPPORTED_TERM=("st" "terminator" "xterm" "iTerm.app")
local TRUE_COLOR_TERM=("st" "terminator" "iTerm.app")

