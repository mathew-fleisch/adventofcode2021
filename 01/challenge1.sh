#!/bin/bash
#shellcheck disable=SC2086

inputFile=${1:-input.txt}
IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}
echo "Lines: $inputLength"
lastValue=0
increases=0
track=0
while IFS= read -r val; do
  direction="-"
  track=$((track+1))
  if [ $track -ne 1 ]; then
    if [ $val -gt $lastValue ]; then
      increases=$((increases+1))
      direction="+"
    fi
  else
    direction="N/A"
  fi

  echo "$val $direction"
  lastValue=$val
done < $inputFile

echo "Increases: $increases"
