#!/bin/bash

# Store absolute path of script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
# Compute size of terminal
TERMSIZE=$(tput cols)
# Compute line to show true colors
TRUE_COLORS_LINE=$(
  awk 'BEGIN{
    s="----------"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
)
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

usage(){
  # Manual page describing usage of script
  echo -e "\
${E_BOLD} NAME${E_NORMAL}
    test.sh - Ask user parameter to set to test prompt config in docker

${E_BOLD} SYNOPSIS${E_NORMAL}
    ${E_BOLD}test.sh \
[ ${E_BOLD}-s${E_NORMAL} ${E_UNDER}shell${E_NORMAL} ] \
[ ${E_BOLD}-p${E_NORMAL} ${E_UNDER}prompt_version${E_NORMAL} ] \
[ ${E_BOLD}-a${E_NORMAL} ${E_UNDER}shell_app${E_NORMAL} ] \
[ ${E_BOLD}-b${E_NORMAL}  ] \
[ ${E_BOLD}-h${E_NORMAL}  ]

${E_BOLD} DESCRIPTION${E_NORMAL}
    ${E_BOLD}test.sh${E_NORMAL} is a script that will let you set parameters to
    test your configuration for the prompt line promposed by this repo in a
    docker environment to avoid messing with your actual prompt.

    By default, without any options, the script will pass through some
    interactive dialog boxes to ask you main parameters you want to set. But
    once you know which main parameters you want to test, which are also
    recalled before running the docker when in interactive mode, you can
    override them by passing arguments to the script.

    NOTE: Despite the fact that is a bash script, there is not order on options.

${E_BOLD} OPTIONS${E_NORMAL}

    ${E_BOLD}-s, --shell${E_NORMAL}
        The name of the shell you want to test. Possible values are :
          - ${E_BOLD}bash${E_NORMAL}
          - ${E_BOLD}zsh${E_NORMAL}

    ${E_BOLD}-p, --prompt${E_NORMAL}
        The prompt version you want to test. Possible values are :
          - ${E_BOLD}1${E_NORMAL}
          - ${E_BOLD}2${E_NORMAL}

    ${E_BOLD}-a, --app${E_NORMAL}
        The terminal emulator value you want to emulate for your test depending
        on support of unicode char and true colors of your terminal.
        Possible values are :
          - ${E_BOLD}unknown${E_NORMAL}: If your terminal emulator does not support neither unicode
            char, neither true colors
          - ${E_BOLD}xterm${E_NORMAL}: If your terminal emulator does support unicode char but does
            not support true colors
          - ${E_BOLD}st${E_NORMAL}: If your terminal emulator does support unicode char and true
            colors.

        Unicode char are special char like some emoji.
        If your terminal support unicode char, you should see a heart between
        the following single quotes: '♡ '

        True colors means your terminal emulator is able to show colors with
        values RGB from 0 to 255.
        If your terminal support true colors, then the between lines
        '======================' should show continous colors, if you only see
        char '-' or discontinous colors, this mean your terminal does not
        support true colors.
===============================================================================
|${TRUE_COLORS_LINE}|
===============================================================================

    ${E_BOLD}-b,--build${E_NORMAL}
        If you set all previous parameter, you can directly build and run the
        docker without the confirmation dialog.

    ${E_BOLD}-h,--help${E_NORMAL}
        Print this help
  "
}


ask_shell_to_test(){
  # Ask the user which shell (bash/zsh) to test
  # NO PARAM
  local answer=""
  local shell=""
  if command -v whiptail &> /dev/null
  then
    shell=$(
      NEWT_COLORS="${NEWTCOLS[@]}" \
      whiptail --title "Select your shell" --noitem --radiolist \
      "\n    Select the shell you want to test" 20 ${TERMSIZE} 2 \
      "zsh" ON \
      "bash" OFF \
      3>&1 1>&2 2>&3)
      case ${shell} in
        zsh|bash)
          ;;
        *)
          exit 1
          ;;
      esac
  else
    while [[ ${answer} -ne 1 ]] && [[ ${answer} -ne 2 ]]
    do
      echo "Which shell do you want to use [Default 2 (zsh)]? "
      echo "1: bash (/bin/bash)"
      echo "2: zsh (/bin/zsh)"
      read -e answer
      answer=${answer:-2}
      case ${answer} in
        1)
          shell=bash
          ;;
        2)
          shell=zsh
          ;;
        *)
          echo -e "${E_ERROR}Please enter 1 or 2${E_NORMAL}"
          ;;
      esac
    done
  fi
  echo ${shell}
  return 0
}

