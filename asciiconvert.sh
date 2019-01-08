#!/usr/bin/env bash
main () {
  outfile=${1%.*}.pgm
  size=$2
  ((width=$size))
  ((height=$size/2))
  threshold=$3
  tmpfile=$(mktemp).pgm
  convert $1 -threshold "$threshold%" -resize "${width}x${height}!" -compress none -type grayscale $tmpfile
  # Clear existing content
  > $outfile
  # Keep first 3 lines intact
  # Normalize the rest of the lines 
  sed -n '4,$p' $tmpfile  | sed 's/255/1/g' | tr -d ' \t\r' 
}

main $@
