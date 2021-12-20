#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day11-challenge1.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
inputFile=${1:-input.txt}

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}


answer_one="Not Implemented"

echo "$answer_one" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE
