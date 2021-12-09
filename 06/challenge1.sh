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

[ $DEBUG -eq 1 ] && echo "$values"

fi=0
fh=0
fg=0
ff=0
fd=0
fc=0
fb=0
fa=0
ft=0
for fish in ${values//,/ }; do
  case $fish in
      6)
        fg=$((fg+1))
        ;;
      5)
        ff=$((ff+1))
        ;;
      4)
        fe=$((fe+1))
        ;;
      3)
        fd=$((fd+1))
        ;;
      2)
        fc=$((fc+1))
        ;;
      1)
        fb=$((fb+1))
        ;;
      0)
        fa=$((fa+1))
        ;;
  esac
done


for ((day=1; day<=days; day++)); do
  numFish=$((fa + fb + fc + fd + fe + ff + fg + fh + fi))
  now=$(date +%s)
  diff=$((now-started))
  [ $DEBUG -eq 1 ] && echo "Day $day: $numFish $(convertsecs $diff)"
  [ $fa -gt 0 ] && ft=$fa || ft=0
  fa=$fb
  fb=$fc
  fc=$fd
  fd=$fe
  fe=$ff
  ff=$fg
  fg=$((ft+fh))
  fh=$fi
  fi=$ft
  [ $DEBUG -eq 1 ] && echo "f[0]: $fa"
  [ $DEBUG -eq 1 ] && echo "f[1]: $fb"
  [ $DEBUG -eq 1 ] && echo "f[2]: $fc"
  [ $DEBUG -eq 1 ] && echo "f[3]: $fd"
  [ $DEBUG -eq 1 ] && echo "f[4]: $fe"
  [ $DEBUG -eq 1 ] && echo "f[5]: $ff"
  [ $DEBUG -eq 1 ] && echo "f[6]: $fg"
  [ $DEBUG -eq 1 ] && echo "f[7]: $fh"
  [ $DEBUG -eq 1 ] && echo "f[8]: $fi"
  [ $DEBUG -eq 1 ] && echo "f[t]: $ft"
done

echo $((fa + fb + fc + fd + fe + ff + fg + fh + fi))

now=$(date +%s)
diff=$((now-started))
echo "Completed: $(convertsecs $diff)" >> $LOGFILE

