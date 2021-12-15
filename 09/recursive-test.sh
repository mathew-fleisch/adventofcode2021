#!/bin/bash

target="$1"


if [ -z $target ]; then
  echo "./recursive-test.sh [integer]"
  echo "Example: ./recursive-test.sh 9"
  echo "34"
  exit 1
fi

fib() {
  cur=$1
  if [ $cur -le 1 ]; then
    echo $cur
  else
    next=$(fib $((cur-1)))
    prev=$(fib $((cur-2)))
    echo $((next+prev))
  fi
}


fib $target




# I worked so hard on this crappy code... I couldn't delete it
# in_this_blob() {
#   local target=$1
#   local blob=$2
#   local found=0
#   for b in $blob; do
#     [ $b -eq $target ] && found=1 && break
#   done
#   [ $found -eq 1 ] && echo "'$target' found in '$blob'" >> $LOGFILE || echo "'$target' NOT found in '$blob'" >> $LOGFILE
#   echo $found
# }
# in_blob() {
#   local target=$1
#   local blob=$2
#   local found=0
#   for b in $blob; do
#     [ $b -eq $target ] && found=1 && break
#   done
#   echo $found
# }
# display_blob() {
#   blob="$1"
#   for (( dy=0; dy<height; dy++ )); do
#     drow=""
#     for (( dx=0; dx<width; dx++ )); do
#       cind=$(((dy*width)+dx))
#       if [ $(in_blob $cind "$blob") -eq 1 ]; then
#         drow="$drow*"
#       else
#         drow="$drow."
#       fi
#     done
#     echo "$drow"
#   done
# }


# get_blob() {
#   qseeds="$seeds"
#   seeds="$1"
#   adding=-1
#   qcount=0
#   ccount=0
#   for q in $qseeds; do qcount=$((qcount+1)); done

#   for s in $seeds; do
#     ccount=$((ccount+1))
#     if [ $adding -eq -1 ]; then
#       adding=$s
#     else
#       [ $(in_this_blob $s "$pseeds") -eq 0 ] && pseeds="$pseeds $s"
#     fi
#   done
#   [ $ccount -eq 1 ] && pseeds=$seeds
#   tseeds=$(lsort "$seeds")
#   seeds="$tseeds"
#   tseeds=$(lsort "$pseeds")
#   pseeds="$tseeds"
#   tseeds=$(lsort "$qseeds")
#   qseeds="$tseeds"

#   echo "----------------------" >> $LOGFILE
#   echo "Adding: $adding" >> $LOGFILE
#   echo "pseed[$pcount]: $pseeds" >> $LOGFILE
#   echo "qseed[$qcount]: $qseeds" >> $LOGFILE
#   echo "  cur[$ccount]: $seeds" >> $LOGFILE
#   echo "----------------------" >> $LOGFILE
#   echo "$(display_blob "$seeds")" >> $LOGFILE
#   pcount=$ccount
#   [ $pcount -gt $ccount ] && echo "***************** PROBLEM ******************" >> $LOGFILE
#   if [ $(in_this_blob $adding "$pseeds") -eq 0 ]; then
#     echo "'$adding' | '$seeds'" >> $LOGFILE
#     # tseeds=$1
#     # seeds=()
#     # for t in $tseed; do seeds+=("$t"); done

#     echo "get_blob($adding, '$pseeds')" >> $LOGFILE
#     # seeds=$(lsort "$tseeds")
#     # echo "-($seeds)" >> $LOGFILE
#     # if [[ "$seeds" != "$pseeds" ]]; then
#       newseeds=0
#       # for seed in $seeds; do
#       seed=$adding
#         echo "   -($seed:${n[$seed]})" >> $LOGFILE
#         ty=$((seed/width))
#         tx=$((seed%width))
#         if [ $seed -ge 0 ] && [ $seed -lt $all ] && [ ${n[$seed]} -lt 9 ]; then
#           echo "------>fuck(${tx}x${ty}:$seed)<-------------" >> $LOGFILE
#           sleep $sleepfor
#           # a b c
#           # d • e
#           # f g h
#           # a=$((((ty-1)*width)+(tx-1)))
#           b=$((((ty-1)*width)+(tx-0)))
#           # c=$((((ty-1)*width)+(tx+1)))
#           d=$((((ty-0)*width)+(tx-1)))
#           e=$((((ty-0)*width)+(tx+1)))
#           # f=$((((ty+1)*width)+(tx-1)))
#           g=$((((ty+1)*width)+(tx-0)))
#           # h=$((((ty+1)*width)+(tx+1)))
#           # if [ $a -ge 0 ] && [ $a -lt $all ] && [ ${n[$a]} -lt 9 ] && [ $(in_this_blob $a "$seeds") -eq 0 ]; then
#           #   if [ $((tx-1)) -eq $((a%width)) ] && [ $((ty-1)) -eq $((a/width)) ]; then
#           #     echo "=>cy[$seed]:${tx},${ty} (-1,-1) a=> $((a%width)), $((a/width))" >> $LOGFILE
#           #     echo "thisBlob.push(a:$a)" >> $LOGFILE
#           #     echo "seeds: $seeds" >> $LOGFILE
#           #     newseeds=$((newseeds+1))
#           #     echo $(get_blob "$a $seeds")
#           #     sleep $sleepfor
#           #   fi
#           # fi
#           if [ $b -ge 0 ] && [ $b -lt $all ] && [ ${n[$b]} -lt 9 ] && [ $(in_this_blob $b "$pseeds") -eq 0 ]; then
#             if [ $((tx-0)) -eq $((b%width)) ] && [ $((ty-1)) -eq $((b/width)) ]; then
#               echo "=>cy[$seed]:${tx},${ty} (0,-1) b=> $((b%width)),$((b/width))" >> $LOGFILE
#               echo "thisBlob.push(b:$b)" >> $LOGFILE
#               newseeds=$((newseeds+1))
#               # echo $(get_blob "$b $pseeds")
#               seeds="$b $pseeds"
#               echo "seeds: $pseeds" >> $LOGFILE
#               echo $(get_blob "$seeds")
#               sleep $sleepfor
#             fi
#           fi
#           # if [ $c -ge 0 ] && [ $c -lt $all ] && [ ${n[$c]} -lt 9 ] && [ $(in_this_blob $c "$seeds") -eq 0 ]; then
#           #   if [ $((tx+1)) -eq $((c%width)) ] && [ $((ty-1)) -eq $((c/width)) ]; then
#           #     echo "=>cy[$seed]:${tx},${ty} (1,-1) c=> $((c%width)),$((c/width))" >> $LOGFILE
#           #     echo "thisBlob.push(c:$c)" >> $LOGFILE
#           #     echo "seeds: $seeds" >> $LOGFILE
#           #     newseeds=$((newseeds+1))
#           #     echo $(get_blob "$c $seeds")
#           #     sleep $sleepfor
#           #   fi
#           # fi
#           if [ $d -ge 0 ] && [ $d -lt $all ] && [ ${n[$d]} -lt 9 ] && [ $(in_this_blob $d "$pseeds") -eq 0 ]; then
#             if [ $((tx-1)) -eq $((d%width)) ] && [ $((ty-0)) -eq $((d/width)) ]; then
#               echo "=>cy[$seed]:${tx},${ty} (-1,0) d=> $((d%width)),$((d/width))" >> $LOGFILE
#               echo "thisBlob.push(d:$d)" >> $LOGFILE
#               newseeds=$((newseeds+1))
#               seeds="$d $pseeds"
#               echo "seeds: $seeds" >> $LOGFILE
#               # echo $(get_blob "$d $pseeds")
#               echo $(get_blob "$seeds")
#               sleep $sleepfor
#             fi
#           fi
#           if [ $e -ge 0 ] && [ $e -lt $all ] && [ ${n[$e]} -lt 9 ] && [ $(in_this_blob $e "$pseeds") -eq 0 ]; then
#             if [ $((tx+1)) -eq $((e%width)) ] && [ $((ty-0)) -eq $((e/width)) ]; then
#               echo "=>cy[$seed]:${tx},${ty} (1,0) $((e%width)),$((e/width))" >> $LOGFILE
#               echo "thisBlob.push(e:$e)" >> $LOGFILE
#               newseeds=$((newseeds+1))
#               seeds="$e $pseeds"
#               echo "seeds: $seeds" >> $LOGFILE
#               # echo $(get_blob "$e $pseeds")
#               echo $(get_blob "$seeds")
#               sleep $sleepfor
#             fi
#           fi
#           # if [ $f -ge 0 ] && [ $f -lt $all ] && [ ${n[$f]} -lt 9 ] && [ $(in_this_blob $f "$seeds") -eq 0 ]; then
#           #   if [ $((tx-1)) -eq $((f%width)) ] && [ $((ty+1)) -eq $((f/width)) ]; then
#           #     echo "=>cy[$seed]:${tx},${ty} (-1,1) e=> $((f%width)),$((f/width))" >> $LOGFILE
#           #     echo "thisBlob.push(f:$f)" >> $LOGFILE
#           #     echo "seeds: $seeds" >> $LOGFILE
#           #     newseeds=$((newseeds+1))
#           #     echo $(get_blob "$f $seeds")
#           #     sleep $sleepfor
#           #   fi
#           # fi
#           if [ $g -ge 0 ] && [ $g -lt $all ] && [ ${n[$g]} -lt 9 ] && [ $(in_this_blob $g "$pseeds") -eq 0 ]; then
#             if [ $((tx-0)) -eq $((g%width)) ] && [ $((ty+1)) -eq $((g/width)) ]; then
#               echo "=>cy[$seed]:${tx},${ty} (0,1) $((g%width)),$((g/width))" >> $LOGFILE
#               echo "thisBlob.push(g:$g)" >> $LOGFILE
#               newseeds=$((newseeds+1))
#               seeds="$g $pseeds"
#               echo "seeds: $seeds" >> $LOGFILE
#               echo $(get_blob "$seeds")
#               sleep $sleepfor
#             fi
#           fi
#           # if [ $h -ge 0 ] && [ $h -lt $all ] && [ ${n[$h]} -lt 9 ] && [ $(in_this_blob $h "$seeds") -eq 0 ]; then
#           #   if [ $((tx+1)) -eq $((h%width)) ] && [ $((ty+1)) -eq $((h/width)) ]; then
#           #     echo "=>cy[$seed]:${tx},${ty} (1,1) $((h%width)),$((h/width))" >> $LOGFILE
#           #     echo "thisBlob.push(h:$h)" >> $LOGFILE
#           #     echo "seeds: $seeds" >> $LOGFILE
#           #     newseeds=$((newseeds+1))
#           #     echo $(get_blob "$h $seeds")
#           #     sleep $sleepfor
#           #   fi
#           # fi
#           # [ $newseeds -eq 0 ] && seeds=$pseeds
#         # else
#         #   break
#         fi
#       # done
#       # [ ${#seeds} -gt 50 ] && sleep 1
#       c=0
#       for s in $seeds; do c=$((c+1)); done
#       echo " --- Count: $c ---"
#       # sleep 1
#     # else
#     #   echo "nothing to do on this iteration." >> $LOGFILE
#     # fi
#   fi
# }
