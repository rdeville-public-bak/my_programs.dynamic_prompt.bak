#!/usr/bin/env bash

source <(direnv hook bash)

export PROMPT_DIR="${HOME}"
export PROMPT_VERSION="2"
export SHELL="/bin/bash"
export PATH="${PATH}:${HOME}/.local/bin"

source "${PROMPT_DIR}/prompt.sh"

if ! [[ "${PROMPT_COMMAND}" =~ precmd ]]
then
  export PROMPT_COMMAND="precmd;${PROMPT_COMMAND}"
fi