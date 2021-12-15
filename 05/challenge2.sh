#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day05-challenge2.txt}
inputFile=${1:-input.txt}
boardFile=${2:-board2.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
skipDiagonals=${3:-0}
boardSize=${4:-1000}

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}

if [ $boardSize -eq 10 ]; then
  b=()
  for ((t=0; t<$((boardSize*boardSize)); t++)); do
    b[t]=0
  done
else
  # Initialize 1000x1000 element array (generated from ./generate-intializer.sh)
  source "${scriptPath}/initialize-variables.sh"
fi

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}
draw_line() {

  x1=$1
  x2=$2
  y1=$3
  y2=$4

  xmin=$x1
  xmax=$x2
  if [ $x1 -gt $x2 ]; then
    xmin=$x2
    xmax=$x1
  fi
  ymin=$y1
  ymax=$y2
  if [ $y1 -gt $y2 ]; then
    ymin=$y2
    ymax=$y1
  fi
  [ $DEBUG -eq 1 ] && echo "draw_line(${x1}x${y1} -> ${x2}x${y2})"
  echo "draw_line(${x1}x${y1} -> ${x2}x${y2})" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "xmin:$xmin xmax:$xmax ymin:$ymin ymax:$ymax"
  echo "xmin:$xmin xmax:$xmax ymin:$ymin ymax:$ymax" >> $LOGFILE
  line_length=0
  if [ $x1 -ne $x2 ] && [ $y1 -ne $y2 ]; then
    y=$y1
    for ((x=xmin; x<=xmax; x++)); do
      if [ $y1 -gt $y2 ]; then
        # Diagonal Going Up (forward slash)
        y=$((ymax-line_length))
      else
        # Diagonal Going Down (Backward slash)
        y=$((ymin+line_length))
      fi
      index=$((y*boardSize+x))
      b[index]=$((b[index]+1))
      # [ $DEBUG -eq 1 ] && echo "b[${x}x${y}:$index]: ${b[index]}"
      line_length=$((line_length+1))
    done

  else
    for ((x=xmin; x<=xmax; x++)); do
      for ((y=ymin; y<=ymax; y++)); do
        index=$((y*boardSize+x))
        b[index]=$((b[index]+1))
        line_length=$((line_length+1))
      done
    done
  fi
}
evaluate_line() {
  raw_line=$1
  input="${raw_line/,/ }"
  input="${input/ -> / }"
  input="${input/,/ }"
  skipDiag=$2
  # UGH
  input_track=0
  for inp in $input; do
    case $input_track in
      0)
        x1=$inp
        ;;
      1)
        y1=$inp
        ;;
      2)
        x2=$inp
        ;;
      3)
        y2=$inp
        ;;
    esac
    input_track=$((input_track + 1))
  done
  # Horizontal or diagonal lines should start from the left. swap x1,y1 with x2,y2
  if [ $x1 -gt $x2 ]; then
    x3=$x2
    y3=$y2
    x2=$x1
    y2=$y1
    x1=$x3
    y1=$y3
    unset x3
    unset y3
  fi

  if [ $x1 -ne $x2 ] && [ $y1 -ne $y2 ]; then
    # Ignore diagonals
    if [ $skipDiag -eq 1 ]; then
      [ $DEBUG -eq 1 ] && echo "Diagonal line... skip!"
      echo "Diagonal line... skip!" >> $LOGFILE
    else
      [ $DEBUG -eq 1 ] && echo "Diagonal line... don't skip! :("
      echo "Diagonal line... don't skip! :(" >> $LOGFILE
      draw_line $x1 $x2 $y1 $y2
    fi
  else
    # This should be a horizontal or vertical line
    if [ $x1 -eq $x2 ]; then
      [ $DEBUG -eq 1 ] && echo "Vertical line"
      echo "Vertical line" >> $LOGFILE
      draw_line $x1 $x2 $y1 $y2
    else
      [ $DEBUG -eq 1 ] && echo "Horizontal line"
      echo "Horizontal line" >> $LOGFILE
      draw_line $x1 $x2 $y1 $y2
    fi
    
  fi
}

# This iteration will cycle through each line vector
for ((row=0; row<inputLength; row++)); do
  [ $DEBUG -eq 1 ] && echo "-----$row-----"
  echo "-----$row-----" >> $LOGFILE
  now=$(date +%s)
  diff=$((now-started))
  [ $DEBUG -eq 1 ] && echo "Runtime: $(convertsecs $diff)"
  echo "Runtime: $(convertsecs $diff)" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "${values[$row]}"
  echo "${values[$row]}" >> $LOGFILE
  evaluate_line "${values[$row]}" $skipDiagonals
done


now=$(date +%s)
diff=$((now-started))

intersections=0
# Generating the board takes most of the time. If the file exists,
# skip this step and just show the output.
if [ -f $boardFile ]; then
  echo "${b[*]}" \
    | tr ' ' '\n' \
    | sort \
    | awk NF \
    | uniq -c \
    | awk '{print $2,$1}' \
    | grep -vE '^(0|1)' \
    | awk '{print $2}' \
    | xargs \
    | sed -e 's/\ /+/g' \
    | bc \
    | tee -a $LOGFILE
else
  echo "" > $boardFile
  [ $DEBUG -eq 1 ] && echo "Saving board output: $(convertsecs $diff)"
  echo "Saving board output: $(convertsecs $diff)" >> $LOGFILE
  for ((y=0; y<boardSize; y++)); do
    row=""
    for ((x=0; x<boardSize; x++)); do
      index=$((y*boardSize+x))
      # [ $DEBUG -eq 1 ] && echo "${x},${y}:$index => ${b[index]}"
      pixel="."
      [ ${b[index]} -eq 1 ] && pixel="•"
      [ ${b[index]} -gt 1 ] && pixel="${b[index]}" && intersections=$((intersections+1))
      row="${row}${pixel}"
    done
    echo "$row" >> $boardFile
    [ $DEBUG -eq 1 ] && echo "row: ${y}"
    echo "row: ${y}" >> $LOGFILE
  done
  echo "$intersections" | tee -a $LOGFILE
fi

if [ $boardSize -eq 10 ]; then
  [ $DEBUG -eq 1 ] && cat $boardFile
  cat $boardFile >> $LOGFILE
fi

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE

