#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log1.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
inputFile=${1:-input.txt}
days=${2:-80}

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

lanternFish=()
for fish in ${values//,/ }; do
  # echo "$fish"
  lanternFish+=("$fish")
done
unset fish
echo "${lanternFish[*]}" | tr ' ' ','


for ((day=1; day<=days; day++)); do
  moreDifferentFish=()
  newFish=0
  numFish=${#lanternFish[*]}
  now=$(date +%s)
  diff=$((now-started))
  [ $DEBUG -eq 1 ] && echo "Day $day: $numFish $(convertsecs $diff)"
  
  for ((fish=0; fish<numFish; fish++)); do
    disFish=${lanternFish[fish]}
    datFish=$((disFish-1))
    if [ $datFish -lt 0 ]; then
      datFish=6
      newFish=$((newFish+1))
    fi
    moreDifferentFish[$fish]=$datFish
  done

  for ((tng=0; tng<newFish; tng++)); do
    moreDifferentFish+=(8)
  done
  unset lanternFish
  lanternFish=("${moreDifferentFish[@]}")
  unset moreDifferentFish
  unset datFish
  unset disFish
  unset newFish

  # [ $DEBUG -eq 1 ] && echo "${lanternFish[*]}" | tr ' ' ','
done

# [ $DEBUG -eq 1 ] && echo "${lanternFish[*]}" | tr ' ' ','
echo ${#lanternFish[@]}

now=$(date +%s)
diff=$((now-started))
echo "Completed: $(convertsecs $diff)" >> $LOGFILE

