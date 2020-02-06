#!/usr/bin/env bash

source <(direnv hook bash)

export PROMPT_DIR="${HOME}/.prompt"

source "${PROMPT_DIR}/prompt.sh"

if ! [[ "${PROMPT_COMMAND}" =~ precmd ]]
then
  export PROMPT_COMMAND="precmd;${PROMPT_COMMAND}"
fi