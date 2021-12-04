# Advent of Code 2021 - Mathew Fleisch's Answers

The [Advent of Code](https://adventofcode.com/) is a programming puzzle challenge that gives participants two coding challenges each day during the month of December. This repository holds my submission/answers for these challenges. I am going to try and do all of them in bash, because I hate myself. Enjoy.

## Usage

Running the make targets 'seed' and 'run' will create stubs for any missing script and execute each challenge script in sequence. Note: `export DEBUG=1` to see more information as each challenge script is executed.

```bash
make seed
make run
```

## Challenges

 - [2021-12-01 - Sonar Sweep](01)
    - [Challenge 1](01/challenge1.sh) - Count increasing values
    - [Challenge 2](01/challenge2.sh) - Count increasing values in window of 3
 - [2021-12-02 - Submarine Dive!](02)
    - [Challenge 1](02/challenge1.sh) - Steer submarine using 3 values
    - [Challenge 2](02/challenge2.sh) - Steer submarine using 4 values
 - [2021-12-03 - Binary Diagnostic](02)
    - [Challenge 1](02/challenge1.sh) - filter gamma/epsilon from binary data
    - [Challenge 2](02/challenge2.sh) - filter o2/co2 from binary data