ask_unicode_support()
{
  # Ask the user if its terminal emulator support unicode
  # NO PARAM
  local answer=""
  if command -v whiptail &> /dev/null
  then
    if \
      NEWT_COLORS="${NEWTCOLS[@]}" \
      whiptail --title "Unicode Support" --yesno \
      "\n    Does your shell support unicode, i.e. do you see a heart between the single quotes : '♡ ' ? " \
      20 ${TERMSIZE}
    then
      return 0
    else
      return 1
    fi
  else
    while [[ ${answer} -ne 1 ]] && [[ ${answer} -ne 2 ]]
    do
      echo "Does your shell support unicode, i.e. do you see a heart between the single quotes : '♡ ' ? [Y/n]"
      read -e answer
      answer=${answer:-Y}
      case ${answer} in
        y|Y|yes|YES|ye|YE)
          return 0
          ;;
        n|N|no|NO)
          return 1
          ;;
        *)
          echo -e "${E_ERROR}Please enter y|yes or n|no${E_NORMAL}"
          ;;
      esac
    done
  fi
  echo ${shell}
  return 0
}

show_true_colors()
{
  # If user does not if his/her terminal emulator support true colors,
  # print a line using true colors.
  # NO PARAM
  if command -v whiptail &> /dev/null
  then
    NEWT_COLORS="${NEWTCOLS[@]}" \
    whiptail --title "True Color Support" --msgbox \
      "\n    You will be prompt a line which use true colors during 5 seconds. If you do not see continous colors, or no colors at all, this means your terminal emulator does not support true color" \
      20 ${TERMSIZE}
  else
    echo "You will be prompt a line which use true colors during 5 seconds."
    echo "If you do not see continous colors, or no colors at all, this means your terminal emulator does not support true color"
    echo "Press <Enter> when read"
    read
  fi
  clear
  echo "==============================================================================="
  echo "|           Below should be the line using true colors                        |"
  echo "|                                                                             |"
  echo -e "|${TRUE_COLORS_LINE}|"
  echo "|                                                                             |"
  echo "==============================================================================="
  sleep 5
}

ask_true_color_support()
{
  # Ask user if his/her terminal emulator support true colors
  # NO PARAM
  local answer=""
  local true_color_support=""
  if command -v whiptail &> /dev/null
  then
    while [[ ${true_color_support} != "Yes" ]] || [[ ${true_color_support} != "No" ]]
    do
      true_color_support=$(
        NEWT_COLORS="${NEWTCOLS[@]}" \
        whiptail --title "True Color Support" --noitem --radiolist \
        "\n    Does your shell support true colors ? " \
        20 ${TERMSIZE} 5 \
        "Yes" ON \
        "No" OFF \
        "I don't know" OFF \
        3>&1 1>&2 2>&3)
      case ${true_color_support} in
        Yes)
          return 0
          ;;
        No)
          return 1
          ;;
        "I don't know")
          show_true_colors
          ;;
        *)
          exit 1
          ;;
      esac
    done
  else
    while [[ ${answer} -ne 1 ]] && [[ ${answer} -ne 2 ]]
    do
      echo "Does your shell support unicode ? \n i.e. do you see a heart : ♡
      [Y/n]"
      read -e answer
      answer=${answer:-Y}
      case ${answer} in
        y|Y|yes|YES|ye|YE)
          return 0
          ;;
        n|N|no|NO)
          return 1
          ;;
        *)
          echo -e "${E_ERROR}Please enter y|yes or n|no${E_NORMAL}"
          ;;
      esac
    done
  fi
  return 0
}

