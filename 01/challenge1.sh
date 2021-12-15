#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day01-challenge1.txt}
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

  [ $DEBUG -eq 1 ] && echo "$val $direction"
  echo "$val $direction" >> $LOGFILE
  lastValue=$val
done < $inputFile

echo "$increases" | tee -a $LOGFILE


now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE