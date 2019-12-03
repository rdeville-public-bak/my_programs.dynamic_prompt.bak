#!/usr/bin/env sh
# *****************************************************************************
# File    : ~/.shellrc.d/lib/git.sh
# License : GNU General Public License v3.0
# Author  : Romain Deville <contact@romaindeville.fr>
# *****************************************************************************

# DESCRIPTION:
# =============================================================================
# Basic method for my shell prompt to git status

# METHODS =====================================================================
_git_get_prompt_info()
{
  _git_get_symbolic_ref()
  {
    # Get symbolic ref
    git symbolic-ref -q HEAD 2> /dev/null
    return
  }

  _git_get_tag()
  {
    # Get tags that contains commit
    git describe --tags --exact-match 2> /dev/null
    return
  }

  _git_get_commit_description()
  {
    # Get the branch that contains the commit
    git describe --contains --all 2> /dev/null
    return
  }

  _git_get_short_sha()
  {
    # Get short SHA
    git rev-parse --short HEAD
    return
  }

  _git_get_friendly_ref()
  {
    # Get commit reference in a friendly name
    # Try the checked-out branch first to avoid collision with branches pointing
    # to the same ref.
    _git_get_branch || _git_get_tag || _git_get_commit_description || _git_get_short_sha
    return
  }

  _git_get_upstream()
  {
    # Get upgstream of repo
    local ref
    ref="$(_git_get_symbolic_ref)" || return 1
    git for-each-ref --format="%(upstream:short)" "${ref}"
    return
  }

  _git_get_upstream_behind_ahead()
  {
    # Get if the current branch is behind or above HEAD
    git rev-list --left-right --count "origin/$(_git_get_branch)...$(_git_get_branch)" 2> /dev/null
    return
  }

  _git_get_branch()
  {
    # Get the current branch name
    git symbolic-ref -q --short HEAD 2> /dev/null || return 1
    return
  }

  _git_get_status()
  {
    # Get the information about files, i.e. untracked, tracked and unstaged
    # files.
    local git_status_flags=
    if [[ "${GIT_IGNORE_UNTRACKED}" == "true" ]]
    then
      git_status_flags='-uno'
    fi
    git status --porcelain ${git_status_flags} 2> /dev/null
    return
  }

  _git_get_status_counts()
  {
    # Parse output of method _git_get_status to print only number of tracker,
    # untracked and unstaged files
    _git_get_status | awk '
    BEGIN {
      untracked=0;
      unstaged=0;
      staged=0;
    }
    {
      if ($0 ~ /^\?\? .+/) {
        untracked += 1
      } else {
        if ($0 ~ /^.[^ ] .+/) {
          unstaged += 1
        }
        if ($0 ~ /^[^ ]. .+/) {
          staged += 1
        }
      }
    }
    END {
      print unstaged "\t" staged "\t" untracked
    }'
    return
  }

  _git_set_vars()
  {
    # Set git variable and compute the git info line using method above
    local short=$1
    local colored=$2
    local detached_prefix
    local detached_suffix
    local git_commit
    local git_branch
    local git_ahead
    local git_behind
    local untracked_count
    local unstaged_count
    local staged_count
    local stash_count
    local git_info
    local git_state

    git_commit="$(_git_get_short_sha)"
    git_branch="${GIT_BRANCH_PREFIX}$(_git_get_friendly_ref)"
    if ! _git_get_branch &> /dev/null
    then
      if _git_get_tag &> /dev/null; then
        detached_prefix="${GIT_TAG_PREFIX}"
        detached_suffix="${GIT_TAG_SUFFIX}"
      else
        detached_prefix="${GIT_DETACHED_PREFIX}"
        detached_suffix="${GIT_DETACHED_SUFFIX}"
      fi
    else
      detached_prefix=""
      detached_suffix=""
    fi

    IFS=$'\t' read -r commits_behind commits_ahead <<< "$(_git_get_upstream_behind_ahead)"
    if [[ "${commits_ahead}" -gt 0 ]]
    then
      git_ahead=" ${GIT_AHEAD_CHAR}${commits_ahead}"
    fi

    if [[ "${commits_behind}" -gt 0 ]]
    then
      git_behind=" ${GIT_BEHIND_CHAR}${commits_behind}"
    fi

    stash_count="$(git stash list 2> /dev/null | wc -l | tr -d ' ')"
    if [[ "${stash_count}" -gt 0 ]]
    then
      stash_count="${GIT_STASH_CHAR_PREFIX}${stash_count}${GIT_STASH_CHAR_SUFFIX}"
    else
      stash_count=""
    fi

    git_state=${GIT_PROMPT_CLEAN}
    IFS=$'\t' read -r unstaged_count staged_count untracked_count <<< "$(_git_get_status_counts)"
    if [[ "${staged_count}" -gt 0 ]]
    then
      staged_count=" ${GIT_STAGED_CHAR}${staged_count}"
      git_state=${GIT_PROMPT_DIRTY}
    else
      staged_count=""
    fi
    if [[ "${unstaged_count}" -gt 0 ]]
    then
      unstaged_count=" ${GIT_UNSTAGED_CHAR}${unstaged_count}"
      git_state=${GIT_PROMPT_DIRTY}
    else
      unstaged_count=""
    fi
    if [[ "${GIT_IGNORE_UNTRACKED}" == "false" ]] \
        && [[ "${untracked_count}" -gt 0 ]]
    then
      untracked_count=" ${GIT_UNTRACKED_CHAR}${untracked_count}"
      git_state=${GIT_PROMPT_DIRTY}
    else
      untracked_count=""
    fi

    if [[ ${colored} == "false" ]]
    then
      git_info="${GIT_CHAR}"
      if [[ ${short} == "false" ]]
      then
        git_info+=" ${detached_prefix}"
        git_info+="${git_commit} "
        git_info+="${git_branch}"
        git_info+="${detached_suffix}"
      fi
      git_info+="${git_behind}"
      git_info+="${git_ahead}"
      git_info+="${stash_count}"
      git_info+="${untracked_count}"
      git_info+="${unstaged_count}"
      git_info+="${staged_count}"
      git_info+=" ${git_state}"
    else
      git_info="${CLR_PREFIX}${VCS_FG}${CLR_SUFFIX}${GIT_CHAR}"
      if [[ ${short} == "false" ]]
      then
        git_info+=" ${VCS_DETACHED_FG}${detached_prefix}"
        git_info+="${VCS_COMMIT_FG}${git_commit} "
        git_info+="${VCS_BRANCH_FG}${git_branch}"
        git_info+="${VCS_DETACHED_FG}${detached_suffix}"
      fi
      git_info+="${VCS_BEHIND_FG}${git_behind}"
      git_info+="${VCS_AHEAD_FG}${git_ahead}"
      git_info+="${VCS_STASH_FG}${stash_count}"
      git_info+="${VCS_UNTRACKED_FG}${untracked_count}"
      git_info+="${VCS_UNSTAGED_FG}${unstaged_count}"
      git_info+="${VCS_STAGED_FG}${staged_count}"
      if [[ "${git_state}" == "${GIT_PROMPT_CLEAN}" ]]
      then
        git_info+=" ${VCS_PROMPT_CLEAN_FG}${git_state}"
      else
        git_info+=" ${VCS_PROMPT_DIRTY_FG}${git_state}"
      fi
    fi
    echo "${git_info}"
    return
  }

  local GIT_IGNORE_UNTRACKED="${GIT_IGNORE_UNTRACKED:-false}"
  local GIT_PROMPT_DIRTY="${GIT_PROMPT_DIRTY:-"✗"}"
  local GIT_PROMPT_CLEAN="${GIT_PROMPT_CLEAN:-"✓"}"
  local GIT_BRANCH_PREFIX="${GIT_BRANCH_PREFIX:-""} "
  local GIT_TAG_PREFIX="${GIT_TAG_PREFIX:-"笠["}"
  local GIT_TAG_SUFFIX="${GIT_TAG_SUFFIX:-"]"}"
  local GIT_DETACHED_PREFIX="${GIT_DETACHED_PREFIX:-" ["}"
  local GIT_DETACHED_SUFFIX="${GIT_DETACHED_SUFFIX:-"]"}"
  local GIT_CHAR="${GIT_CHAR:-""}"
  local GIT_AHEAD_CHAR="${GIT_AHEAD_CHAR:-"ﰵ"}"
  local GIT_BEHIND_CHAR="${GIT_BEHIND_CHAR:-"ﰬ"}"
  local GIT_UNTRACKED_CHAR="${GIT_UNTRACKED_CHAR:-""} "
  local GIT_UNSTAGED_CHAR="${GIT_UNSTAGED_CHAR:-""} "
  local GIT_STAGED_CHAR="${GIT_STAGED_CHAR:-""} "
  local GIT_STASH_CHAR_PREFIX="${GIT_STASH_CHAR_PREFIX:-"{"}"
  local GIT_STASH_CHAR_SUFFIX="${GIT_STASH_CHAR_SUFFIX:-"}"}"

  _git_set_vars $1 $2
}

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