build_docker_image(){
  # Build the docker image if not already built
  # PARAM $1 : Name of the shell to test "zsh" or "bash"
  local shell=$1
  local image_name="ubuntu-test-${shell}"
  local curr_pwd=$(pwd)
  local nb_step
  local idx
  local dockerfile_path=${SCRIPTPATH}/test/${shell}/Dockerfile
  if ! docker image list ${image_name} | grep -q ${image_name}
  then
    cd ${SCRIPTPATH}
    echo -e "${E_INFO}\
[INFO] Building docker image ${image_name}.
[INFO] Docker build log redirected to ${SCRIPTPATH}/docker_build.log${E_NORMAL}"
    docker build --tag ${image_name} -f ${dockerfile_path} . > ${SCRIPTPATH}/docker_build.log
    cd ${curr_pwd}
  fi
  return 0
}

run_docker()
{
  # Run the docker to test the user provided bash
  # PARAM $1 : Name of the shell to test "zsh" or "bash"
  # PARAM $2 : Name of a fake shell_app emulating the unicode/true colors
  #            support of the user's terminal emulator
  # PARAM $3 : Version of the prompt to test
  local shell=$1
  local shell_app=$2
  local prompt_version=$3
  local image_name="ubuntu-test-${shell}"
  local container_name="${image_name}"
  case ${shell} in
    bash)
      echo -e "${E_INFO}[INFO] Running container ${container_name}${E_NORMAL}"
      docker run \
        -e SHELL_APP="${shell_app}" \
        -e PROMPT_VERSION="${prompt_version}" \
        -v "${SCRIPTPATH}:/root/.prompt" \
        -it \
        --name ${container_name} \
        --rm  \
        --hostname ${container_name} ${image_name} \
        '/bin/bash'
      ;;
    zsh)
      echo -e "${E_INFO}[INFO] Running container ${container_name}${E_NORMAL}"
      docker run \
        -e SHELL_APP="${shell_app}" \
        -e PROMPT_VERSION="${prompt_version}" \
        -v "${SCRIPTPATH}:/root/.prompt" \
        -it \
        --rm  \
        --name ${container_name} \
        --hostname ${container_name} ${image_name} \
        '/bin/zsh'
      ;;
  esac
  return 0
}

ask_prompt_version()
{
  # Ask user which version of the prompt to test
  # NO PARAM
  local prompt_version=""
  if command -v whiptail &> /dev/null
  then
    prompt_version=$(
      NEWT_COLORS="${NEWTCOLS[@]}" \
      whiptail --title "Prompt version" --noitem --radiolist \
      "\n    Which prompt version do you want to test" 20 ${TERMSIZE} 2 \
      "1" OFF \
      "2" ON \
      3>&1 1>&2 2>&3)
      if [[ -z "${prompt_version}" ]]
      then
        exit 1
      fi
  else
    while [[ ${answer} -ne 1 ]] && [[ ${answer} -ne 2 ]]
    do
      echo "Which prompt version do you want to test [Default 2] ? "
      echo "1: Version 1"
      echo "2: Version 2"
      read -e answer
      answer=${answer:-2}
      case ${answer} in
        1|2)
          prompt_version=${answer}
          ;;
        *)
          echo -e "${E_ERROR}Please enter 1 or 2${E_NORMAL}"
          ;;
      esac
    done
  fi
  echo ${prompt_version}
  return 0
}

