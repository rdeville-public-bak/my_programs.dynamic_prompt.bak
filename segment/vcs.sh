#!/bin/bash

# Showing vcs info
local VCS_CHAR="${VCS_CHAR:-""}"
# Showing vcs info (such as git)
local VCS_COLORED="${VCS_COLORED:-false}"
# VCS Colors
local VCS_FG="${VCS_FG:-""}"
local VCS_BG="${VCS_BG:-""}"
local VCS_DETACHED_FG="${CLR_PREFIX}${VCS_DETACHED_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_TAG_FG="${CLR_PREFIX}${VCS_TAG_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_COMMIT_FG="${CLR_PREFIX}${VCS_COMMIT_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_BRANCH_FG="${CLR_PREFIX}${VCS_BRANCH_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_BEHIND_FG="${CLR_PREFIX}${VCS_BEHIND_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_AHEAD_FG="${CLR_PREFIX}${VCS_AHEAD_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_STASH_FG="${CLR_PREFIX}${VCS_STASH_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_UNTRACKED_FG="${CLR_PREFIX}${VCS_UNTRACKED_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_UNSTAGED_FG="${CLR_PREFIX}${VCS_UNSTAGED_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_STAGED_FG="${CLR_PREFIX}${VCS_STAGED_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_PROMPT_DIRTY_FG="${CLR_PREFIX}${VCS_PROMPT_DIRTY_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"
local VCS_PROMPT_CLEAN_FG="${CLR_PREFIX}${VCS_PROMPT_CLEAN_FG:-${DEFAULT_CLR_FG}}${CLR_SUFFIX}"

__vcs_determine_soft()
{
  if [ -f .git/HEAD ] && command -v git > /dev/null 2>&1
  then
    vcs="git"
  elif command -v git > /dev/null 2>&1 \
      && [ -n "$(git rev-parse --is-inside-work-tree 2> /dev/null)" ]
  then
    vcs="git"
  fi
  echo ${vcs}
}

_vcs_info()
{
  # Compute the vcs information (actually only support git)
  vcs="$(__vcs_determine_soft)"
  if [[ -n "${vcs}" ]]
  then
    vcs_cmd="_${vcs}_get_prompt_info"
    source <(cat ${SHELL_DIR}/lib/prompt/segment/vcs/${vcs}.sh)
    if command -v "${vcs_cmd}" > /dev/null 2>&1
    then
      vcs_info=$(${vcs_cmd} ${VCS_SHORT:-false} false)
    fi
  else
    vcs_info=""
  fi
  echo "${vcs_info}"
}

_vcs_info_short()
{
  echo "${VCS_CHAR}"
}

_vcs_info_clr()
{
  # Compute the vcs information (actually only support git)
  vcs="$(__vcs_determine_soft)"
  if [[ -n "${vcs}" ]]
  then
    vcs_cmd="_${vcs}_get_prompt_info"
    source <(cat ${SHELL_DIR}/lib/prompt/segment/vcs/${vcs}.sh)
    if command -v "${vcs_cmd}" > /dev/null 2>&1
    then
      vcs_info=$(${vcs_cmd} ${VCS_SHORT:-false} true)
    fi
  else
    vcs_info=""
  fi
  echo ${vcs_info}
}

# Setting array value
info_line[$iSegment]="$(_vcs_info)"
info_line_clr[$iSegment]="$(_vcs_info_clr)"
info_line_short[$iSegment]="$(_vcs_info_short)"
info_line_clr_short[$iSegment]="$(_vcs_info_short)"
info_line_fg[$iSegment]="${VCS_FG}"
info_line_bg[$iSegment]="${VCS_BG}"
info_line_clr_switch[$iSegment]="${VCS_BG/4/3}"

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
