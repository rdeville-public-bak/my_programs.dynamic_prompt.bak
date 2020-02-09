#!/usr/bin/env bash


WINDOWS_ID=(
#"0x3a00006" "bash" "v1"
#"0x3600006" "bash" "v2"
#"0x4200006" "zsh"  "v1"
"0x4e00006" "zsh"  "v1"
)

TEXT_V1=(
  "All informations are shown."
  "All informations are shown."
  "Compression of 'vcsh' & 'python' segment."
  "Compression of 'kubernetes' segment."
  "Compression of 'kubernetes' segment."
  "Compression of 'tmux', 'username' & openstack' segment."
  "Compression of 'git' & 'hostname' segment."
  "Compression of 'pwd' & keepass' segment."
  "More Compression of 'pwd' segment."
  "Hiding 'vsch', tmux', 'username' & 'hostname' segment."
  "Unhiding 'vsch', tmux', 'username' & 'hostname' segment."
  "Partial decompression of 'pwd' segment."
  "Decompression of 'pwd' & keepass' segment."
  "Decompression of 'git' & 'hostname' segment."
  "Decompression of 'tmux', 'username' & 'openstack'."
  "Decompression of 'tmux', 'username' & 'openstack'."
  "Decompression of 'kubernetes' segment."
  "Decompression of 'vcsh' & 'python' segment."
  "All informations are shown."
)

TEXT_V2=(
  "All informations are shown."
  "Compression of 'vcsh' & 'python' segment."
  "Compression of 'vcsh' & 'python' segment."
  "Compression of 'kubernetes' segment."
  "Compression of 'openstack' & 'tmux' segment."
  "Compression of 'git', 'username' & 'hostname' segment."
  "Compression of 'pwd' & keepass' segment."
  "More Compression of 'pwd' segment."
  "Hiding 'tmux' & 'username' segment."
  "Hiding 'keepass', 'hostname', 'vcsh' & 'python' segment."
  "Unhiding 'keepass', 'hostname', 'vcsh' & 'python' segment."
  "Unhiding 'tmux' & 'username' segment."
  "Partial decompression of 'pwd' segment."
  "Decompression of 'pwd' & keepass' segment."
  "Decompression of 'git', 'username' & 'hostname' segment."
  "Decompression of 'openstack' & 'tmux' segment."
  "Decompression of 'kubernetes' segment."
  "Decompression of 'kubernetes' segment."
  "Decompression of 'vcsh' & 'python' segment."
)

