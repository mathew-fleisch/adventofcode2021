#!/bin/bash
#shellcheck disable=SC2086

DEBUG=${DEBUG:-0}
inputFile=${1:-input.txt}

IFS=$'\n' read -d '' -r -a values < $inputFile;
inputLength=${#values[@]}
winner=$inputLength
loser=0
winning_value=0
losing_value=0
row=1

random=${values[0]//,/ }

[ $DEBUG -eq 1 ] && echo "---Input---"
[ $DEBUG -eq 1 ] && echo "$random"

track=0

evaluate_board() {
  board="$1"
  leftover_sum=0
  ttra=0
  row_1=()
  row_2=()
  row_3=()
  row_4=()
  row_5=()
  col_1=()
  col_2=()
  col_3=()
  col_4=()
  col_5=()
  trow_1=()
  trow_2=()
  trow_3=()
  trow_4=()
  trow_5=()
  tcol_1=()
  tcol_2=()
  tcol_3=()
  tcol_4=()
  tcol_5=()
  
  this_row=0
  for num in $board; do
    this_col=$(((ttra%5)+1))
    [ $((ttra%5)) -eq 0 ] && this_row=$((this_row+1))
    # echo "$ttra: $num $this_col"
    leftover_sum=$((leftover_sum+num))
    case $this_col in
      1)
        col_1+=("$num")
        ;;
      2)
        col_2+=("$num")
        ;;
      3)
        col_3+=("$num")
        ;;
      4)
        col_4+=("$num")
        ;;
      5)
        col_5+=("$num")
        ;;
    esac
    case $this_row in
      1)
        row_1+=("$num")
        ;;
      2)
        row_2+=("$num")
        ;;
      3)
        row_3+=("$num")
        ;;
      4)
        row_4+=("$num")
        ;;
      5)
        row_5+=("$num")
        ;;
    esac

    ttra=$((ttra+1))
  done

  # "multidimensional array"
  # echo "${row_1[*]}"
  # echo "${row_2[*]}"
  # echo "${row_3[*]}"
  # echo "${row_4[*]}"
  # echo "${row_5[*]}"
  # echo
  # echo "${col_1[*]}"
  # echo "${col_2[*]}"
  # echo "${col_3[*]}"
  # echo "${col_4[*]}"
  # echo "${col_5[*]}"
  # echo

  # Iterate through each randomly selected number in order
  # Remove any element found from each row/col
  # First row/col to be empty will have a bingo
  ltrack=0
  for rand in $random; do
    # echo "$ltrack: $rand"
    for ind in 0 1 2 3 4; do
      [ ${row_1[$ind]} -eq $rand ] && trow_1+=($rand) && leftover_sum=$((leftover_sum-rand))
      [ ${row_2[$ind]} -eq $rand ] && trow_2+=($rand) && leftover_sum=$((leftover_sum-rand))
      [ ${row_3[$ind]} -eq $rand ] && trow_3+=($rand) && leftover_sum=$((leftover_sum-rand))
      [ ${row_4[$ind]} -eq $rand ] && trow_4+=($rand) && leftover_sum=$((leftover_sum-rand))
      [ ${row_5[$ind]} -eq $rand ] && trow_5+=($rand) && leftover_sum=$((leftover_sum-rand))
      [ ${col_1[$ind]} -eq $rand ] && tcol_1+=($rand)
      [ ${col_2[$ind]} -eq $rand ] && tcol_2+=($rand)
      [ ${col_3[$ind]} -eq $rand ] && tcol_3+=($rand)
      [ ${col_4[$ind]} -eq $rand ] && tcol_4+=($rand)
      [ ${col_5[$ind]} -eq $rand ] && tcol_5+=($rand)
    done
    # echo "r1: ${trow_1[*]}"
    # echo "r2: ${trow_2[*]}"
    # echo "r3: ${trow_3[*]}"
    # echo "r4: ${trow_4[*]}"
    # echo "r5: ${trow_5[*]}"
    # echo
    # echo "c1: ${tcol_1[*]}"
    # echo "c2: ${tcol_2[*]}"
    # echo "c3: ${tcol_3[*]}"
    # echo "c4: ${tcol_4[*]}"
    # echo "c5: ${tcol_5[*]}"
    # echo
    [ ${#trow_1[@]} -eq ${#row_1[@]} ] && break
    [ ${#trow_2[@]} -eq ${#row_2[@]} ] && break
    [ ${#trow_3[@]} -eq ${#row_3[@]} ] && break
    [ ${#trow_4[@]} -eq ${#row_4[@]} ] && break
    [ ${#trow_5[@]} -eq ${#row_5[@]} ] && break
    [ ${#tcol_1[@]} -eq ${#col_1[@]} ] && break
    [ ${#tcol_2[@]} -eq ${#col_2[@]} ] && break
    [ ${#tcol_3[@]} -eq ${#col_3[@]} ] && break
    [ ${#tcol_4[@]} -eq ${#col_4[@]} ] && break
    [ ${#tcol_5[@]} -eq ${#col_5[@]} ] && break
    ltrack=$((ltrack+1))
  done

  # BINGO!!!
  if [ $ltrack -lt $winner ]; then
    winner=$ltrack
    winning_value=$((rand * leftover_sum))
  fi
  if [ $ltrack -gt $loser ]; then
    loser=$ltrack
    losing_value=$((rand * leftover_sum))
  fi
  [ $DEBUG -eq 1 ] && echo $((rand * leftover_sum))
}

# This iteration will cycle through each bingo board
while [ $row -lt $inputLength ]; do
  track=$((track+1))
  [ $DEBUG -eq 1 ] && echo "-----$track-----"

  # Evaluate bingo board
  thisBoard="${values[row+0]} ${values[row+1]} ${values[row+2]} ${values[row+3]} ${values[row+4]} "
  evaluate_board "$thisBoard"

  row=$((row + 5))
done


[ $DEBUG -eq 1 ] && echo "BINGO Winner[$winner]: $winning_value"
[ $DEBUG -eq 1 ] && echo "BINGO Loser[$loser]: $losing_value"
echo $losing_value
