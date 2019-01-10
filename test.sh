main() {
  res=$(echo_eof)
  local row=0 
  for i in $(seq 1 ${#res}); do
    char="${res:i-1:1}"
    [[ $char == $'\n' ]] && { (( row++)); continue; }
    [[ $char != "\n" ]] && printf "Row: %s, Char: %s \n" "$row" "$char"
  done
}

function echo_eof() {
cat << EOF
Line 1
Line2 
L3
EOF
}


main "$@"
