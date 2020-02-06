#!/usr/bin/env bash
#*******************************************************************************
# File    : ~/.shell/hosts/common.sh
# License : GNU General Public License v3.0
# Author  : Romain Deville <contact@romaindeville.fr>
#*******************************************************************************

# DESCRIPTION:
# =============================================================================
# Setup colors and boolean common for all my workstation, define a base
# coloring. Then, I update only needed value in $(hostname).sh file next to this
# file.

local SEGMENT=(
  "tmux, pwd, hfill, keepass, username, hostname"
  "vcsh, virtualenv, vcs, hfill, kube, openstack"
)

local SEGMENT_PRIORITY=(
  "tmux, username, hostname, keepass, pwd"
  "vcsh, virtualenv, kube, openstack, vcs"
)

# CHARACTER ENVIRONMENT SETUP
# =============================================================================
# Check if terminal emulator support unicode char or glyphs.
if [[ -z "${SHELL_APP}" ]] || ! [[ "${UNICODE_SUPPORTED_TERM[@]}" =~ ${SHELL_APP} ]]
then
  # Prompt that does not support glyphs or unicode char
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    local PROMPT_ENV_LEFT="["     # v2 Default " " | v1 Default "]"
    local PROMPT_ENV_RIGHT="]"    # v2 Default " " | v1 Default "["
  else
    local PROMPT_ENV_LEFT=" "     # v2 Default " " | v1 Default "]"
    local PROMPT_ENV_RIGHT=" "    # v2 Default " " | v1 Default "["
  fi
  local KEEPASS_CHAR="K|"         # Default " "
  local TMUX_CHAR="T|"            # Default " "
  local VCSH_CHAR="V|"            # Default " "
  local VCS_CHAR="G|"            # Default " "
  local KUBE_CHAR="K|"            # Default "⎈ "
  local OPENSTACK_CHAR="O|"       # Default " "
  local VIRTUALENV_CHAR="P|"      # Default " "
  local PWD_CHAR="·"              # Default " "
  local USER_CHAR="_"             # Default " "
  local HOSTNAME_CHAR="@"         # Default " "
  # GIT RELATED VARIABLE (VCS RELATED)
  # ===========================================================================
  local GIT_PROMPT_DIRTY="X"      # Default "✗"
  local GIT_PROMPT_CLEAN="V"      # Default "✓"
  local GIT_BRANCH_PREFIX="-|-"   # Default ""
  local GIT_TAG_PREFIX="T ["      # Default "笠["
  local GIT_TAG_SUFFIX="]"        # Default "]"
  local GIT_DETACHED_PREFIX="D [" # Default " ["
  local GIT_DETACHED_SUFFIX="]"   # Default "]"
  local GIT_CHAR="¤"             # Default ""
  local GIT_AHEAD_CHAR="↑"        # Default "ﰵ"
  local GIT_BEHIND_CHAR="↓"       # Default "ﰬ"
  local GIT_UNTRACKED_CHAR="?"    # Default ""
  local GIT_UNSTAGED_CHAR="-"     # Default ""
  local GIT_STAGED_CHAR="+"       # Default ""
  local GIT_STASH_CHAR_PREFIX="{" # Default "{"
  local GIT_STASH_CHAR_SUFFIX="}" # Default "}"
