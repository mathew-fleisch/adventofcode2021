#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day02-challenge1.txt}
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
index=0
forwardHeading=0
depth=0
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

while [ $index -lt $inputLength ]; do

  [ $DEBUG -eq 1 ] && echo "$index: ${values[$index]}"
  echo "$index: ${values[$index]}" >> $LOGFILE
  
  if [[ "${values[$index]}" =~ forward ]]; then
    this="${values[$index]}"
    val="${this//forward }"
    forwardHeading=$((val + forwardHeading))
  fi

  if [[ "${values[$index]}" =~ up ]]; then
    this="${values[$index]}"
    val="${this//up }"
    depth=$((depth - val))
  fi

  if [[ "${values[$index]}" =~ down ]]; then
    this="${values[$index]}"
    val="${this//down }"
    depth=$((depth + val))
  fi
  
  index=$((index + 1))

done
[ $DEBUG -eq 1 ] && echo "forward: $forwardHeading"
echo "forward: $forwardHeading" >> $LOGFILE
[ $DEBUG -eq 1 ] && echo "depth: $depth"
echo "depth: $depth" >> $LOGFILE
echo $((forwardHeading * depth)) | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE