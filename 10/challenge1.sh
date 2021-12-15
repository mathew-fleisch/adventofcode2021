#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day10-challenge1.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
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
in_this() {
  target=$1
  this=$2
  found=0
  for t in $this; do
    [ $t -eq $target ] && found=1 && break
  done
  echo $found
}


# echo "${values[*]}"
# valid=("(" ")" "[" "]" "{" "}" "<" ">")
a="("
b=")"

c="["
d="]"

e="{"
f="}"

g="<"
h=">"

corrupted=()
sleepfor=0
for (( r=0; r<${#values[*]}; r++ )); do
  valid=()
  row=${values[r]}
  corrupt=0
  incomplete=0
  for (( char=0; char<${#row}; char++ )); do
    x="${row:$char:1}"
    lastind=-1
    last=""
    echo "b[${#valid[*]}][$r]: ${valid[*]}" >> $LOGFILE
    case $x in
      $a)
        valid+=($x)
        ;;
      $b)
        lastind=${#valid[*]}
        lastind=$((lastind-1))
        last=${valid[lastind]}
        [[ $last != $a ]] && corrupted+=($x)
        valid+=($x)
        echo "corrupted: ${corrupted[*]}" >> $LOGFILE
        unset valid[$((${#valid[*]}-1))]
        unset valid[$((${#valid[*]}-1))]
        echo " after[b]: ${valid[*]}" >> $LOGFILE
        ;;
      $c)
        valid+=($x)
        ;;
      $d)
        lastind=${#valid[*]}
        lastind=$((lastind-1))
        last=${valid[lastind]}
        [[ $last != $c ]] && corrupted+=($x)
        valid+=($x)
        echo "corrupted: ${corrupted[*]}" >> $LOGFILE
        unset valid[$((${#valid[*]}-1))]
        unset valid[$((${#valid[*]}-1))]
        echo " after[d]: ${valid[*]}" >> $LOGFILE
        ;;
      $e)
        valid+=($x)
        ;;
      $f)
        lastind=${#valid[*]}
        lastind=$((lastind-1))
        last=${valid[lastind]}
        [[ $last != $e ]] && corrupted+=($x)
        valid+=($x)
        echo "corrupted: ${corrupted[*]}" >> $LOGFILE
        unset valid[$((${#valid[*]}-1))]
        unset valid[$((${#valid[*]}-1))]
        echo " after[f]: ${valid[*]}" >> $LOGFILE
        ;;
      $g)
        valid+=($x)
        ;;
      $h)
        lastind=${#valid[*]}
        lastind=$((lastind-1))
        last=${valid[lastind]}
        [[ $last != $g ]] && corrupted+=($x)
        valid+=($x)
        echo "corrupted: ${corrupted[*]}" >> $LOGFILE
        [ $DEBUG -eq 1 ] && echo "corrupted: ${corrupted[*]}"
        unset valid[$((${#valid[*]}-1))]
        unset valid[$((${#valid[*]}-1))]
        echo " after[h]: ${valid[*]}" >> $LOGFILE
        [ $DEBUG -eq 1 ] && echo " after[h]: ${valid[*]}"
        ;;
    esac
    echo "a[${#valid[*]}][$r]: ${valid[*]}" >> $LOGFILE
    [ $DEBUG -eq 1 ] && echo "a[${#valid[*]}][$r]: ${valid[*]}"
    echo "---------------------------------" >> $LOGFILE
    [ $DEBUG -eq 1 ] && echo "---------------------------------"
    sleep $sleepfor
  done
  [ ${#valid[*]} -ne 0 ] && incomplete=1
  echo "valid[$r][$corrupt][$incomplete]: ${valid[*]}" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "valid[$r][$corrupt][$incomplete]: ${valid[*]}"
  echo "corrupted: ${corrupted[*]}" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "corrupted: ${corrupted[*]}"
done

# ): 3 points.    [b]
# ]: 57 points.   [d]
# }: 1197 points. [f]
# >: 25137 points.[h]

total=0
for (( i=0; i<${#corrupted[*]}; i++ )); do
  case ${corrupted[i]} in
    $b)
      total=$((total+3))
      ;;
    $d)
      total=$((total+57))
      ;;
    $f)
      total=$((total+1197))
      ;;
    $h)
      total=$((total+25137))
      ;;
  esac
done
echo "$total" | tee -a $LOGFILE
now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE