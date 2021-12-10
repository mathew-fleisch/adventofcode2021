#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log1.txt}
scriptPath=$(realpath $0)
scriptName=$(basename $scriptPath)
scriptPath=${scriptPath/\/$scriptName/}
inputFile=${1:-input.txt}
# days=${2:-80}

started=$(date +%s)
echo "$started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}

convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}



convert_number() {
  local number=$1
  local letter=""
  case $number in
  0)
    letter=a
    ;;
  1)
    letter=b
    ;;
  2)
    letter=c
    ;;
  3)
    letter=d
    ;;
  4)
    letter=e
    ;;
  5)
    letter=f
    ;;
  6)
    letter=g
    ;;
  esac
  echo "$letter"
}
convert_letter() {
  local number=0
  local letter=$1
  case $letter in
  a)
    number=0
    ;;
  b)
    number=1
    ;;
  c)
    number=2
    ;;
  d)
    number=3
    ;;
  e)
    number=4
    ;;
  f)
    number=5
    ;;
  g)
    number=6
    ;;
  esac
  echo "$number"
}
digits[0]="1 1 1 0 1 1 1"
digits[1]="0 0 1 0 0 1 0"
digits[2]="1 0 1 1 1 0 1"
digits[3]="1 0 1 1 0 1 1"
digits[4]="0 1 1 1 0 1 0"
digits[5]="1 1 0 1 0 1 1"
digits[6]="1 1 0 1 1 1 1"
digits[7]="1 0 1 0 0 1 0"
digits[8]="1 1 1 1 1 1 1"
digits[9]="1 1 1 1 0 1 1"
# 0: a b c . e f g
# 1: . . c . . f .
# 2: a . c d e . g 
# 3: a . c d . f g
# 4: . b c d . f .
# 5: a b . d . f g
# 6: a b . d e f g
# 7: a . c . . f .
# 8: a b c d e f g
# 9: a b c d . f g 
enigma() {
  rmap="$1"
  map=()
  for r in $rmap; do map+=("$r"); done
  coded="$2"
  # echo "map: $map"
  # echo "coded: $coded"
  decoded=""
  for word in $coded; do
    dword=""
    tnum=()
    for (( t=0; t<7; t++ )); do tnum[$t]=0; done
      # echo "coded word: $word"
      for (( i=0; i<${#word}; i++ )); do
        letter=${word:$i:1}
        lind=$(convert_letter $letter)
        dletter=${map[$lind]}
        dind=$(convert_letter $dletter)
        tnum[$dind]=1
        dword="${dword}${dletter}"
      done
      # echo "decoded word: $dword"
      # echo "this number: ${tnum[*]}"
      for (( t=0; t<=9; t++ )); do
        digit=${digits[$t]}
        if [ "$digit" = "${tnum[*]}" ]; then
          decoded="${decoded}${t}"
          break
        fi
      done
  done
  echo "$decoded"
}


# echo "$values"
decode_row() {
  encoded="$1"
  target=""
  trig=0
  letterCount=()
  map=()
  one=()
  four=()
  seven=()
  for (( j=0; j<7; j++ )); do letterCount[$j]=0 && map[$j]=.; done
  for word in $encoded; do
    # echo "$word"
    [ $word = "|" ] && trig=1 && continue
    if [ $trig -eq 1 ]; then
      target="$target $word"
    else
      # echo "$word: ${#word}"
      for (( i=0; i<${#word}; i++ )); do
        letter=${word:$i:1}
        # echo "l: $letter"
        l=0
        case ${#word} in
          2)
            # Must be 1
            one+=("$letter")
            ;;
          3)
            # Must be 7
            seven+=("$letter")
            ;;
          4)
            # Must be 4
            four+=("$letter")
            ;;
        esac

        tletter=${word:$i:1}
        tnumber=$(convert_letter $tletter)
        # echo "$tletter = $tnumber"
        l=${letterCount[$tnumber]}
        letterCount[$tnumber]=$((l+1))
      done
    fi
  done

  # echo "one ~ ${one[*]}"
  # echo "four ~ ${four[*]}"
  # echo "seven ~ ${seven[*]}"

  # get 'a' from 1 and 7
  for (( i=0; i<${#seven[@]}; i++ )); do
    if ! [[ "${one[*]}" =~ ${seven[$i]} ]]; then
      # echo "${seven[$i]} NOT in ${one[*]}"
      l=$(convert_letter ${seven[$i]})
      map[$l]=a
      break
    fi
  done

  bee=.
  for (( i=0; i<${#letterCount[@]}; i++ )); do
    c=${letterCount[$i]}
    case $c in
    4)
      map[$i]=e
      ;;
    6)
      map[$i]=b
      bee=$(convert_number $i)
      ;;
    8)
      [ ${map[$i]} = "." ] && map[$i]=c
      ;;
    9)
      map[$i]=f
      ;;
    esac
  done
  # echo "BEE: $bee"
  for (( x=0; x<${#letterCount[@]}; x++ )); do
    c=${letterCount[$x]}
    if [ $c -eq 7 ]; then
      # echo "$x: $c"
      map[$x]=g
      for (( f=0; f<${#four[@]}; f++ )); do
        fl=${four[$f]}
        # echo "fl[$f]: $fl"
        if ! [[ "${one[*]}" =~ $fl ]] && [ "$fl" != $bee ]; then
          lastLetter=$(convert_letter ${four[$f]})
          map[$lastLetter]=d
          break
        fi
      done
    fi
  done
  
  # echo "0 1 2 3 4 5 6"
  # echo "a b c d e f g"
  # echo "-------------"
  # echo "${letterCount[*]}"
  # echo "${map[*]}"
  # echo "$target"
  decoded=$(enigma "${map[*]}" "$target")
  echo "$decoded"
}




answers=()
counts=()
answer_two=0
for (( u=0; u<=9; u++ )); do counts[$u]=0; done
for ((row=0; row<inputLength; row++)); do
  # echo "${values[$row]}"
  answer=$(decode_row "${values[$row]}")
  nonzero=0
  ta=""
  for (( q=0; q<${#answer}; q++ )); do
    v=${answer:$q:1}
    [ $v -ne 0 ] && nonzero=1
    [ $nonzero -gt 0 ] && ta="${ta}${v}"
  done
  # echo "ta: $ta"
  answer_two=$((answer_two+ta))
  # echo "$row: $answer"
  for (( z=0; z<${#answer}; z++ )); do
    d=${answer:$z:1}
    w=counts[$d]
    counts[$d]=$((w+1))
  done
  answers[$row]=$answer
done

# echo "${answers[*]}"
answer_one=0
for (( digit=0; digit<=9; digit++ )); do
  tcount=${counts[$digit]}
  # echo "$digit: $tcount"
  case $digit in
    1)
      answer_one=$((answer_one+tcount))
      ;;
    4)
      answer_one=$((answer_one+tcount))
      ;;
    7)
      answer_one=$((answer_one+tcount))
      ;;
    8)
      answer_one=$((answer_one+tcount))
      ;;
  esac
done

echo "$answer_two"