else
  # terminal emulator that support unicode and glyphs char
  local PWD_CHAR=" "             # Default " "
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    local PROMPT_ENV_LEFT="["     # v2 Default " " | v1 Default "]"
    local PROMPT_ENV_RIGHT="]"    # v2 Default " " | v1 Default "["
  else
    local PROMPT_ENV_LEFT=" "    # v2 Default " " | v1 Default "]"
    local PROMPT_ENV_RIGHT=" "   # v2 Default " " | v1 Default "["
  fi
  local KEEPASS_CHAR=" "         # Default " "
  local TMUX_CHAR=" "            # Default " "
  local KUBE_CHAR="⎈ "            # Default "⎈ "
  local OPENSTACK_CHAR=" "       # Default " "
  local VIRTUALENV_CHAR=" "      # Default " "
  local PWD_CHAR=" "             # Default " "
  local USER_CHAR=" "            # Default " "
  local HOSTNAME_CHAR=" "        # Default " "
  # GIT RELATED VARIABLE (VCS RELATED)
  # ==============================================================================
  local GIT_PROMPT_DIRTY="✗"      # Default "✗"
  local GIT_PROMPT_CLEAN="✓"      # Default "✓"
  local GIT_BRANCH_PREFIX=""     # Default ""
  local GIT_TAG_PREFIX="笠["      # Default "笠["
  local GIT_TAG_SUFFIX="]"        # Default "]"
  local GIT_DETACHED_PREFIX=" [" # Default " ["
  local GIT_DETACHED_SUFFIX="]"   # Default "]"
  local GIT_CHAR=""              # Default ""
  local GIT_AHEAD_CHAR="ﰵ"        # Default "ﰵ"
  local GIT_BEHIND_CHAR="ﰬ"       # Default "ﰬ"
  local GIT_UNTRACKED_CHAR=""    # Default ""
  local GIT_UNSTAGED_CHAR=""     # Default ""
  local GIT_STAGED_CHAR=""       # Default ""
  local GIT_STASH_CHAR_PREFIX="{" # Default "{"
  local GIT_STASH_CHAR_SUFFIX="}" # Default "}"
fi

# ENVIRONMENT INFORMATION
# =============================================================================
# Environment information to show
local VCS_CHAR=${GIT_CHAR}        # Default ""

# COLOR SETUP
# =============================================================================
# COLOR SYNTAX
# ---------------------------------------------------------------------------
# Syntax for terminal that support up to 16 colors or up to 256 colors:
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
# To know if your terminal support true colors (i.e. 24 bits colors), and the
# syntax to use:
# https://gist.github.com/XVilka/8346728
#
# FOR THE COLOR CODE, AS SHOWN BELOW, JUST ENTER THE CODE, DO NOT ENTER PREFIX:
# Color          | 16 colors | 256 colors | True colors    | Wrong values
# ---------------+-----------+------------+----------------+----------------------------
# Red Foreground | 31        | 38;2;196   | 38;2;255;0;0;0 | \e[31m
# Red Background | 41        | 48;2;196   | 48;2;255;0;0;0 | \e[41m
# etc
#
# Set of 256 hexadecimal colors supported by 256 colors terminal are shown at
# the end of this file.

