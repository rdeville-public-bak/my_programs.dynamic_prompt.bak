#!/usr/bin/env zsh

source <(direnv hook zsh)

export PROMPT_DIR="${HOME}"
export PROMPT_VERSION="2"
export SHELL="/bin/zsh"
export PATH="${PATH}:${HOME}/.local/bin"

source "${PROMPT_DIR}/prompt.sh"