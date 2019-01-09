#!/usr/bin/env bash

main() {
  
  local terminal_width
  local terminal_height
  local left_border
  local upper_border

  (( terminal_width=$(tput cols) ))
  (( terminal_height=$(tput lines) ))
  (( left_border="$terminal_width"/2 - 30 ))
  upper_border=1

  local upper_arm=()
  coords_from_file upper_arm star.ascii \*

  local left_arm=()
  coords_from_file left_arm star.ascii /

  local lower_left_arm=()
  coords_from_file lower_left_arm star.ascii \!

  local lower_right_arm=()
  coords_from_file lower_right_arm star.ascii \&
  
  local right_arm=()
  coords_from_file right_arm star.ascii \(

  local upper_left_circle=()
  coords_from_file upper_left_circle star.ascii @

  local lower_left_circle=()
  coords_from_file lower_left_circle star.ascii %

  local lower_circle=()
  coords_from_file lower_circle star.ascii o
 
  local lower_right_circle=()
  coords_from_file lower_right_circle star.ascii \#

  local upper_right_circle=()
  coords_from_file upper_right_circle star.ascii x

  clear
  tput civis
  tput setaf 2;
  canvas_draw m "${upper_arm[@]}"
  tput setaf 3;
  canvas_draw m "${left_arm[@]}"
  tput setaf 4;
  canvas_draw m "${lower_left_arm[@]}"
  tput setaf 5;
  canvas_draw m "${lower_right_arm[@]}"
  tput setaf 6;
  canvas_draw m "${right_arm[@]}"
  tput setaf 7;
  canvas_draw m "${upper_left_circle[@]}"
  tput setaf 1;
  canvas_draw m "${lower_left_circle[@]}"
  tput setaf 2;
  canvas_draw m "${lower_circle[@]}"
  tput setaf 4;
  canvas_draw m "${lower_right_circle[@]}"
  tput setaf 3;
  canvas_draw m "${upper_right_circle[@]}"
  tput cup 40 0
}

coords_from_file() {
  typeset -n result=$1
  local file=$2
  local character=$3
  readarray -t file_lines < "$file"
  local row=0
  for line in "${file_lines[@]}"; do
    for i in $(seq 1 ${#line}); do 
      local current_character=${line:i-1:1}
      if [[ -z $character ]]; then 
        [[ "$current_character" == ' ' ]] && continue
      else 
        [[ "$current_character" != "$character" ]] && continue
      fi 
      result+=( "$row,$i" )
    done
    (( row++))
  done
}

printArr() {
  typeset -n out=$1
  for i in "${out[@]}"
  do
    echo "value: $i"
  done
}

put_line() {
  local -n buffer=$1
  local start=$2
  local end=$3
  IFS=','; read -ra start_coords <<< "$start"
  read -ra end_coords <<< "$end"
  local start_row=${start_coords[0]}
  local start_column=${start_coords[1]}
  local end_column=${end_coords[1]}
  local i=$start_column
  while [[ $i -le $end_column ]]
  do
    buffer+=("$start_row,$i")
    ((i++))
  done
}

# Taken from here: https://unix.stackexchange.com/a/269085
from_hex(){
    hex=${1#"#"}
    r=$(printf '0x%0.2s' "$hex")
    g=$(printf '0x%0.2s' ${hex#??})
    b=$(printf '0x%0.2s' ${hex#????})
    printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 + 
                       (g<75?0:(g-35)/40)*6   +
                       (b<75?0:(b-35)/40)     + 16 ))"
}

canvas_draw() {
  local symbol=$1
  shift
  local -i column
  local -i row
  for i in "$@"
  do
    IFS=',' read -ra coords <<< "$i"
    row=${coords[0]}
    column=${coords[1]} 
    ((column += left_border ))
    ((row += upper_border ))
    # echo "ROW: $row"
    # echo "COLUMN: $column"
    tput cup $row $column
    echo -n "$symbol"
  done
  echo ""
}

main "$@"

