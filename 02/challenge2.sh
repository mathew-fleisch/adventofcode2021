#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
inputFile=${1:-input.txt}

IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
index=0
forwardHeading=0
depth=0
aim=0

while [ $index -lt $inputLength ]; do

  [ $DEBUG -eq 1 ] && echo "$index: ${values[$index]}"
  
  if [[ "${values[$index]}" =~ forward ]]; then
    this="${values[$index]}"
    val="${this//forward }"
    forwardHeading=$((val + forwardHeading))
    depth=$((depth + aim * val))
  fi

  if [[ "${values[$index]}" =~ up ]]; then
    this="${values[$index]}"
    val="${this//up }"
    aim=$((aim - val))
  fi

  if [[ "${values[$index]}" =~ down ]]; then
    this="${values[$index]}"
    val="${this//down }"
    aim=$((aim + val))
  fi

  index=$((index + 1))

done
[ $DEBUG -eq 1 ] && echo "forward: $forwardHeading"
[ $DEBUG -eq 1 ] && echo "depth: $depth"
[ $DEBUG -eq 1 ] && echo "aim: $aim"
echo $((forwardHeading * depth))