# Check what kind of terminal we are in.
if [[ "${TRUE_COLOR_TERM[@]}" =~ ${SHELL_APP} ]]
then
  # If terminal emulator is know to support true colors
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    local DEFAULT_FG="38;2;255;255;255"     #rgb(255,255,255)
    local DEFAULT_BG="48;2;95;0;0"          #rgb(95,0,0)
    local RETURN_CODE_FG="38;2;200;0;0"     #rgb(200,0,0)
    local CORRECT_WRONG_FG="38;2;200;0;0"   #rgb(200,0,0)
    local CORRECT_RIGHT_FG="38;2;0;200;0"   #rgb(0,200,0)
    local PWD_FG="38;2;225;225;225"         #rgb(225,225,225)
    local USER_FG="38;2;0;135;0"            #rgb(0,135,0)
    local HOSTNAME_FG="38;2;175;135;0"      #rgb(175,135,0)
    local KEEPASS_FG="38;2;0;95;95"         #rgb(0,95,95)
    local TMUX_FG="38;2;0;95;135"           #rgb(0,95,135)
    local VCSH_FG="38;2;0;95;95"            #rgb(0,95,95)
    local VIRTUALENV_FG="38;2;95;135;0"     #rgb(95,135,0)
    local KUBE_FG="38;2;0;135;255"          #rgb(0,135,255)
    local OPENSTACK_FG="38;2;135;0;0"       #rgb(135,0,0)
    local VCS_FG="38;2;135;0;0"             #rgb(135,0,0)
  else
    local DEFAULT_FG="38;2;0;0;0"           #rgb(0,0,0)
    local DEFAULT_BG="48;2;95;0;0"          #rgb(95,0,0)
    local RETURN_CODE_FG="38;2;200;0;0"     #rgb(200,0,0)
    local CORRECT_WRONG_FG="38;2;200;0;0"   #rgb(200,0,0)
    local CORRECT_RIGHT_FG="38;2;0;200;0"   #rgb(0,200,0)
    local PWD_FG="38;2;225;225;225"         #rgb(225,225,225)
    local PWD_BG="48;2;25;25;25"            #rgb(25,25,25)
    local USER_FG="38;2;0;0;0"              #rgb(0,0,0)
    local USER_BG="48;2;95;135;0"           #rgb(95,135,0)
    local HOSTNAME_FG="38;2;0;0;0"          #rgb(0,0,0)
    local HOSTNAME_BG="48;2;175;135;0"      #rgb(175,135,0)
    local KEEPASS_FG="38;2;255;255;255"     #rgb(255,255,255)
    local KEEPASS_BG="48;2;0;95;95"         #rgb(0,95,95)
    local TMUX_FG="38;2;0;0;0"              #rgb(0,0,0)
    local TMUX_BG="48;2;0;95;135"           #rgb(0,95,135)
    local VCSH_FG="38;2;0;0;0"              #rgb(0,0,0)
    local VCSH_BG="48;2;0;95;95"            #rgb(0,95,95)
    local VIRTUALENV_FG="38;2;0;0;0"        #rgb(0,0,0)
    local VIRTUALENV_BG="48;2;95;135;0"     #rgb(95,135,0)
    local KUBE_FG="38;2;255;255;255"        #rgb(255,255,255)
    local KUBE_BG="48;2;0;135;255"          #rgb(0,135,255)
    local OPENSTACK_FG="38;2;255;255;255"   #rgb(255,255,255)
    local OPENSTACK_BG="48;2;135;0;0"       #rgb(135,0,0)
    local VCS_FG="38;2;95;0;0"              #rgb(95,0,0)
    local VCS_BG="48;2;30;30;30"            #rgb(30,30,30)
  fi
  local VCS_PROMPT_DIRTY_FG="38;2;135;0;0"  #rgb(135,0,0)
  local VCS_PROMPT_CLEAN_FG="38;2;0;135;0"  #rgb(0,135,0)
  local VCS_BRANCH_FG="38;2;0;95;135"       #rgb(0,95,135)
  local VCS_TAG_FG="38;2;95;0;0"            #rgb(95,0,0)
  local VCS_DETACHED_FG="38;2;92;0;0"       #rgb(95,0,0)
  local VCS_COMMIT_FG="38;2;0;95;135"       #rgb(0,95,135)
  local VCS_AHEAD_FG="38;2;0;135;0"         #rgb(0,135,0)
  local VCS_BEHIND_FG="38;2;95;0;0"         #rgb(95,0,0)
  local VCS_UNTRACKED_FG="38;2;135;135;135" #rgb(135,135,135)
  local VCS_UNSTAGED_FG="38;2;135;95;0"     #rgb(135,95,0)
  local VCS_STAGED_FG="38;2;0;95;0"         #rgb(0,95,0)
  local VCS_STASH_FG="38;2;95;0;95"         #rgb(95,0,95)
elif ([[ "${SHELL_APP}" != "unkown" ]] && [[ "${SHELL_APP}" != "tty" ]]) && \
  [[ "$(tput colors)" -eq 256 ]]