resize_screenshot()
{
  mkdir -p resized/v$2/
  for ((i=0;i<9;i++))
  do
    local window_idx
    local term_idx
    local version_idx
    local file_prefix=$1
    for ((idx=0;idx<${#WINDOWS_ID[@]};idx++))
    do
      window_idx=${idx}
      term_idx=$(( idx + 1 ))
      version_idx=$(( idx + 2 ))
      idx=$(( idx + 2 ))
      filename=${file_prefix}_${WINDOWS_ID[term_idx]}_${WINDOWS_ID[version_idx]}_0$i.png
      echo ${filename}
      convert \
        src/v$2/${filename} \
        -background black \
        -extent 1050x100 \
        resized/v$2/${filename/.png/_resize.png}
    done
  done

  for ((i=10;i<19;i++))
  do
    for ((idx=0;idx<${#WINDOWS_ID[@]};idx++))
    do
      window_idx=${idx}
      term_idx=$(( idx + 1 ))
      version_idx=$(( idx + 2 ))
      idx=$(( idx + 2 ))
      filename=${file_prefix}_${WINDOWS_ID[term_idx]}_${WINDOWS_ID[version_idx]}_$i.png
      echo ${filename}
      convert \
        src/v$2/${filename} \
        -background black \
        -extent 1050x100 \
        resized/v$2/${filename/.png/_resize.png}
    done
  done
}

take_compression_term()
{
  mkdir -p src/v$2/
  for ((i=0;i<9;i++))
  do
    sleep 5
    local window_idx
    local term_idx
    local version_idx
    local file_prefix=$1
    for ((idx=0;idx<${#WINDOWS_ID[@]};idx++))
    do
      window_idx=${idx}
      term_idx=$(( idx + 1 ))
      version_idx=$(( idx + 2 ))
      idx=$(( idx + 2 ))
      filename=${file_prefix}_${WINDOWS_ID[term_idx]}_${WINDOWS_ID[version_idx]}_0$i.png
      echo ${filename}
      import \
        -window  ${WINDOWS_ID[window_idx]} \
        -crop 1900x100+0+0 \
        +repage \
        src/v$2/${filename}
    done
    awesome-client 'awful = require("awful");awful.tag.incmwfact(-0.05)'
  done

  for ((i=10;i<19;i++))
  do
    sleep 5
    for ((idx=0;idx<${#WINDOWS_ID[@]};idx++))
    do
      window_idx=${idx}
      term_idx=$(( idx + 1 ))
      version_idx=$(( idx + 2 ))
      idx=$(( idx + 2 ))
      filename=${file_prefix}_${WINDOWS_ID[term_idx]}_${WINDOWS_ID[version_idx]}_$i.png
      echo ${filename}
      import \
        -window  ${WINDOWS_ID[window_idx]} \
        -crop 1900x100+0+0 \
        +repage \
        src/v$2/${filename}
    done
    awesome-client 'awful = require("awful");awful.tag.incmwfact(0.05)'
  done
}

take_all_term()
{
  local window_idx
  local term_idx
  local version_idx
  local file_prefix=$1
  for ((idx=0;idx<${#WINDOWS_ID[@]};idx++))
  do
    window_idx=${idx}
    term_idx=$(( idx + 1 ))
    version_idx=$(( idx + 2 ))
    idx=$(( idx + 2 ))
    echo "${file_prefix}_${WINDOWS_ID[term_idx]}_${WINDOWS_ID[version_idx]}.png"
    import \
      -window  ${WINDOWS_ID[window_idx]} \
      -crop 1900x100+0+0 \
      +repage \
      ${file_prefix}_${WINDOWS_ID[term_idx]}_${WINDOWS_ID[version_idx]}.png
  done
}

add_text()
{
  local idx=0
  for iVersion in "v1" "v2"
  do
    idx=0
    if [[ ${iVersion} == "v1" ]]
    then
      TEXT=("${TEXT_V1[@]}")
    elif [[ ${iVersion} == "v2" ]]
    then
      TEXT=("${TEXT_V2[@]}")
    fi
    if [[ -e "resized/${iVersion}" ]]
    then
      for i in resized/${iVersion}/*.png
      do
        echo "${TEXT[idx]} -> $i"
        width=$(identify -format %w $i)
        convert \
          -background "#0008" \
          -fill white \
          -gravity center \
          -size ${width}x30 \
          caption:"${TEXT[idx]}" \
          $i \
          +swap \
          -gravity south \
          -composite ${i/resize.png/text.png}
        idx=$(( idx + 1 ))
      done
      mv -f resized/${iVersion}/*text* text/${iVersion}/
    fi
  done
}

create_gif(){
  idx=0
  for iVersion in "v1" "v2"
  do
    echo "text/${iVersion}/shrink_${iVersion}.gif"
    if [[ -e "text/${iVersion}" ]]
    then
      convert \
        -delay 250 \
        -loop 0 \
        text/${iVersion}/*.png \
        text/${iVersion}/shrink_${iVersion}.gif
        cp text/${iVersion}/shrink_${iVersion}.gif ../doc/img/shrink_${iVersion}.gif
    fi
  done
}


main()
{
  case $1 in
    0)
      take_all_term $2
      ;;
    1)
      take_compression_term $2 $3
      resize_screenshot $2 $3
      add_text
      create_gif
      ;;
    2)
      resize_screenshot $2 $3
      add_text
      create_gif
      ;;
    3)
      add_text
      create_gif
      ;;
    4)
      create_gif
      ;;
  esac
}

main $@

# vim: ft=sh: ts=2: sw=2: sts=2