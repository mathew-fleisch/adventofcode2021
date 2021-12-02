#!/bin/bash
#shellcheck disable=SC2086

inputFile=${1:-input.txt}
index=0
increases=0

IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"

while [ $index -lt $inputLength ]; do

  windowCurrent=$((values[index] + values[index+1] + values[index+2]))
  windowCompare=$((values[index+1] + values[index+2] + values[index+3]))
  compare=">"
  direction="-"
  if [ $windowCompare -gt $windowCurrent ]; then
    increases=$((increases+1))
    compare="<"
    direction="+"
  fi

  [ $DEBUG -eq 1 ] && echo "$index: ${values[$index]} $direction $windowCurrent $compare $windowCompare"
  
  index=$((index+1))

done

echo "$increases"