then
  # If terminal support 256 colors and is not unkown or tty
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    # Prompt colors that support only 256
    local DEFAULT_FG="38;5;231"       #ffffff
    local DEFAULT_BG="48;5;52"        #5f0000
    local RETURN_CODE_FG="38;5;124"   #af0000
    local CORRECT_WRONG_FG="38;5;124" #af0000
    local CORRECT_RIGHT_FG="38;5;34"  #00af00
    local PWD_FG="38;5;254"           #e4e4e4
    local USER_FG="38;5;64"           #5f8700
    local HOSTNAME_FG="38;5;136"      #af8700
    local KEEPASS_FG="38;5;23"        #005f5f
    local TMUX_FG="38;5;29"           #00875f
    local VCSH_FG="38;5;30"           #008787
    local VIRTUALENV_FG="38;5;106"    #87af00
    local KUBE_FG="38;5;33"           #0087ff
    local OPENSTACK_FG="38;5;160"     #d70000
    # Set VCS colors
    local VCS_FG="38;5;52"            #5f0000
  else
    local DEFAULT_BG="48;5;52"        #5f0000
    local DEFAULT_FG="38;5;231"       #ffffff
    local RETURN_CODE_FG="38;5;124"   #af0000
    local CORRECT_WRONG_FG="38;5;124" #af0000
    local CORRECT_RIGHT_FG="38;5;34"  #00af00
    local PWD_FG="38;5;254"           #e4e4e4
    local PWD_BG="48;5;234"           #1c1c1c
    local USER_FG="38;5;16"           #000000
    local USER_BG="48;5;64"           #5f8700
    local HOSTNAME_FG="38;5;16"       #000000
    local HOSTNAME_BG="48;5;136"      #af8700
    local KEEPASS_FG="38;5;231"       #ffffff
    local KEEPASS_BG="48;5;23"        #005f5f
    local TMUX_FG="38;5;16"           #000000
    local TMUX_BG="48;5;39"           #00875f
    local VCSH_FG="38;5;16"           #000000
    local VCSH_BG="48;5;30"           #008787
    local VIRTUALENV_FG="38;5;16"     #000000
    local VIRTUALENV_BG="48;5;106"    #87af00
    local KUBE_FG="38;5;16"           #000000
    local KUBE_BG="48;5;33"           #0087ff
    local OPENSTACK_FG="38;5;231"     #000000
    local OPENSTACK_BG="48;5;160"     #d70000
    # Set VCS colors
    local VCS_FG="38;5;52"            #5f0000
    local VCS_BG="48;5;236"           #303030
  fi
  local VCS_PROMPT_DIRTY_FG="38;5;52" #5f0000
  local VCS_PROMPT_CLEAN_FG="38;5;22" #005f00
  local VCS_BRANCH_FG="38;5;24"       #005f87
  local VCS_TAG_FG="38;5;52"          #5f0000
  local VCS_DETACHED_FG="38;5;52"     #5f0000
  local VCS_COMMIT_FG="38;5;24"       #005f87
  local VCS_AHEAD_FG="38;5;22"        #005f00
  local VCS_BEHIND_FG="38;5;52"       #5f0000
  local VCS_UNTRACKED_FG="38;5;255"   #eeeeee
  local VCS_UNSTAGED_FG="38;5;136"    #af8700
  local VCS_STAGED_FG="38;5;22"       #005f00
  local VCS_STASH_FG="38;5;52"        #5f005f
elif [[ -z "${SHELL_APP}" ]] || [[ "${SHELL_APP}" == "unkown" ]] \
  || [[ "${SHELL_APP}" == "tty" ]] || [[ $(tput colors) -eq 16 ]]
