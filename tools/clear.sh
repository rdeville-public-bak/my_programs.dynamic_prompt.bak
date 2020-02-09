#!/usr/bin/env zsh


for ((i=0;i<50;i++))
do
    clear
    precmd
    TEMP_PROMPT=${PROMPT//\%/}
    TEMP_PROMPT=${TEMP_PROMPT//\{/}
    TEMP_PROMPT=${TEMP_PROMPT//\}/}
    echo -e "${TEMP_PROMPT}"
    sleep 5
done