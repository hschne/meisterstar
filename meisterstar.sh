#!/usr/bin/env bash

main() {
  local surroundings=()
  coords_from_file surroundings template.ascii @
  
  local terminal_width
  local terminal_height
  local left_border
  local upper_border

  (( terminal_width=$(tput cols) ))
  (( terminal_height=$(tput lines) ))
  (( left_border="$terminal_width"/2 - 30 ))
  upper_border=1

  local upper_arm=()
  create_upper_arm

  local left_arm=()
  create_left_arm

  local lower_left_arm=()
  create_lower_left_arm

  local lower_right_arm=()
  create_lower_right_arm

  local right_arm=()
  create_right_arm

  local upper_left_circle=()
  create_upper_left_circle


  clear
  tput civis
  tput dim
  tput setaf 2; tput bold
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
  canvas_draw m "${surroundings[@]}"
  tput cup 40 0
}

create_upper_arm() {
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

create_left_arm() {
  put_line left_arm 9,4 9,15
  put_line left_arm 10,3 10,15
  put_line left_arm 11,2 11,16
  put_line left_arm 12,3 12,18
  put_line left_arm 13,5 13,16
  put_line left_arm 14,7 14,13
  put_line left_arm 15,9 15,11
  left_arm+=( 16,11 )
}

create_lower_left_arm() {
  put_line lower_left_arm 18,12 18,19
  put_line lower_left_arm 19,11 19,21
  put_line lower_left_arm 20,11 20,21
  put_line lower_left_arm 21,11 20,23
  put_line lower_left_arm 22,10 22,24
  put_line lower_left_arm 23,10 23,20
  put_line lower_left_arm 24,11 24,16

}

create_lower_right_arm(){
  put_line lower_right_arm 18,33 18,40
  put_line lower_right_arm 19,31 19,41
  put_line lower_right_arm 20,31 20,41
  put_line lower_right_arm 21,29 21,41
  put_line lower_right_arm 22,28 22,42
  put_line lower_right_arm 23,32 23,42
  put_line lower_right_arm 24,36 23,41
}

create_right_arm() {
  put_line right_arm 9,37 9,48
  put_line right_arm 10,37 10,49
  put_line right_arm 11,36 11,50
  put_line right_arm 12,34 12,49
  put_line right_arm 13,36 13,47
  put_line right_arm 14,39 14,45
  put_line right_arm 15,41 15,43
  right_arm+=( 16,41 )
}

create_upper_left_circle() {
  put_line right_arm 8,17 8,22
}

coords_from_file() {
  typeset -n result=$1
  local file=$2
  local character=$3
  readarray -t file_lines < "$file"
  local row=0
  for line in "${file_lines[@]}"; do
    for i in $(seq 1 ${#line}); do 
      local letter=${line:i-1:1}
      [[ -z $letter ]] && letter=' ' 

      [[ "$letter" != "$character" ]] && continue

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