then
  # Default case, shell support a maximum to 16 color or shell_app is unkown or
  # tty
  # Fallback case to ensure working coloration
  if [[ ${PROMPT_VERSION} -eq 1 ]]
  then
    local DEFAULT_FG="39"         # Default foreground term color (White)
    local DEFAULT_BG="41"         # Red background
    local RETURN_CODE_FG="31"     # Red foreground
    local CORRECT_WRONG_FG="31"   # Red foreground
    local CORRECT_RIGHT_FG="32"   # Green foreground
    local PWD_FG="39"             # Default foreground term color (White)
    local KEEPASS_FG="39"         # Default foreground term color (White)
    local USER_FG="32"            # Green foreground
    local HOSTNAME_FG="33"        # Yellow foreground
    local TMUX_FG="94"            # Light Blue foreground
    local VCSH_FG="94"            # Light Blue foreground
    local VIRTUALENV_FG="32"      # Green foreground
    local KUBE_FG="34"            # Cyan foreground
    local OPENSTACK_FG="91"       # Light Red foreground
    # Set VCS colors
    local VCS_FG="31"             # Red foreground
  else
    local DEFAULT_FG="39"         # Default foreground term color (White)
    local DEFAULT_BG="41"         # Red background
    local RETURN_CODE_FG="31"     # Red foreground
    local CORRECT_WRONG_FG="31"   # Red foreground
    local CORRECT_RIGHT_FG="32"   # Green foreground
    local PWD_FG="39"             # Default foreground term color (White)
    local PWD_BG="40"             # Black background
    local KEEPASS_BG="44"         # Blue background
    local KEEPASS_FG="39"         # Default foreground term color (White)
    local USER_BG="42"            # Green background
    local USER_FG="30"            # Black foreground
    local HOSTNAME_BG="43"        # Yellow background
    local HOSTNAME_FG="30"        # Black foreground
    local TMUX_BG="44"           # Light Blue background
    local TMUX_FG="30"            # Black foreground
    local VCSH_BG="44"           # Light Blue background
    local VCSH_FG="30"            # Black foreground
    local VIRTUALENV_BG="42"      # Green background
    local VIRTUALENV_FG="30"      # Black foreground
    local KUBE_BG="44"            # Cyan background
    local KUBE_FG="39"            # Default foreground term color (White)
    local OPENSTACK_BG="41"       # Red background
    local OPENSTACK_FG="39"       #  Default foreground term color (White)
    # Set VCS colors
    local VCS_BG="40"             # Black background
    local VCS_FG="31"             # Red foreground
  fi
  local VCS_PROMPT_DIRTY_FG="31"  # Red foreground
  local VCS_PROMPT_CLEAN_FG="32"  # Green foreground
  local VCS_BRANCH_FG="34"        # Blue foreground
  local VCS_TAG_FG="33"           # Yellow foreground
  local VCS_DETACHED_FG="31"      # Red foreground
  local VCS_COMMIT_FG="34"        # Blue foreground
  local VCS_AHEAD_FG="32"         # Green foreground
  local VCS_BEHIND_FG="31"        # Red foreground
  local VCS_UNTRACKED_FG="39"     # White foreground
  local VCS_UNSTAGED_FG="33"      # Yellow foreground
  local VCS_STAGED_FG="34"        # Blue foreground
  local VCS_STASH_FG="35"         # Magenta foreground
fi

# COLORING ECHO OUTPUT
# ==============================================================================
# Some exported variable I sometimes use in my script to echo information in
# colors. Base on only 8 colors to ensure portability of color when in tty
export E_NORMAL="\e[0m"
export E_BOLD="\e[1m"
export E_INFO="\e[0;38;5;2m"
export E_WARNING="\e[0;38;5;3m"
export E_ERROR="\e[0;38;5;1m"

# Equivalent hexadecimal color for each code value for the 256 colors when term
# support it.
# Usefull when using vim-plugin colorizer or any plugin show hex colors
# =============================================================================
              # 016 #000000 # 017 #00005f # 018 #000087 # 019 #0000af
