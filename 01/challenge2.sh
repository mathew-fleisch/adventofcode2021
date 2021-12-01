#!/bin/bash
#shellcheck disable=SC2086

inputFile=${1:-input.txt}
inputLength=$(wc -l $inputFile | awk '{print $1}')
index=0
increases=0

echo "Lines: $inputLength"
IFS=$'\n' read -d '' -r -a values < $inputFile;

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

  echo "$index: ${values[$index]} $direction $windowCurrent $compare $windowCompare"
  
  index=$((index+1))

done

echo "Increases: $increases"

