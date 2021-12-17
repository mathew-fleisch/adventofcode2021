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
height=${#values[@]}

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}


# Put each character from input in array 'n'
# width integer is used to simulate multidimentional arrays with one dimentional array
# create an array 'f' with 0's to track flashes
n=()
z=()
for (( y=0; y<height; y++ )); do
  row=${values[$y]}
  width=${#row}
  for (( x=0; x<width; x++ )); do
    ind=$(((y*width)+x))
    n[$ind]=${row:$x:1}
    z[$ind]=0
  done
done

reset_flashes() {
  for (( y=0; y<height; y++ )); do
    row=${values[$y]}
    for (( x=0; x<width; x++ )); do
      ind=$(((y*width)+x))
      z[$ind]=0
    done
  done
}

# All values in an array
# echo "${n[*]}"
all=${#n[@]}
steps=${2:-100}
flashes=0
[ $DEBUG -eq 1 ] && echo "height: $height"
[ $DEBUG -eq 1 ] && echo " width: $width"
[ $DEBUG -eq 1 ] && echo "length: $all"
[ $DEBUG -eq 1 ] && echo " steps: $steps"
echo "height: $height" >> $LOGFILE
echo " width: $width" >> $LOGFILE
echo "length: $all" >> $LOGFILE
echo " steps: $steps" >> $LOGFILE


dumbo_display() {
  for (( y=0; y<height; y++ )); do
    row=""
    rowf=""
    for (( x=0; x<width; x++ )); do
      ind=$(((y*width)+x))
      row="$row${n[$ind]}"
      rowf="$rowf${z[$ind]}"
    done
    echo "$row   $rowf"
  done
}

dumbo_flashes() {
  for (( y=0; y<height; y++ )); do
    for (( x=0; x<width; x++ )); do
      ind=$(((y*width)+x))

      # Flash
      if [ ${n[$ind]} -eq -1 ]; then
        flashes=$((flashes+1))
        n[$ind]=$((n[ind]-1))
        z[$ind]=1
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

        if [ $a -ge 0 ] && [ $a -lt $all ]; then
          if [ $((x-1)) -eq $((a%width)) ] && [ $((y-1)) -eq $((a/width)) ]; then
            if [ ${z[$a]} -eq 0 ]; then
              if [ ${n[$a]} -lt 0 ]; then
                n[$a]=$((n[a]-1))
              elif [ ${n[$a]} -ge 9 ]; then
                n[$a]=-1
                z[$a]=1
              else
                n[$a]=$((n[a]+1))
              fi
            fi
          fi
        fi

        if [ $b -ge 0 ] && [ $b -lt $all ]; then
          if [ $((x-0)) -eq $((b%width)) ] && [ $((y-1)) -eq $((b/width)) ]; then
            if [ ${z[$b]} -eq 0 ]; then
              if [ ${n[$b]} -lt 0 ]; then
                n[$b]=$((n[b]-1))
              elif [ ${n[$b]} -ge 9 ]; then
                n[$b]=-1
                z[$b]=1
              else
                n[$b]=$((n[b]+1))
              fi
            fi
          fi
        fi
        if [ $c -ge 0 ] && [ $c -lt $all ]; then
          if [ $((x+1)) -eq $((c%width)) ] && [ $((y-1)) -eq $((c/width)) ]; then
            if [ ${z[$c]} -eq 0 ]; then
              if [ ${n[$c]} -lt 0 ]; then
                n[$c]=$((n[c]-1))
              elif [ ${n[$c]} -ge 9 ]; then
                n[$c]=-1
                z[$c]=1
              else
                n[$c]=$((n[c]+1))
              fi
            fi
          fi
        fi
        if [ $d -ge 0 ] && [ $d -lt $all ]; then
          if [ $((x-1)) -eq $((d%width)) ] && [ $((y-0)) -eq $((d/width)) ]; then
            if [ ${z[$d]} -eq 0 ]; then
              if [ ${n[$d]} -lt 0 ]; then
                n[$d]=$((n[d]-1))
              elif [ ${n[$d]} -ge 9 ]; then
                n[$d]=-1
                z[$d]=1
              else
                n[$d]=$((n[d]+1))
              fi
            fi
          fi
        fi
        if [ $e -ge 0 ] && [ $e -lt $all ]; then
          if [ $((x+1)) -eq $((e%width)) ] && [ $((y-0)) -eq $((e/width)) ]; then
            if [ ${z[$e]} -eq 0 ]; then
              if [ ${n[$e]} -lt 0 ]; then
                n[$e]=$((n[e]-1))
              elif [ ${n[$e]} -ge 9 ]; then
                n[$e]=-1
                z[$e]=1
              else
                n[$e]=$((n[e]+1))
              fi
            fi
          fi
        fi
        if [ $f -ge 0 ] && [ $f -lt $all ]; then
          if [ $((x-1)) -eq $((f%width)) ] && [ $((y+1)) -eq $((f/width)) ]; then
            if [ ${z[$f]} -eq 0 ]; then
              if [ ${n[$f]} -lt 0 ]; then
                n[$f]=$((n[f]-1))
              elif [ ${n[$f]} -ge 9 ]; then
                n[$f]=-1
                z[$f]=1
              else
                n[$f]=$((n[f]+1))
              fi
            fi
          fi
        fi
        if [ $g -ge 0 ] && [ $g -lt $all ]; then
          if [ $((x-0)) -eq $((g%width)) ] && [ $((y+1)) -eq $((g/width)) ]; then
            if [ ${z[$g]} -eq 0 ]; then
              if [ ${n[$g]} -lt 0 ]; then
                n[$g]=$((n[g]-1))
              elif [ ${n[$g]} -ge 9 ]; then
                n[$g]=-1
                z[$g]=1
              else
                n[$g]=$((n[g]+1))
              fi
            fi
          fi
        fi
        if [ $h -ge 0 ] && [ $h -lt $all ]; then
          if [ $((x+1)) -eq $((h%width)) ] && [ $((y+1)) -eq $((h/width)) ]; then
            if [ ${z[$h]} -eq 0 ]; then
              if [ ${n[$h]} -lt 0 ]; then
                n[$h]=$((n[h]-1))
              elif [ ${n[$h]} -ge 9 ]; then
                n[$h]=-1
                z[$h]=1
              else
                n[$h]=$((n[h]+1))
              fi
            fi
          fi
        fi

      fi
    done
  done

  done_flashin=0
  for (( ind=0; ind<all; ind++ )); do
    [ ${n[$ind]} -eq -1 ] && done_flashin=1 && break
  done
  if [ $done_flashin -eq 1 ]; then
    dumbo_flashes
  else
    for (( ind=0; ind<all; ind++ )); do
      [ ${n[$ind]} -lt 0 ] && n[$ind]=0
    done
  fi
}
dumbo_step() {
  for (( y=0; y<height; y++ )); do
    for (( x=0; x<width; x++ )); do
      ind=$(((y*width)+x))
      if [ ${n[$ind]} -lt 9 ] && [ ${n[$ind]} -ge 0 ]; then
        n[$ind]=$((n[ind]+1))
      else
        if [ ${n[$ind]} -eq 9 ]; then
          n[$ind]=-1
          z[$ind]=1
        else
          n[$ind]=$((n[ind]-1))
        fi
      fi
    done
  done

  dumbo_flashes
}

[ $DEBUG -eq 1 ] && dumbo_display
  dumbo_display >> $LOGFILE
[ $DEBUG -eq 1 ] && echo "-0---------------"
echo "-0---------------" >> $LOGFILE

for (( s=1; s<=steps; s++ )); do
  reset_flashes
  dumbo_step
  [ $DEBUG -eq 1 ] && dumbo_display
   dumbo_display >> $LOGFILE

  [ $DEBUG -eq 1 ] && echo "-${s}---------------"
   echo "-${s}---------------" >> $LOGFILE
done

answer_one="$flashes"

echo "$answer_one" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE
