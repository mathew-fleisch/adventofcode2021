#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log1.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
inputFile=${1:-input.txt}

started=$(date +%s)
# echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

smallest=99999999
largest=0
fuel=0
for crab in ${values//,/ }; do
  [ $crab -lt $smallest ] && smallest=$crab
  [ $crab -gt $largest ] && largest=$crab
done
[ $DEBUG -eq 1 ] && echo "Smallest: $smallest"
[ $DEBUG -eq 1 ] && echo "Largest: $largest"


fibonacci=0
fib=(0)
for ((t=0; t<=largest; t++)); do
  fibonacci=$((fibonacci+t))
  fib[$t]=$fibonacci
done

evaluate_target() {
  crabs=$1
  target=$2
  fuel=0
  count=0
  for crab in ${crabs//,/ }; do
    tfuel=0
    tffuel=0
    if [ $crab -gt $target ]; then
      tfuel=$((crab-target))
    else
      tfuel=$((target-crab))
    fi
    tffuel=${fib[$tfuel]}
    fuel=$((fuel+tffuel))
    count=$((count+1))
  done
  [ $DEBUG -eq 1 ] && echo "$count crabs[target:$target] fuel: $fuel" >> $LOGFILE
  echo $fuel
}


best=999999999999999
notfound=0
# SKIP BRUTE FORCE... This time
for ((crab=480; crab<=largest; crab++)); do
  thisFuel=$(evaluate_target "$values" $crab)

  now=$(date +%s)
  diff=$((now-started))
  [ $thisFuel -lt $best ] && best=$thisFuel && notfound=0
  [ $DEBUG -eq 1 ] && echo "$crab: $thisFuel $(convertsecs $diff) => $thisFuel | $best"
  notfound=$((notfound+1))
  [ $notfound -gt 1 ] && break
done

echo $best