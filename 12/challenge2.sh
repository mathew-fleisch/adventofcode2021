#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day12-challenge2.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
inputFile=${1:-input.txt}
# Unique values
u=()
# Connections
c=()
# Big Caverns
b=()
# Start/end indexies
startInd=-1
endInd=-1

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;
width=0
height=${#values[@]}

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}
in_array() {
  target=$1
  arr=$2
  found=0
  find=-1
  for t in $arr; do
    # [ $DEBUG -eq 1 ] && echo "$t =? $target" >> $LOGFILE
    find=$((find+1))
    [ "$t" = "$target" ] && found=1 && break
  done
  # [ $DEBUG -eq 1 ] && echo "in_array($target) => $found" >> $LOGFILE
  [ $found -eq 1 ] && echo $find || echo -1
  # sleep 1
}

# Identify unique caverns
for (( r=0; r<height; r++ )); do
  [ $DEBUG -eq 1 ] && echo "-----------------------------"
  echo "-----------------------------" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "$r: ${values[$r]}"
  echo "$r: ${values[$r]}" >> $LOGFILE
  width=${#values[*]}
  split=${values[$r]//-/ }
  left=""
  right=""
  for t in $split; do [ -z "$left" ] && left=$t || right=$t; done
  [ $DEBUG -eq 1 ] && echo "left: $left => $(in_array $left "${u[*]}")"
  echo "left: $left => $(in_array $left "${u[*]}")" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "right: $right => $(in_array $right "${u[*]}")"
  echo "right: $right => $(in_array $right "${u[*]}")" >> $LOGFILE
  if [ $(in_array $left "${u[*]}") -lt 0 ]; then
    u+=($left)
    lind=$(in_array $left "${u[*]}")
    [[ "$left" =~ [[:upper:]] ]] && b[$lind]=1 || b[$lind]=0
    [[ "$left" = "start" ]] && startInd=$lind
    [[ "$left" = "end" ]] && endInd=$lind
    [ $right != "start" ] && c[$lind]="${c[$lind]} ${right}"
  else
    lind=$(in_array $left "${u[*]}")
    [ $right != "start" ] && c[$lind]="${c[$lind]} ${right}"
  fi
  if [ $(in_array $right "${u[*]}") -lt 0 ]; then
    u+=($right)
    rind=$(in_array $right "${u[*]}")
    [[ "$right" =~ [[:upper:]] ]] && b[$rind]=1 || b[$rind]=0
    [[ "$right" = "start" ]] && startInd=$rind
    [[ "$right" = "end" ]] && endInd=$rind
    [ $left != "start" ] && c[$rind]="${c[$rind]} ${left}"
  else
    rind=$(in_array $right "${u[*]}")
    [ $left != "start" ] && c[$rind]="${c[$rind]} ${left}"
  fi
done
masterTrack=0

find_path() {
  masterTrack=$((masterTrack+1))
  startWith=$1
  comingFrom=$2
  echo "------------------------" >> $LOGFILE
  echo "  this: $startWith" >> $LOGFILE
  echo "  that: $comingFrom" >> $LOGFILE
  if [ $startWith -eq $endInd ]; then
    out="" && for cf in $comingFrom; do [ $cf -ge 0 ] && out="$out,${u[$cf]}"; done
    echo "${out},end"
    comingFrom=""
  else
    for startPath in ${c[$startWith]}; do
      echo "START PATH: $startPath" >> $LOGFILE
      thisCavern=-1
      for (( tu=0; tu<${#u[*]}; tu++ )); do
        if [ ${u[$tu]} = $startPath ]; then
          cffound=0
          [ "${b[$tu]}" -eq 0 ] && for cf in $comingFrom; do [ $cf -eq $tu ] && cffound=$((cffound+1)); done
          echo "Target case: ${u[$tu]} => $([ "${b[$tu]}" -eq 1 ] && echo upper || echo lower)" >> $LOGFILE
          echo "Target seen: ${u[$tu]} => $cffound" >> $LOGFILE

          if [ $cffound -le 1 ]; then
            thisCavern=$tu
            break
          fi
        fi
      done
      [ $thisCavern -ne -1 ] && echo "$(find_path $thisCavern "$comingFrom $startWith")"
    done
  fi
  if [ $startWith -ge 0 ]; then
    if [[ ${c[$startWith]} =~ end ]]; then
      out=""
      for cf in $comingFrom; do 
        [ $cf -ge 0 ] && out="$out,${u[$cf]}"
      done
      echo "find_path() => $out,${u[$startWith]},end" >> $LOGFILE
      echo "$out,${u[$startWith]},end"
    fi
  fi
}


[ $DEBUG -eq 1 ] && echo "connections:"
echo "connections:" >> $LOGFILE
for (( r=0; r<${#u[*]}; r++ )); do
  [ $DEBUG -eq 1 ] && echo "u[$r]{${u[$r]}}: ${c[$r]}"
  echo "u[$r]{${u[$r]}}: ${c[$r]}" >> $LOGFILE
done
echo "height: $height" >> $LOGFILE
echo " width: $width" >> $LOGFILE
echo "unique: ${u[*]}" >> $LOGFILE
echo " upper: ${b[*]}" >> $LOGFILE
echo " start: $startInd" >> $LOGFILE
echo "   end: $endInd" >> $LOGFILE

correct_path() {
  thisPath=${1//,/ }
  p=0
  correct=1
  lazyCorrect=0
  counts=()
  # echo "$thisPath"
  for (( w=0; w<${#u[*]}; w++ )); do counts[$w]=0; done
  for tp in $thisPath; do
    for (( w=0; w<${#u[*]}; w++ )); do 
      [ ${u[$w]} = $tp ] \
        && [ ${b[$w]} -eq 0 ] \
        && counts[$w]=$((counts[w]+1)) && break; done
    p=$((p+1))
  done
  for lazy in ${counts[*]}; do
    [ $lazy -gt 1 ] && lazyCorrect=$((lazyCorrect+1))
  done
  [ $lazyCorrect -gt 1 ] && correct=0
  echo $correct
}

pathCount=0
uniqPaths=()
for path in $(find_path $startInd -1); do
  if [ $path != ",end" ]; then
    tpath=${path/,/}
    if [ $(correct_path $tpath) -eq 1 ]; then
      if ! [[ "${uniqPaths[*]}" =~ $tpath ]]; then
        echo "$tpath" >> $LOGFILE
        pathCount=$((pathCount+1))
        uniqPaths+=("$tpath")
      fi
    fi
  fi
done
echo "Path Count: $pathCount" >> $LOGFILE

answer_two="$pathCount"

echo "$answer_two" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE
