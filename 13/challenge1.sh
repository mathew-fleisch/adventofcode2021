#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day12-challenge1.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
inputFile=${1:-input.txt}
boardFile=${2:-board1.txt}

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;
height=${#values[@]}

b=()
n=()
in=()
numIn=0
fold=()
numFold=0
limitX=0
limitY=0

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
    find=$((find+1))
    [ "$t" = "$target" ] && found=1 && break
  done
  [ $found -eq 1 ] && echo $find || echo -1
}
display_board() {
  [ $DEBUG -eq 1 ] && echo "display_board(limitX:$limitX, limitY:$limitY)"
  echo "display_board(limitX:$limitX, limitY:$limitY)" >> $LOGFILE
  for (( dy=0; dy<limitY; dy++ )); do
    local drow=""
    for (( dx=0; dx<limitX; dx++ )); do
        local dind=$(((dy*limitX)+dx))
        # echo "display: ${dx},${dy}[$dind]: ${b[$dind]}" >> $LOGFILE
        [ ${b[$dind]} -eq 0 ] && dis="." || dis="#"
        drow="$drow$dis"
    done
    echo "$drow"
  done
}


# Parse source data
now=$(date +%s)
diff=$((now-started))
[ $DEBUG -eq 1 ] && echo "Parsing source data: $(convertsecs $diff)"
echo "Parsing source data: $(convertsecs $diff)" >> $LOGFILE
for (( r=0; r<height; r++ )); do
  # echo "-----------------------------"
  row=${values[$r]}
  # echo "$r: $row"
  if [[ "$row" =~ ^fold ]]; then
    # echo "$row"
    tfold=${row//fold\ along\ /}
    tfold=${tfold//=/ }
    fold+=("$tfold")
    numFold=$((numFold+1))
  else
    spl=${row//,/ }
    tx=""; ty="";
    for s in $spl; do [ -z "$tx" ] && tx="$s" || ty="$s"; done
    # echo "${tx}x${ty}"
    [ $tx -gt $limitX ] && limitX=$tx
    [ $ty -gt $limitY ] && limitY=$ty
    in+=("$tx $ty")
    numIn=$((numIn+1))
  fi
done
limitY=$((limitY+1))
limitX=$((limitX+1))
now=$(date +%s)
diff=$((now-started))
[ $DEBUG -eq 1 ] && echo "Parsing source data complete: $(convertsecs $diff)" 
[ $DEBUG -eq 1 ] && echo "Initial limit-x: $limitX"
[ $DEBUG -eq 1 ] && echo "Initial limit-y: $limitY"
echo "Parsing source data complete: $(convertsecs $diff)" >> $LOGFILE
echo "Initial limit-x: $limitX" >> $LOGFILE
echo "Initial limit-y: $limitY" >> $LOGFILE
# Now that limits are established, zero out the board
[ $DEBUG -eq 1 ] && echo "Creating array of zeros. size: ${limitX}x${limitY} => $((limitX*limitY))"
echo "Creating array of zeros. size: ${limitX}x${limitY} => $((limitX*limitY))" >> $LOGFILE
for (( y=0; y<limitY; y++ )); do
  for (( x=0; x<limitX; x++ )); do
    ind=$(((y*limitX)+x))
    b[$ind]=0
  done
done


# display_board


# 
# echo "input: ${in[*]}"
# echo " fold: ${fold[*]}"
now=$(date +%s)
diff=$((now-started))
[ $DEBUG -eq 1 ] && echo "Setting board state from input data: $(convertsecs $diff)"
echo "Setting board state from input data: $(convertsecs $diff)" >> $LOGFILE

for (( i=0; i<numIn; i++ )); do
  # echo "INPUT: $i: ${in[$i]}"
  tx=""; ty="";
  for s in ${in[$i]}; do [ -z "$tx" ] && tx="$s" || ty="$s"; done
  # echo "${tx}x${ty}"
  ind=$(((ty*limitX)+tx))
  b[$ind]=1
done



now=$(date +%s)
diff=$((now-started))
[ $DEBUG -eq 1 ] && echo "Begin folding: $(convertsecs $diff)"
echo "Begin folding: $(convertsecs $diff)" >> $LOGFILE
# Iterate through each fold command
for (( i=0; i<numFold; i++ )); do
  # echo "--------------------------------"
  # echo " FOLD: $i: ${fold[$i]}"
  # echo " FOLD: $i: ${fold[$i]} $(fold_paper "${fold[$i]}")"
  axis=""; at="";
  for s in ${fold[$i]}; do [ -z "$axis" ] && axis="$s" || at="$s"; done

  now=$(date +%s)
  diff=$((now-started))
  if [ $DEBUG -eq 1 ]; then
    echo "FOLD[$i]: ${fold[$i]} => $(convertsecs $diff)"
    echo " Limit-x: $limitX"
    echo " Limit-y: $limitY"
    echo "    axis: $axis"
    echo "      at: $at"
  fi
  echo "FOLD[$i]: ${fold[$i]} => $(convertsecs $diff)" >> $LOGFILE
  echo " Limit-x: $limitX" >> $LOGFILE
  echo " Limit-y: $limitY" >> $LOGFILE
  echo "    axis: $axis" >> $LOGFILE
  echo "      at: $at" >> $LOGFILE
  # unset n; n=()
  if [ $axis = "y" ]; then
    # If the fold axis is 'y' then count up from 0, and down from limitY
    # Make a new array 'n' mapping the last row to the first, second
    # to last row to the second row, and so on.
    # echo "y" >> $LOGFILE
    yd=$((limitY-1));
    for (( yu=0; yu<at; yu++ )); do
      if [ $((yu%100)) -eq 0 ]; then
        now=$(date +%s)
        diff=$((now-started))
        [ $DEBUG -eq 1 ] && echo "folding y axis[$yu]: $(convertsecs $diff)"
        echo "folding y axis[$yu]: $(convertsecs $diff)" >> $LOGFILE
      fi
      # echo "------ $yu $yd ------" >> $LOGFILE
      for (( ux=0; ux<limitX; ux++ )); do
        uind=$(((yu*limitX)+ux))
        bind=$(((yd*limitX)+ux))
        # echo "${yu},${ux}[u]: ${b[$uind]}"
        # echo "${yd},${ux}[d]: ${b[$bind]}"
        n[$uind]=0
        [ ${b[$uind]} -gt 0 ] && n[$uind]=$((n[uind]+1))
        [ ${b[$bind]} -gt 0 ] && n[$uind]=$((n[uind]+1))

      done
      yd=$((yd-1))
    done
    # Set the limitY to fold value 
    # for (( z=$((at*limitX)); z<$((limitX*limitY)); z++ )); do unset b[$z]; done
    for (( e=0; e<${#b[*]}; e++ )); do [ $e -lt $((limitX*limitY)) ] && b[$e]=${n[$e]} || unset b[$e] n[$e]; done

    unset limitY
    limitY=$at
  else

    # If the fold axis is 'x' then count up from 0 and down from limitX
    # Make a new array 'n' mapping the last column to the first, second
    # to last column to the second column, and so on. Also keep track of
    # new index, for the horizontal width will change, and index calculations
    # will need that new value (y * width) + x
    # echo "x" >> $LOGFILE
    for (( ty=0; ty<limitY; ty++ )); do
      if [ $((ty%100)) -eq 0 ]; then
        now=$(date +%s)
        diff=$((now-started))
        [ $DEBUG -eq 1 ] && echo "folding x axis[$ty]: $(convertsecs $diff)"
        echo "folding x axis[$ty]: $(convertsecs $diff)" >> $LOGFILE
      fi
      xl=$((limitX-1))
      for (( xr=0; xr<at; xr++ )); do
        nind=$(((ty*at)+xr))
        xrind=$(((ty*limitX)+xr))
        xlrind=$(((ty*limitX)+xl))
        # echo "------ ${xr},${ty}[${xrind}] ${b[$xrind]} => | <= ${b[$xlrind]} [${xlrind}]${xl},${ty} ------" >> $LOGFILE
        n[$nind]=0
        [ ${b[$xrind]} -gt 0 ] && n[$nind]=$((n[nind]+1))
        [ ${b[$xlrind]} -gt 0 ] && n[$nind]=$((n[nind]+1))
        xl=$((xl-1))
      done
    done
    # Set the limitY to fold value 
    unset limitX
    limitX=$at
    for (( e=0; e<${#b[*]}; e++ )); do [ $e -lt $((limitX*limitY)) ] && b[$e]=${n[$e]} || unset b[$e] n[$e]; done
  fi

  answer=0
  overlap=0
  for (( w=0; w<$((limitX*limitY)); w++ )); do
    if [ ${n[$w]} ]; then
      if [ ${n[$w]} -gt 0 ]; then
        answer=$((answer+1))
        overlap=$((overlap+n[w]))
      fi
    fi
  done
  [ $i -eq 0 ] && answer_one=$answer
  [ $DEBUG -eq 1 ] && echo "Overlap Count[$i]: $overlap"
  [ $DEBUG -eq 1 ] && echo "        Count[$i]: $answer"
  [ $DEBUG -eq 1 ] && echo "      First Count: $answer_one"
  echo "Overlap Count[$i]: $overlap" >> $LOGFILE
  echo "        Count[$i]: $answer" >> $LOGFILE
  echo "      First Count: $answer_one" >> $LOGFILE

  [ $i -eq 0 ] && [ -f "${scriptPath}/${boardFile}" ] && break
done

now=$(date +%s)
diff=$((now-started))
[ $DEBUG -eq 1 ] && echo "Folding complete: $(convertsecs $diff)"
echo "Folding complete: $(convertsecs $diff)" >> $LOGFILE

! [[ -f "${scriptPath}/${boardFile}" ]] && display_board > "${scriptPath}/${boardFile}"
cat "${scriptPath}/${boardFile}" >> $LOGFILE
[ $DEBUG -eq 1 ] && cat "${scriptPath}/${boardFile}"

now=$(date +%s)
diff=$((now-started))
[ $DEBUG -eq 1 ] && echo "Calculating answer: $(convertsecs $diff)"
echo "Calculating answer: $(convertsecs $diff)" >> $LOGFILE
answer=0
overlap=0
for q in ${b[*]}; do [ $q -gt 0 ] && answer=$((answer+1)) && overlap=$((overlap+q)); done

[ $DEBUG -eq 1 ] && echo "Overlap Count: $overlap"
[ $DEBUG -eq 1 ] && echo "   Last Count: $answer"
[ $DEBUG -eq 1 ] && echo "  First Count: $answer_one"
echo "Overlap Count: $overlap" >> $LOGFILE
echo "   Last Count: $answer" >> $LOGFILE
echo "  First Count: $answer_one" >> $LOGFILE
echo "$answer_one"

now=$(date +%s)
diff=$((now-started))
[ $DEBUG -eq 1 ] && echo "Completed in: $(convertsecs $diff)"
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE
