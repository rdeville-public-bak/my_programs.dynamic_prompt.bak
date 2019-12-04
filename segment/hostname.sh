#!/bin/bash

# Showing hostname info
local HOSTNAME_CHAR="${HOSTNAME_CHAR:-" "}"
local HOSTNAME_FG="${HOSTNAME_FG:-""}"
local HOSTNAME_BG="${HOSTNAME_BG:-""}"

# Setting array value
info_line[$iSegment]="${HOSTNAME_CHAR}$(hostname)"
info_line_clr[$iSegment]="${HOSTNAME_CHAR}$(hostname)"
info_line_short[$iSegment]="${HOSTNAME_CHAR}"
info_line_clr_short[$iSegment]="${HOSTNAME_CHAR}"
info_line_fg[$iSegment]="${HOSTNAME_FG}"
info_line_bg[$iSegment]="${HOSTNAME_BG}"
info_line_clr_switch[$iSegment]="${HOSTNAME_BG/4/3}"

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
