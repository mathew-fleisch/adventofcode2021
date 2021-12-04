#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
inputFile=${1:-input.txt}
echo "" > log.txt
filter_calculate() {
  tmp=$1
  values=()
  for t in $tmp; do values+=("$t"); done
  place=$2
  oneorzero=$3
  pivot=0
  one=()
  zero=()
  index=0
  buckets=()
  while [ $index -lt ${#values[@]} ]; do

    if [ $index -eq 0 ]; then
      trackBuck=0
      while [ $trackBuck -lt ${#values[$index]} ]; do
        buckets[$trackBuck]=0
        trackBuck=$((trackBuck + 1))
      done
    fi
    this=${values[$index]}
    trackBuck=0
    while [ $trackBuck -lt ${#values[$index]} ]; do
      that=${this:$trackBuck:1}
      buckets[$trackBuck]=$((buckets[trackBuck] + that))
      trackBuck=$((trackBuck + 1))
    done

    pivot=${this:$place:1}
    if [ $pivot -eq 0 ]; then
      zero+=("$this")
    else
      one+=("$this")
    fi
    
    index=$((index + 1))
  done
  valLength=${#values[*]}

  echo "----------------" >> log.txt
  echo "place: $place" >> log.txt
  echo "          :                     1 1" >> log.txt
  echo "          : 0 1 2 3 4 5 6 7 8 9 0 1" >> log.txt
  echo "buckets[*]: ${buckets[*]}" >> log.txt
  echo "buckets[$place]: ${buckets[$place]}" >> log.txt
  echo "      ones: ${#one[*]}" >> log.txt
  echo "     zeros: ${#zero[*]}" >> log.txt
  echo " valLength: ${valLength}" >> log.txt
  echo "values: ${values[*]}" >> log.txt
  # If there is a tie, break it based on oneorzero
  if [ ${#one[*]} -eq ${#zero[*]} ] && [ $oneorzero -eq 1 ]; then
    echo "${one[*]}"
  elif [ ${#one[*]} -eq ${#zero[*]} ] && [ $oneorzero -eq 0 ]; then
    echo "${zero[*]}"
  else
    if [ $oneorzero -eq 1 ]; then
      if [ ${buckets[$place]} -gt $((valLength / 2)) ]; then
        echo "${one[*]}"
      else
        echo "${zero[*]}"
      fi
    else
      echo "zero: ${zero[*]}" >> log.txt
      echo " one: ${one[*]}" >> log.txt
      if [ ${buckets[$place]} -gt $((valLength / 2)) ]; then
        echo "${zero[*]}"
      else
        echo "${one[*]}"
      fi
    fi
  fi
}

# -----------------------------

IFS=$'\n' read -d '' -r -a values < $inputFile;
# [ $DEBUG -eq 1 ] && echo "Lines: ${#values[@]}"

trackBucket=0
while [ $trackBucket -lt ${#values[0]} ]; do
  buckets[$trackBucket]=0
  [ ${#values[@]} -eq 1 ] && break
  [ $DEBUG -eq 1 ] && echo " values: ${values[*]}"
  tmp=$(filter_calculate "${values[*]}" $trackBucket 1)
  values=()
  for t in $tmp; do values+=("$t"); done
  trackBucket=$((trackBucket + 1))
done
botwo=${values[0]}
otwo=$((2#$botwo))


# -----------------------------
echo "===========================================" >> log.txt
[ $DEBUG -eq 1 ] && echo "==========================================="

IFS=$'\n' read -d '' -r -a values < $inputFile;

trackBucket=0
while [ $trackBucket -lt ${#values[0]} ]; do
  buckets[$trackBucket]=0
  [ ${#values[@]} -eq 1 ] && break
  [ $DEBUG -eq 1 ] && echo " values: ${values[*]}"
  tmp=$(filter_calculate "${values[*]}" $trackBucket 0)
  values=()
  for t in $tmp; do values+=("$t"); done
  trackBucket=$((trackBucket + 1))
done


bcotwo=${values[0]}
cotwo=$((2#$bcotwo))

[ $DEBUG -eq 1 ] && echo "  o2bin: $botwo"
[ $DEBUG -eq 1 ] && echo " co2bin: $bcotwo"
[ $DEBUG -eq 1 ] && echo "     o2: $otwo"
[ $DEBUG -eq 1 ] && echo "    co2: $cotwo"

echo "  o2bin: $botwo" >> log.txt
echo "     o2: $otwo" >> log.txt
echo " co2bin: $bcotwo" >> log.txt
echo "    co2: $cotwo" >> log.txt

echo "$otwo * $cotwo = $((otwo * cotwo))" >> log.txt
echo "$((otwo * cotwo))"
