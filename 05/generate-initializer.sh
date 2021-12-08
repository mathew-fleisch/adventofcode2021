#!/bin/bash


max=${1:-1000}
total=$((max*max))
echo "" > initialize-variables.sh


for ((x=0; x<total; x++)); do
  echo "b[$x]=0" >> initialize-variables.sh
done

echo "BRRRRT"