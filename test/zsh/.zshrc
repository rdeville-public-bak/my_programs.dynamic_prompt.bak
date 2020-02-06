#!/usr/bin/env zsh

source <(direnv hook zsh)

export PROMPT_DIR="${HOME}/.prompt"

source "${PROMPT_DIR}/prompt.sh"
