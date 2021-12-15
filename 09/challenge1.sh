#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day09-challenge1.txt}
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

# echo "$values"
height=${#values[@]}
n=()
for (( y=0; y<height; y++ )); do
  row=${values[$y]}
  width=${#row}
  # echo "$row"
  for (( x=0; x<width; x++ )); do
    ind=$(((y*width)+x))
    n[$ind]=${row:$x:1}
  done
done

all=${#n[@]}
[ $DEBUG -eq 1 ] && echo "height: $height"
[ $DEBUG -eq 1 ] && echo "width:  $width"
[ $DEBUG -eq 1 ] && echo "length: $all"
echo "height: $height" >> $LOGFILE
echo "width:  $width" >> $LOGFILE
echo "length: $all" >> $LOGFILE

find_lowest_points() {
  lowest=()
  for (( y=0; y<height; y++ )); do
    row=""
    for (( x=0; x<width; x++ )); do
      islowest=1
      ind=$(((y*width)+x))
      a=$((((y-1)*width)+(x-1)))
      b=$((((y-1)*width)+(x-0)))
      c=$((((y-1)*width)+(x+1)))
      d=$((((y-0)*width)+(x-1)))
      e=$((((y-0)*width)+(x+1)))
      f=$((((y+1)*width)+(x-1)))
      g=$((((y+1)*width)+(x-0)))
      h=$((((y+1)*width)+(x+1)))
      # [ $a -gt 0 ] && [ $a -lt $width ] 
      [ $a -ge 0 ] && [ $a -lt $all ] && [ ${n[$a]} -le ${n[$ind]} ] && islowest=0
      [ $b -ge 0 ] && [ $b -lt $all ] && [ ${n[$b]} -le ${n[$ind]} ] && islowest=0
      [ $c -ge 0 ] && [ $c -lt $all ] && [ ${n[$c]} -le ${n[$ind]} ] && islowest=0
      [ $d -ge 0 ] && [ $d -lt $all ] && [ ${n[$d]} -le ${n[$ind]} ] && islowest=0
      [ $e -ge 0 ] && [ $e -lt $all ] && [ ${n[$e]} -le ${n[$ind]} ] && islowest=0
      [ $f -ge 0 ] && [ $f -lt $all ] && [ ${n[$f]} -le ${n[$ind]} ] && islowest=0
      [ $g -ge 0 ] && [ $g -lt $all ] && [ ${n[$g]} -le ${n[$ind]} ] && islowest=0
      [ $h -ge 0 ] && [ $h -lt $all ] && [ ${n[$h]} -le ${n[$ind]} ] && islowest=0
      [ $islowest -eq 1 ] && row="${row}•" && lowest+=(${n[$ind]}) || row="${row}."
      # [ $islowest -eq 1 ] && row="${row}•" && lowest+=(${n[$ind]}) || row="${row}${n[$ind]}"
    done
    [ $DEBUG -eq 1 ] && echo "$row"
    echo "$row" >> $LOGFILE
  done
  total=0
  for (( t=0; t<${#lowest[@]}; t++ )); do
    low=${lowest[$t]}
    total=$((total+low+1))
  done
  echo $total | tee -a $LOGFILE
}

find_lowest_points

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE