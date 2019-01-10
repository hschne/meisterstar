#!/usr/bin/env bash

main() {
  parse_star_parts

  clear
  tput civis

  set_borders

  local writing_start
  (( writing_start=left_border+21 ))
  tput cup 27 $writing_start
  echo "M E I S T E R"

  tput dim
  draw_star
  tput sgr0
  animate_star
}

function star() {
cat << EOF
                                                   
                         *****                     
                       *********                   
                      ***********                  
                     *************                 
                    ***************                
                   *****************               
                  @@@@@@*******xxxxxx              
     ////////////@@@@@@@@** **xxxxxxxx(((((((((((( 
    /////////////@@@@@@@@*   *xxxxxxxx(((((((((((((
   ///////////////@@@@@@       xxxxxx((((((((((((((
    ////////////////               ((((((((((((((((
      ////////////                   ((((((((((((  
        //////%%%%%%               #####(((((((    
          ///%%%%%%%%             ########(((      
            /%%%%%%%%%           #########(        
              %%%%%%%             #######          
             !!!!!!!!  !ooooooo&  &&&&&&&&         
            !!!!!!!!!!!ooooooooo&&&&&&&&&&&        
            !!!!!!!!!!!ooooooooo&&&&&&&&&&&        
            !!!!!!!!!!!!!ooooo&&&&&&&&&&&&&        
           !!!!!!!!!!!!!!!   &&&&&&&&&&&&&&&       
           !!!!!!!!!!!           &&&&&&&&&&&       
            !!!!!!                   &&&&&&     

EOF
}

set_borders() {
  (( terminal_width=$(tput cols) ))
  (( left_border="$terminal_width"/2 - 25 ))
  upper_border=2
}

# Parses the contents of 'star' and converts the symbols in there to an array with their coordinates. 
#
# Arguments: 
#  $1 - The array to parse into as nameref
#  $2 - The character to parse
#
# Example: 
#  parse_star out_array * 
parse_star() {
  typeset -n result=$1
  local character=$2
  local star
  star=$(star)
  local row=0 
  local col=0
  for i in $(seq 1 ${#star}); do
    local current_character=${star:i-1:1}
    if [[ $current_character == $'\n' ]]; then 
      (( row++))
      col=0; 
      continue; 
    fi
    [[ "$current_character" == "$character" ]] && result+=( "$row,$col" )
    ((col++))
  done
}

parse_star_parts() {
  parse_star upper_arm \*
  parse_star left_arm /
  parse_star lower_left_arm \!
  parse_star lower_right_arm \&
  parse_star right_arm \(
  parse_star upper_left_circle @
  parse_star lower_left_circle %
  parse_star lower_circle o
  parse_star lower_right_circle \#
  parse_star upper_right_circle x
}

# Draw the various star parts with a slight delay
draw_star() {
  sleep_time=0.03
  color=$(hex_to_color_code 37D7D7)
  draw m "$color" "${upper_arm[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code 188ED5)
  draw m "$color" "${upper_left_circle[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code 1CA8FC)
  draw m "$color" "${left_arm[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code 0C3C89)
  draw m "$color" "${lower_left_circle[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code F55B8C)
  draw m "$color" "${lower_left_arm[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code F54E2C)
  draw m "$color" "${lower_circle[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code FED33F)
  draw m "$color" "${lower_right_arm[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code 42A722)
  draw m "$color" "${lower_right_circle[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code 44CA46)
  draw m "$color" "${right_arm[@]}"
  sleep $sleep_time
  color=$(hex_to_color_code 1DAB3B)
  draw m "$color" "${upper_right_circle[@]}"
}

# Repeatedly redraw the star
animate_star() {
  while true; do
    tput sgr0
    tput bold
    draw_star

    sleep 1

    tput sgr0
    tput dim
    draw_star
  done
}

# Converts a given hex code to 256 color. Uses dark magic.
# Taken from here: https://unix.stackexchange.com/a/269085
hex_to_color_code(){
  hex=${1#"#"}
  r=$(printf '0x%0.2s' "$hex")
  g=$(printf '0x%0.2s' "${hex#??}")
  b=$(printf '0x%0.2s' "${hex#????}")
  printf '%03d' "$(( (r<75?0:(r-35)/40)*6*6 + 
                       (g<75?0:(g-35)/40)*6   +
                       (b<75?0:(b-35)/40)     + 16 ))"
}

# Draw the given array in the terminal with respect to canvas position.
#
# Arguments: 
#   $1 - The symbol that should be printed
#   $2 - The color code to use, as 256 color code
#   $@ - The array. Array elements must have the form 'x, y' where x denotes the row and y the column of the terminal.
#
# Example: 
#   draw x 91 '1,1' '2,2' '3,3'
draw() {
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

on_exit() {
  clear; tput cnorm;
  trap - EXIT
  exit
}

declare -a upper_arm
declare -a left_arm
declare -a lower_left_arm
declare -a lower_right_arm
declare -a right_arm
declare -a upper_left_circle
declare -a lower_left_circle
declare -a lower_circle
declare -a lower_right_circle
declare -a upper_right_circle

declare -i upper_border
declare -i left_border

trap on_exit EXIT

main "$@"