# 020 #0000d7 # 021 #0000ff # 022 #005f00 # 023 #005f5f # 024 #005f87
# 025 #005faf # 026 #005fd7 # 027 #005fff # 028 #008700 # 029 #00875f
# 030 #008787 # 031 #0087af # 032 #0087d7 # 033 #0087ff # 034 #00af00
# 035 #00af5f # 036 #00af87 # 037 #00afaf # 038 #00afd7 # 039 #00afff
# 040 #00d700 # 041 #00d75f # 042 #00d787 # 043 #00d7af # 044 #00d7d7
# 045 #00d7ff # 046 #00ff00 # 047 #00ff5f # 048 #00ff87 # 049 #00ffaf
# 050 #00ffd7 # 051 #00ffff # 052 #5f0000 # 053 #5f005f # 054 #5f0087
# 055 #5f00af # 056 #5f00d7 # 057 #5f00ff # 058 #5f5f00 # 059 #5f5f5f
# 060 #5f5f87 # 061 #5f5faf # 062 #5f5fd7 # 063 #5f5fff # 064 #5f8700
# 065 #5f875f # 066 #5f8787 # 067 #5f87af # 068 #5f87d7 # 069 #5f87ff
# 070 #5faf00 # 071 #5faf5f # 072 #5faf87 # 073 #5fafaf # 074 #5fafd7
# 075 #5fafff # 076 #5fd700 # 077 #5fd75f # 078 #5fd787 # 079 #5fd7af
# 080 #5fd7d7 # 081 #5fd7ff # à82 #5fff00 # 083 #5fff5f # 084 #5fff87
# 085 #5fffaf # 086 #5fffd7 # 087 #5fffff # 088 #870000 # 089 #87005f
# 090 #870087 # 091 #8700af # 092 #8700d7 # 093 #8700ff # 094 #875f00
# 095 #875f5f # 096 #875f87 # 097 #875faf # 098 #875fd7 # 099 #875fff
# 100 #878700 # 101 #87875f # 102 #878787 # 103 #8787af # 104 #8787d7
# 105 #8787ff # 106 #87af00 # 107 #87af5f # 108 #87af87 # 109 #87afaf
# 110 #87afd7 # 111 #87afff # 112 #87d700 # 113 #87d75f # 114 #87d787
# 115 #87d7af # 116 #87d7d7 # 117 #87d7ff # 118 #87ff00 # 119 #87ff5f
# 120 #87ff87 # 121 #87ffaf # 122 #87ffd7 # 123 #87ffff # 124 #af0000
# 125 #af005f # 126 #af0087 # 127 #af00af # 128 #af00d7 # 129 #af00ff
# 130 #af5f00 # 131 #af5f5f # 132 #af5f87 # 133 #af5faf # 134 #af5fd7
# 135 #af5fff # 136 #af8700 # 137 #af875f # 138 #af8787 # 139 #af87af
# 140 #af87d7 # 141 #af87ff # 142 #afaf00 # 143 #afaf5f # 144 #afaf87
# 145 #afafaf # 146 #afafd7 # 147 #afafff # 148 #afd700 # 149 #afd75f
# 150 #afd787 # 151 #afd7af # 152 #afd7d7 # 153 #afd7ff # 154 #afff00
# 155 #afff5f # 156 #afff87 # 157 #afffaf # 158 #afffd7 # 159 #afffff
# 160 #d70000 # 161 #d7005f # 162 #d70087 # 163 #d700af # 164 #d700d7
# 165 #d700ff # 166 #d75f00 # 167 #d75f5f # 168 #d75f87 # 169 #d75faf
# 170 #d75fd7 # 171 #d75fff # 172 #d78700 # 173 #d7875f # 174 #d78787
# 175 #d787af # 176 #d787d7 # 177 #d787ff # 178 #d7af00 # 179 #d7af5f
# 180 #d7af87 # 181 #d7afaf # 182 #d7afd7 # 183 #d7afff # 184 #d7d700
# 185 #d7d75f # 186 #d7d787 # 187 #d7d7af # 188 #d7d7d7 # 189 #d7d7ff
# 190 #d7ff00 # 191 #d7ff5f # 192 #d7ff87 # 193 #d7ffaf # 194 #d7ffd7
# 195 #d7ffff # 196 #ff0000 # 197 #ff005f # 198 #ff0087 # 199 #ff00af
# 200 #ff00d7 # 201 #ff00ff # 202 #ff5f00 # 203 #ff5f5f # 204 #ff5f87
# 205 #ff5faf # 206 #ff5fd7 # 207 #ff5fff # 208 #ff8700 # 209 #ff875f
# 210 #ff8787 # 211 #ff87af # 212 #ff87d7 # 213 #ff87ff # 214 #ffaf00
# 215 #ffaf5f # 216 #ffaf87 # 217 #ffafaf # 218 #ffafd7 # 219 #ffafff
# 220 #ffd700 # 221 #ffd75f # 222 #ffd787 # 223 #ffd7af # 224 #ffd7d7
# 225 #ffd7ff # 226 #ffff00 # 227 #ffff5f # 228 #ffff87 # 229 #ffffaf
# 230 #ffffd7 # 231 #ffffff # 232 #080808 # 233 #121212 # 234 #1c1c1c
# 235 #262626 # 236 #303030 # 237 #3a3a3a # 238 #444444 # 239 #4e4e4e
# 240 #585858 # 241 #626262 # 242 #6c6c6c # 243 #767676 # 244 #808080
# 245 #8a8a8a # 246 #949494 # 247 #9e9e9e # 248 #a8a8a8 # 249 #b2b2b2
# 250 #bcbcbc # 251 #c6c6c6 # 252 #d0d0d0 # 253 #dadada # 254 #e4e4e4
# 255 #eeeeee

# ******************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# ******************************************************************************