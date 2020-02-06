#!/bin/bash

# Store absolute path of script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
# Compute size of terminal
TERMSIZE=$(tput cols)
# Set colors for whiptail UI
NEWTCOLS=(
  root=white,black
  border=white,black
  window=black,gray
  shadow=,black
  title=brightgreen,black
  button=black,brightred
  actbutton=black,gray
  checkbox=black,gray
  actcheckbox=black,brightred
  listbox=black,gray
  actlistbox=black,brightred
  sellistbox=black,gray
  actsellistbox=black,brightred
  textbox=black,gray
  acttextbox=black,brightred
  entry=white,green
  disentry=black,gray
  roottext=black,gray
  emptyscale=black,gray
  fullscale=black,gray
  label=black,gray
  comptactbutton=black,gray
  helpline=black,gray
)

create_new_segment_from_template(){
  local new_segment_name=$1
  local new_segment_name_lower=$(echo $1 | tr '[:upper:]' '[:lower:]' )
  local new_segment_name_upper=$(echo $1 | tr '[:lower:]' '[:upper:]' )
  local segment_template=${SCRIPTPATH}/segment/segment.tpl
  local new_segment=${SCRIPTPATH}/segment/${new_segment_name}.sh

  sed -e "s|TPL_SEGMENT_LOWER|${new_segment_name_lower}|g" \
      -e "s|TPL_SEGMENT_UPPER|${new_segment_name_upper}|g" \
      ${segment_template} > ${new_segment}
}

ask_segment_name()
{
  # Ask the user the name of the new segment
  # NO PARAM
  local segment_name=""
  if command -v whiptail &> /dev/null
  then
    segment_name=$(
      NEWT_COLORS="${NEWTCOLS[@]}" \
      whiptail --title "Segment Name" --inputbox \
      "\n    What is the name you want to use for your new segment ?" 20 ${TERMSIZE} \
      3>&1 1>&2 2>&3)
    if [[ -z ${segment_name} ]]
    then
      NEWT_COLORS="${NEWTCOLS[@]}" \
        whiptail --title "Segment Name" --msgbox \
        "\n ERROR - You did not provide any segment name !\n Please run the script again"\
        20 ${TERMSIZE}
      exit 1
    fi
  else
    while [[ ${answer} -ne 1 ]] && [[ ${answer} -ne 2 ]]
    do
      echo -e "What is the name you want to use for your new segment ?"
      read -e segment_name
    done
    if [[ -z ${segment_name} ]]
    then
      echo -e "${E_ERROR}ERROR - You did not provide any segment name !"
      echo -e "Please run the script again${E_NORMAL}"
      exit 1
    fi
  fi
  create_new_segment_from_template $segment_name
  return 0
}

ask_segment_name

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
