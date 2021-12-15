#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
STATEFILE=${STATEFILE:-state.txt}
LOGFILE=${LOGFILE:-log-day09-challenge2.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
inputFile=${1:-input.txt}
sizes=()
blob_board=()

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}
height=${#values[@]}

# Put each character from input in array 'n'
# width integer is used to simulate multidimentional arrays with one dimentional array
n=()
for (( y=0; y<height; y++ )); do
  row=${values[$y]}
  width=${#row}
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

lsort() {
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
  echo "${arr[*]}"
}



blob() {
  local seed="$1"
  local first=$seed
  blob_board=()
  IFS=$'\n' read -d '' -r -a blob_board < $STATEFILE;
  # [ $DEBUG -eq 1 ] && echo "--------- blob('$seed')(${blob_board[$first]}) ---------" >> $LOGFILE
  if [ ${blob_board[$first]} -eq 0 ]; then
    if [ $first -ge 0 ] && [ $first -lt $all ] && [ ${n[$first]} -lt 9 ]; then
      local ty=$((first/width))
      local tx=$((first%width))
      blob_board[$first]=1
      echo "${blob_board[*]}" | tr ' ' '\n' > $STATEFILE

      # a b c
      # d • e
      # f g h
      local b=$((((ty-1)*width)+(tx-0)))
      local d=$((((ty-0)*width)+(tx-1)))
      local e=$((((ty-0)*width)+(tx+1)))
      local g=$((((ty+1)*width)+(tx-0)))
      if [ $b -ge 0 ] && [ $b -lt $all ] && [ ${n[$b]} -lt 9 ]; then
        if [ $((tx-0)) -eq $((b%width)) ] && [ $((ty-1)) -eq $((b/width)) ]; then
          if [ ${blob_board[$b]} -eq 0 ]; then
            # [ $DEBUG -eq 1 ] && echo "up: b:$b" >> $LOGFILE
            echo "$(blob "$b")"
          fi
        fi
      fi
      if [ $d -ge 0 ] && [ $d -lt $all ] && [ ${n[$d]} -lt 9 ]; then
        if [ $((tx-1)) -eq $((d%width)) ] && [ $((ty-0)) -eq $((d/width)) ]; then
          if [ ${blob_board[$d]} -eq 0 ]; then
            # [ $DEBUG -eq 1 ] && echo "left: d:$d" >> $LOGFILE
            echo "$(blob "$d")"
          fi
        fi
      fi
      if [ $e -ge 0 ] && [ $e -lt $all ] && [ ${n[$e]} -lt 9 ]; then
        if [ $((tx+1)) -eq $((e%width)) ] && [ $((ty-0)) -eq $((e/width)) ]; then
          if [ ${blob_board[$e]} -eq 0 ]; then
            # [ $DEBUG -eq 1 ] && echo "right: e:$e" >> $LOGFILE
            echo "$(blob "$e")"
          fi
        fi
      fi
      if [ $g -ge 0 ] && [ $g -lt $all ] && [ ${n[$g]} -lt 9 ]; then
        if [ $((tx+0)) -eq $((g%width)) ] && [ $((ty+1)) -eq $((g/width)) ]; then
          if [ ${blob_board[$g]} -eq 0 ]; then
            # [ $DEBUG -eq 1 ] && echo "down: g:$g" >> $LOGFILE
            echo "$(blob "$g")"
          fi
        fi
      fi
      echo "$first"
    fi
  fi
}

find_lowest_points() {
  lowest=()
  lowest_points=()
  for (( y=0; y<height; y++ )); do
    row=""
    for (( x=0; x<width; x++ )); do
      islowest=1
      ind=$(((y*width)+x))
      blob_board+=(0)
      # a b c
      # d • e
      # f g h
      a=$((((y-1)*width)+(x-1)))
      b=$((((y-1)*width)+(x-0)))
      c=$((((y-1)*width)+(x+1)))
      d=$((((y-0)*width)+(x-1)))
      e=$((((y-0)*width)+(x+1)))
      f=$((((y+1)*width)+(x-1)))
      g=$((((y+1)*width)+(x-0)))
      h=$((((y+1)*width)+(x+1)))
      [ $a -ge 0 ] && [ $a -lt $all ] && [ ${n[$a]} -le ${n[$ind]} ] && islowest=0
      [ $b -ge 0 ] && [ $b -lt $all ] && [ ${n[$b]} -le ${n[$ind]} ] && islowest=0
      [ $c -ge 0 ] && [ $c -lt $all ] && [ ${n[$c]} -le ${n[$ind]} ] && islowest=0
      [ $d -ge 0 ] && [ $d -lt $all ] && [ ${n[$d]} -le ${n[$ind]} ] && islowest=0
      [ $e -ge 0 ] && [ $e -lt $all ] && [ ${n[$e]} -le ${n[$ind]} ] && islowest=0
      [ $f -ge 0 ] && [ $f -lt $all ] && [ ${n[$f]} -le ${n[$ind]} ] && islowest=0
      [ $g -ge 0 ] && [ $g -lt $all ] && [ ${n[$g]} -le ${n[$ind]} ] && islowest=0
      [ $h -ge 0 ] && [ $h -lt $all ] && [ ${n[$h]} -le ${n[$ind]} ] && islowest=0
      if [ $islowest -eq 1 ]; then
        row="${row}•"
        lowest+=(${n[$ind]})
        lowest_points+=($ind)
      else
        if [ ${n[$ind]} -eq 9 ]; then
          row="${row}@"
        else
          # row="${row}${n[$ind]}"
          row="${row}."
        fi
      fi
    done
    [ $DEBUG -eq 1 ] && echo "$row"
    echo "$row" >> $LOGFILE
  done
  total=0
  for (( t=0; t<${#lowest[@]}; t++ )); do
    low=${lowest[$t]}
    total=$((total+low+1))
  done
  echo "${blob_board[*]}" | tr ' ' '\n' > $STATEFILE
  [ $DEBUG -eq 1 ] && echo "FIND DE BLOBS"
  echo "FIND DE BLOBS" >> $LOGFILE
  for (( blobseed=0; blobseed<${#lowest_points[@]}; blobseed++ )); do
    seed=${lowest_points[$blobseed]}
    zy=$((seed/width))
    zx=$((seed%width))
    this_blob="$(blob "$seed")"
    tblob=$(lsort "$this_blob")
    this_blob_count=0
    for tb in $tblob; do this_blob_count=$((this_blob_count+1)); done
    [ $DEBUG -eq 1 ] && echo "         blob: "
    [ $DEBUG -eq 1 ] && echo "   blob count: $this_blob_count"
    [ $DEBUG -eq 1 ] && echo " lowest point: ${zx},${zy} [index:${seed}]"
    [ $DEBUG -eq 1 ] && echo "blob indexies: $tblob"
    echo "         blob: " >> $LOGFILE
    echo "   blob count: $this_blob_count" >> $LOGFILE
    echo " lowest point: ${zx},${zy} [index:${seed}]" >> $LOGFILE
    echo "blob indexies: $tblob" >> $LOGFILE

    now=$(date +%s)
    diff=$((now-started))
    [ $DEBUG -eq 1 ] && echo "<--- Run Time: $(convertsecs $diff) ------------------->"
    echo "<--- Run Time: $(convertsecs $diff) ------------------->" >> $LOGFILE
    sizes+=("$this_blob_count")
  done
}

# Find all lowest points and set global sizes array
find_lowest_points


sorted_sizes=$(lsort "${sizes[*]}")
sorted_sizes_array=()
num_sizes=0
for s in $sorted_sizes; do num_sizes=$((num_sizes+1)) && sorted_sizes_array+=($s); done
echo "${sorted_sizes[*]}" >> $LOGFILE

# Now that the blobs are sorted by size from smallest to largest, multiply the last three together
answer_two=$(( ${sorted_sizes_array[num_sizes-1]} * ${sorted_sizes_array[num_sizes-2]} * ${sorted_sizes_array[num_sizes-3]} ))
echo "$answer_two" | tee -a $LOGFILE

# Cleanup state file
rm -rf $STATEFILE || true

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE