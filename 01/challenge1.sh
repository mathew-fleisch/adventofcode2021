#!/bin/bash
#shellcheck disable=SC2086

inputFile=${1:-input.txt}
values=$(cat $inputFile)
lastValue=9999999
increases=0
track=0
for val in $values; do
  direction="-"
  track=$((track+1))
  if [ $val -gt $lastValue ]; then
    increases=$((increases+1))
    direction="+"
  fi

  echo "$val $direction"
  lastValue=$val
done

echo "Increases: $increases"