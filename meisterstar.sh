#!/usr/bin/env bash

main() {
  local terminal_width
  local terminal_height
  local left_border
  local upper_border
  
  (( terminal_width=$(tput cols) ))
  (( terminal_height=$(tput lines) ))
  (( left_border="$terminal_width"/3 ))
  upper_border=5

  local upper_arm=()
  draw_upper_arm

  local left_arm=()
  draw_left_arm

  # printArr upper_arm

  clear
  tput civis
  tput dim
  tput setaf 2; tput bold
  canvas_draw m "${upper_arm[@]}"
  tput sgr0
  tput setaf 3
  canvas_draw m "${left_arm[@]}"
}

draw_upper_arm() {
  put_line upper_arm 2,24 2,28
  put_line upper_arm 3,22 3,30
  put_line upper_arm 4,21 4,31
  put_line upper_arm 5,20 5,32
  put_line upper_arm 6,19 6,33
  put_line upper_arm 7,18 7,34
  put_line upper_arm 8,23 8,29
  upper_arm+=(9,24 9,25 9,27 9,28)
  upper_arm+=(10,24 10,28)
}

draw_left_arm() {
  put_line left_arm 9,4 9,15
  put_line left_arm 10,3 10,15
  put_line left_arm 11,2 11,16
  put_line left_arm 12,3 12,18
  put_line left_arm 13,5 13,16
  put_line left_arm 14,7 14,13
  put_line left_arm 15,9 15,11
}

printArr() {
  typeset -n arr=$1
  for i in "${arr[@]}"
  do
    echo "value: $i"
  done
}

put_line() {
  local -n buffer=$1
  start=$2
  end=$3
  IFS=',' 
  read -ra start_coords <<< "$start"
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

