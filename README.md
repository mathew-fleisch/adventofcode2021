# Advent of Code 2021 - Mathew Fleisch's Answers

The [Advent of Code](https://adventofcode.com/) is a programming puzzle challenge that gives participants two coding challenges each day during the month of December. This repository holds my submission/answers for these challenges. I am going to try and do all of them in bash, because I hate myself. Enjoy.

## Automation

Pushing git tags to this repository will [execute each day's answer](https://github.com/mathew-fleisch/adventofcode2021/actions/workflows/release.yaml) in a [github action](.github/workflows/release.yaml) and save the answers as a txt file in the [release artifacts](https://github.com/mathew-fleisch/adventofcode2021/releases) for that day's tag (format: YYYY.MM.DD). After the release notes have been added an automatic tweet is generated to share the milestone on [my twitter feed](https://twitter.com/draxiomatic). 


## Usage

Running the make targets 'seed' and 'run' will create stubs for any missing script and execute each challenge script in sequence. Note: `export DEBUG=1` to see more information as each challenge script is executed.

```bash
make seed
make run
```

## Challenges

 - [2021-12-01 - Sonar Sweep](01)
    - [Challenge 1](01/challenge1.sh) - count increasing values
    - [Challenge 2](01/challenge2.sh) - count increasing values in window of 3
 - [2021-12-02 - Submarine Dive!](02)
    - [Challenge 1](02/challenge1.sh) - steer submarine using 3 values
    - [Challenge 2](02/challenge2.sh) - steer submarine using 4 values
 - [2021-12-03 - Binary Diagnostic](03)
    - [Challenge 1](03/challenge1.sh) - filter gamma/epsilon from binary data
    - [Challenge 2](03/challenge2.sh) - filter o2/co2 from binary data
 - [2021-12-04 - Giant Squid](04)
    - [Challenge 1](04/challenge1.sh) - find bingo winner
    - [Challenge 2](04/challenge2.sh) - find bingo loser
 - [2021-12-05 - Hydrothermal Venture](05)
    - [Challenge 1](05/challenge1.sh) - draw horizontal/vertical lines and count overlap
    - [Challenge 2](05/challenge2.sh) - draw horizontal/vertical/diagonal lines and count overlap
 - [2021-12-06 - Lanternfish](06)
    - [Challenge 1](06/challenge1.sh) - exponential fish for 80 days
    - [Challenge 2](06/challenge2.sh) - exponential fish for 256 days
 - [2021-12-07 - The Treachery of Whales](07)
    - [Challenge 1](07/challenge1.sh) - align crabs efficiently with linear fuel expenditures
    - [Challenge 2](07/challenge2.sh) - align crabs efficiently with exponential fuel expenditures
- [2021-12-08 - Seven Segment Search](08)
    - [Challenge 1](08/challenge1.sh) - count 1's, 4's, 7's and 8's from decoded input
    - [Challenge 2](08/challenge2.sh) - sum of all decoded input