ask_confirmation()
{
  # Recap user parameter and present what will be done
  # PARAM $1 : Name of the shell to test "zsh" or "bash"
  # PARAM $2 : Name of a fake shell_app emulating the unicode/true colors
  #            support of the user's terminal emulator
  # PARAM $3 : Version of the prompt to test
  local shell=$1
  local shell_app=$2
  local prompt_version=$3
  local image_name="ubuntu-test-${shell}"
  local container_name="${image_name}"
  if command -v whiptail &> /dev/null
  then
    true_color_support=$(
      NEWT_COLORS="${NEWTCOLS[@]}" \
      whiptail --title "Confirmation" --radiolist \
      "\n    Here is what will be done :
      - Build a docker image called ${image_name} if not already built
      - Run a container called ${container_name} that will be delete on exit
      - Within this container, shell '${shell}' will be used to test prompt version ${prompt_version}

      NOTE: If you do not want to pass through this interactive process the next time, here is the command to use:
      \`\`\`
        ./test.sh -s ${shell} -p ${prompt_version} -a ${shell_app} -b
      \`\`\`
      Do you want to continue ? Selecting Cancel will result in exiting the process" \
      23 ${TERMSIZE} 5 \
      "Yes" "Do as said above" ON \
      "No" "No wait, I want to change something" OFF \
      3>&1 1>&2 2>&3)
    case ${true_color_support} in
      Yes)
        return 0
        ;;
      No)
        return 1
        ;;
      *)
        exit 1
        ;;
    esac
  else
    while [[ ${answer} -ne 1 ]] && [[ ${answer} -ne 2 ]]
    do
      echo "Does your shell support unicode ? \n i.e. do you see a heart : ♡
      [Y/n]"
      read -e answer
      answer=${answer:-Y}
      case ${answer} in
        y|Y|yes|YES|ye|YE)
          return 0
          ;;
        n|N|no|NO)
          return 1
          ;;
        *)
          echo -e "${E_ERROR}Please enter y|yes or n|no${E_NORMAL}"
          ;;
      esac
    done
  fi
  return 0

}

main(){
  # Main method launching menus to ask user parameter
  local userset_shell="false"
  local userset_prompt_version="false"
  local userset_shell_app="false"
  local build="false"
  local validate_build="false"
  local interactif="false"
  local shell
  local prompt_version
  local shell_app
  while [[ $# -gt 0 ]]
  do
    case $1 in
      -s|--shell)
        shift
        shell=$1
        userset_shell="true"
        shift
        ;;
      -p|--prompt)
        shift
        prompt_version=$1
        userset_prompt_version="true"
        shift
        ;;
      -a|--app)
        shift
        shell_app=$1
        userset_shell_app="true"
        shift
        ;;
      -b|--build)
        validate_build="true"
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
    esac
  done

  if [[ ${validate_build} == "true" ]]
  then
    if [[ ${userset_shell} == "false" ]] \
      || [[ ${userset_prompt_version} == "false" ]] \
      || [[ ${userset_prompt_version} == "false" ]]
    then
      echo -e "${E_WARNING}[WARNING] You can only use option ${E_BOLD}-b,--build${E_WARNING} if you use ${E_BOLD}all${E_WARNING} other options."
      echo -e "${E_WARNING}[WARNING] Docker will not be build and run directly."
      echo -e "${E_WARNING}[WARNING] Press ${E_ERROR}${E_BOLD}<Ctrl+C>${E_WARNING} to fall back to interactive mode."
      echo -e "${E_WARNING}[WARNING] Press ${E_INFO}${E_BOLD}<Enter>${E_WARNING} to fall back to interactive mode."
      read
    else
      build="true"
    fi
  fi
  while [[ ${build} == "false" ]]
  do
    if [[ ${userset_shell} == "false" ]]
    then
      shell=$(ask_shell_to_test)
      if [[ $? -eq 1 ]]
      then
        exit 1
      fi
    fi
    if [[ ${userset_prompt_version} == "false" ]]
    then
      prompt_version=$(ask_prompt_version)
      if [[ $? -eq 1 ]]
      then
        exit 1
      fi
    fi
    if [[ ${userset_shell_app} == "false" ]]
    then
      shell_app="unknown"
      ask_unicode_support
      if [[ $? -eq 0 ]]
      then
        shell_app="xterm"
        ask_true_color_support
        if [[ $? -eq 0 ]]
        then
          shell_app="st"
        fi
      fi
    fi
    if ask_confirmation ${shell} ${shell_app} ${prompt_version}
    then
      build="true"
    else
      userset_shell="false"
      userset_prompt_version="false"
      userset_shell_app="false"
    fi
  done
  build_docker_image ${shell}
  run_docker ${shell} ${shell_app} ${prompt_version}
  return 0
}

main $@

# *****************************************************************************
# EDITOR CONFIG
# vim: ft=sh: ts=2: sw=2: sts=2
# *****************************************************************************
