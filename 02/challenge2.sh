#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day02-challenge2.txt}
inputFile=${1:-input.txt}

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE
index=0
forwardHeading=0
depth=0
aim=0

while [ $index -lt $inputLength ]; do

  [ $DEBUG -eq 1 ] && echo "$index: ${values[$index]}"
  echo "$index: ${values[$index]}" >> $LOGFILE
  
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
echo "forward: $forwardHeading" >> $LOGFILE
echo "depth: $depth" >> $LOGFILE
echo "aim: $aim" >> $LOGFILE
echo $((forwardHeading * depth)) | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE