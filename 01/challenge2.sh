#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day01-challenge2.txt}
inputFile=${1:-input.txt}
index=0
increases=0

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
  echo "$index: ${values[$index]} $direction $windowCurrent $compare $windowCompare" >> $LOGFILE
  
  index=$((index+1))

done

echo "$increases" | tee -a $LOGFILE


now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE