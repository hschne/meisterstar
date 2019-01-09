#!/usr/bin/env bash

trap "tput reset; tput cnorm; exit" 2

main() {
  local terminal_width
  local left_border
  local upper_border

  (( terminal_width=$(tput cols) ))
  (( left_border="$terminal_width"/2 - 30 ))
  upper_border=2

  local upper_arm=()
  coords_from_file upper_arm meisterstar.ascii \*

  local left_arm=()
  coords_from_file left_arm meisterstar.ascii /

  local lower_left_arm=()
  coords_from_file lower_left_arm meisterstar.ascii \!

  local lower_right_arm=()
  coords_from_file lower_right_arm meisterstar.ascii \&
  
  local right_arm=()
  coords_from_file right_arm meisterstar.ascii \(

  local upper_left_circle=()
  coords_from_file upper_left_circle meisterstar.ascii @

  local lower_left_circle=()
  coords_from_file lower_left_circle meisterstar.ascii %

  local lower_circle=()
  coords_from_file lower_circle meisterstar.ascii o
 
  local lower_right_circle=()
  coords_from_file lower_right_circle meisterstar.ascii \#

  local upper_right_circle=()
  coords_from_file upper_right_circle meisterstar.ascii x

  clear
  tput civis

  local writing_start
  (( writing_start=left_border+22 ))
  tput cup 28 $writing_start

  echo "M E I S T E R"

  tput dim
  draw_star

  tput sgr0


  draw_repeat
}

function draw_star() {
  sleep_time=0.03
  color=$(from_hex 37D7D7)
  canvas_draw m "$color" "${upper_arm[@]}"
  sleep $sleep_time
  color=$(from_hex 188ED5)
  canvas_draw m "$color" "${upper_left_circle[@]}"
  sleep $sleep_time
  color=$(from_hex 1CA8FC)
  canvas_draw m "$color" "${left_arm[@]}"
  sleep $sleep_time
  color=$(from_hex 0C3C89)
  canvas_draw m "$color" "${lower_left_circle[@]}"
  sleep $sleep_time
  color=$(from_hex F55B8C)
  canvas_draw m "$color" "${lower_left_arm[@]}"
  sleep $sleep_time
  color=$(from_hex F54E2C)
  canvas_draw m "$color" "${lower_circle[@]}"
  sleep $sleep_time
  color=$(from_hex FED33F)
  canvas_draw m "$color" "${lower_right_arm[@]}"
  sleep $sleep_time
  color=$(from_hex 42A722)
  canvas_draw m "$color" "${lower_right_circle[@]}"
  sleep $sleep_time
  color=$(from_hex 44CA46)
  canvas_draw m "$color" "${right_arm[@]}"
  sleep $sleep_time
  color=$(from_hex 1DAB3B)
  canvas_draw m "$color" "${upper_right_circle[@]}"
}

function draw_repeat() {
  while true; do
    tput bold
    tput sgr0
   
    draw_star

    sleep 1

    tput sgr0

    tput dim
    draw_star
  done
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

# Taken from here: https://unix.stackexchange.com/a/269085
from_hex(){
  hex=${1#"#"}
  r=$(printf '0x%0.2s' "$hex")
  g=$(printf '0x%0.2s' "${hex#??}")
  b=$(printf '0x%0.2s' "${hex#????}")
  printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 + 
                       (g<75?0:(g-35)/40)*6   +
                       (b<75?0:(b-35)/40)     + 16 ))"
}

canvas_draw() {
  local symbol=$1
  local color=$2
  shift 2
  local -i column
  local -i row
  local -i max_row
  for i in "$@"
  do
    IFS=',' read -ra coords <<< "$i"
    row=${coords[0]}
    column=${coords[1]} 
    ((column += left_border ))
    ((row += upper_border ))
    tput cup $row $column
    printf "\e[38;5;%sm%s\e[39m" "$color" "$symbol"
    ((max_row=row>max_row?row:max_row))
  done
}

main "$@"

