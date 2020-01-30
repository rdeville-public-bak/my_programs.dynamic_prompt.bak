#!/bin/bash

# Showing kubernetes info
local KUBE_CHAR="${KUBE_CHAR:-"⎈ "}"
local KUBE_FG="${KUBE_FG:-""}"
local KUBE_BG="${KUBE_BG:-""}"

_compute_kube_info()
{
  # Compute the kubernetes information
  local kube_context
  local kube_namespace
  local kube_info=""
  if [[ -n "${KUBE_ENV}" ]] && [[ ${KUBE_ENV} -ne 0 ]]
  then
    kube_context="$(kubectl config current-context 2>/dev/null)"
    if [[ -n "${kube_context}" ]]
    then
      kube_namespace="$(kubectl config view --minify \
        --output 'jsonpath={..namespace}' 2>/dev/null)"
      # Set namespace to 'default' if it is not defined
      kube_namespace="${kube_namespace:-default}"
      kube_info="${KUBE_CHAR}${kube_context}:${kube_namespace}"
    else
      kube_info=""
    fi
  elif [[ -n "${KUBE_CONTEXT}" ]]
  then
    # Variable set by direnv for debug purpose
    kube_info=${KUBE_CHAR}${KUBE_CONTEXT}
  fi
  echo "${kube_info}"
}

_compute_kube_info_short()
{
  if [[ -n "${KUBE_ENV}" ]] && [[ ${KUBE_ENV} -ne 0 ]]
  then
    echo "${KUBE_CHAR}"
  elif [[ -n "${KUBE_CONTEXT}" ]]
  then
    # Variable set by direnv for debug purpose
    echo "${KUBE_CHAR}"
  fi
}

_kube_info()
{
  local info=$(_compute_kube_info)
  if [[ -n "${info}" ]]
  then
    info_line[$iSegment]="${info}"
    info_line_clr[$iSegment]="${info}"
    info_line_fg[$iSegment]="${KUBE_FG}"
    info_line_bg[$iSegment]="${KUBE_BG}"
    info_line_clr_switch[$iSegment]="${KUBE_BG/4/3}"
  fi
}

_kube_info_short()
{
  local info=$(_compute_kube_info_short)
  if [[ -n "${info}" ]]
  then
    info_line_short[$iSegment]="${info}"
    info_line_clr_short[$iSegment]="${info}"
  fi
}
# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
