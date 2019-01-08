#!/usr/bin/env bash

declare -i canvas_width
declare -Ag canvas

canvas_width=100

main() {
  tput civis
  clear 
  local terminal_width
  local terminal_height
  local left_border
  local upper_border
  
  (( terminal_width=$(tput cols) ))
  (( terminal_height=$(tput lines) ))
  (( left_border="$terminal_width"/2 ))
  canvas_set 1 2
  canvas_set 1 3
  canvas_draw
}

canvas_set() {
  row=$1
  column=$2
  local result
  to_absolute $row $column
  canvas[$result]=1
}

canvas_draw() {
  tput setaf 2
  for i in "${canvas[@]}"
  do
    ((column = i%canvas_width ))
    ((row = i/canvas_width ))
    tput cup $row $column
    echo -n \* 
  done
}

to_absolute() {
  y=$1
  x=$2
  (( result=y*canvas_width+x ))
  echo $result
}

to_x() {
  absolute=$1
  (( x=absolute%canvas_width ))
  echo $x
}

to_y() {
  absolute=$1
  (( y=absolute/canvas_width ))
  echo $y
}

main "$@"

