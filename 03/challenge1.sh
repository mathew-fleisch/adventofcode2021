#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
inputFile=${1:-input.txt}

IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
index=0
buckets=()

while [ $index -lt $inputLength ]; do

  [ $DEBUG -eq 1 ] && echo "$index: ${values[$index]}"
  if [ $index -eq 0 ]; then
    trackBucket=0
    while [ $trackBucket -lt ${#values[$index]} ]; do
      buckets[$trackBucket]=0
      trackBucket=$((trackBucket + 1))
    done
  fi
  this=${values[$index]}
  trackBucket=0
  while [ $trackBucket -lt ${#values[$index]} ]; do
    that=${this:$trackBucket:1}
    buckets[$trackBucket]=$((buckets[trackBucket] + that))
    trackBucket=$((trackBucket + 1))
  done
  
  index=$((index + 1))
done

bgamma=""
bepsilon=""

for bit in ${buckets[*]}; do
  if [ $bit -gt $((inputLength / 2)) ]; then
    bgamma="${bgamma}1"
    bepsilon="${bepsilon}0"
  else
    bgamma="${bgamma}0"
    bepsilon="${bepsilon}1"
  fi
done
gamma=$((2#$bgamma))
epsilon=$((2#$bepsilon))

[ $DEBUG -eq 1 ] && echo "buckets: ${buckets[*]}"
[ $DEBUG -eq 1 ] && echo "gamma:   $bgamma : $gamma" 
[ $DEBUG -eq 1 ] && echo "epsilon: $bepsilon : $epsilon"
echo $((gamma * epsilon))