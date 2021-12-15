#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day10-challenge2.txt}
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
incomplete=()
sleepfor=0
for (( r=0; r<${#values[*]}; r++ )); do
  valid=()
  row=${values[r]}
  corrupt=0
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
        [[ $last != $a ]] && corrupted+=($x) && corrupt=$((corrupt+1))
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
        [[ $last != $c ]] && corrupted+=($x) && corrupt=$((corrupt+1))
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
        [[ $last != $e ]] && corrupted+=($x) && corrupt=$((corrupt+1))
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
        [[ $last != $g ]] && corrupted+=($x) && corrupt=$((corrupt+1))
        valid+=($x)
        [ $DEBUG -eq 1 ] && echo "corrupted: ${corrupted[*]}"
        echo "corrupted: ${corrupted[*]}" >> $LOGFILE
        unset valid[$((${#valid[*]}-1))]
        unset valid[$((${#valid[*]}-1))]
        echo " after[h]: ${valid[*]}" >> $LOGFILE
        ;;
    esac
    [ $DEBUG -eq 1 ] && echo "a[${#valid[*]}][$r]: ${valid[*]}"
    echo "a[${#valid[*]}][$r]: ${valid[*]}" >> $LOGFILE
    [ $DEBUG -eq 1 ] && echo "---------------------------------"
    echo "---------------------------------" >> $LOGFILE
    sleep $sleepfor
  done
  [ ${#valid[*]} -ne 0 ] && [ $corrupt -eq 0 ] && incomplete+=("${valid[*]}")
  [ $DEBUG -eq 1 ] && echo "valid[$r][$corrupt]: ${valid[*]}"
  echo "valid[$r][$corrupt]: ${valid[*]}" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "corrupted: ${corrupted[*]}"
  echo "corrupted: ${corrupted[*]}" >> $LOGFILE
done



# ): 3 points.    [b]
# ]: 57 points.   [d]
# }: 1197 points. [f]
# >: 25137 points.[h]

# total=0
# for (( i=0; i<${#corrupted[*]}; i++ )); do
#   case ${corrupted[i]} in
#     $b)
#       total=$((total+3))
#       ;;
#     $d)
#       total=$((total+57))
#       ;;
#     $f)
#       total=$((total+1197))
#       ;;
#     $h)
#       total=$((total+25137))
#       ;;
#   esac
# done
# echo "$total"

# echo "${incomplete[*]}"

# for row in "${incomplete[*]}"; do
#   echo "$row"
# done

sortNmiddle() {
  raw=$1
  for r in $raw; do arr+=($r); done
  for (( i=0; i<${#arr[*]}; i++ )); do
    for (( j=0; j<${#arr[*]}; j++ )); do
      if [ ${arr[$j]} -gt ${arr[$i]} ]; then
        tmp=${arr[$i]}
        arr[$i]=${arr[$j]}
        arr[$j]=$tmp        
      fi
    done
  done
  total=${#arr[*]}
  half=$((((total-1)/2)))

  echo "${arr[$half]}"
}

# ): 1 point.
# ]: 2 points.
# }: 3 points.
# >: 4 points.

completed=""
for (( r=0; r<${#incomplete[*]}; r++ )); do
  row="${incomplete[r]// /}"
  last=${#row}
  last=$((last-1))
  echo "count[${#row}]: $row" >> $LOGFILE
  finish=()
  subtotal=0
  for (( l=last; l>=0; l-- )); do
    char=${row:$l:1}
    echo "$l: $char" >> $LOGFILE
    case $char in
      $a)
        finish+=($b)
        subtotal=$(((subtotal*5)+1))
        ;;
      $c)
        finish+=($e)
        subtotal=$(((subtotal*5)+2))
        ;;
      $e)
        finish+=($f)
        subtotal=$(((subtotal*5)+3))
        ;;
      $g)
        finish+=($h)
        subtotal=$(((subtotal*5)+4))
        ;;
    esac
  done
  completed="$completed $subtotal"
  [ $DEBUG -eq 1 ] && echo "${finish[*]// /}: $subtotal"
  echo "${finish[*]// /}: $subtotal" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "----------------------"
  echo "----------------------" >> $LOGFILE
done

sortNmiddle "${completed}" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE