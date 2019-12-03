#!/bin/bash

# Showing kubernetes info
local KUBE_CHAR="${KUBE_CHAR:-"⎈ "}"
local KUBE_FG="${KUBE_FG:-""}"
local KUBE_BG="${KUBE_BG:-""}"

_kube_info()
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
  fi
  echo "${kube_info}"
}

_kube_info_short()
{
  if [[ -n "${KUBE_ENV}" ]] && [[ ${KUBE_ENV} -ne 0 ]]
  then
    echo "${KUBE_CHAR}"
  fi
}

_kube_info_clr()
{
  echo "$(_kube_info)"
}

_kube_info_clr_short()
{
  echo "$(_kube_info_short)"
}

_kube_colorswitch()
{
  echo "${KUBE_BG/4/3}"
}

_kube_bg()
{
  echo "${KUBE_BG}"
}

_kube_fg()
{
  echo "${KUBE_FG}"
}


# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
