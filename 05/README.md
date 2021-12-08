# --- Day 5: Hydrothermal Venture ---

## --- Part One ---

You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:

```
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
```

Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end the line segment and x2,y2 are the coordinates of the other end. These line segments include the points at both ends. In other words:

An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.
For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

So, the horizontal and vertical lines from the above list would produce the following diagram:

```
.......1..
..1....1..
..1....1..
.......1..
.112111211
..........
..........
..........
..........
222111....
```

In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9. Each position is shown as the number of lines which cover that point or . if no line covers that point. The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.

To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.

Consider only horizontal and vertical lines. At how many points do at least two lines overlap?

### Usage

```bash
./challenge1.sh ./input.txt

# Test example
DEBUG=1 ./challenge1.sh test.txt board1-test.txt 1 10
# -----0-----
# Runtime: 00:00:00
# 0,9 -> 5,9
# Horizontal line
# draw_line(0x9 -> 5x9)
# xmin:0 xmax:5 ymin:9 ymax:9
# -----1-----
# Runtime: 00:00:00
# 8,0 -> 0,8
# Diagonal line... skip!
# -----2-----
# Runtime: 00:00:00
# 9,4 -> 3,4
# Horizontal line
# draw_line(3x4 -> 9x4)
# xmin:3 xmax:9 ymin:4 ymax:4
# -----3-----
# Runtime: 00:00:00
# 2,2 -> 2,1
# Vertical line
# draw_line(2x2 -> 2x1)
# xmin:2 xmax:2 ymin:1 ymax:2
# -----4-----
# Runtime: 00:00:00
# 7,0 -> 7,4
# Vertical line
# draw_line(7x0 -> 7x4)
# xmin:7 xmax:7 ymin:0 ymax:4
# -----5-----
# Runtime: 00:00:01
# 6,4 -> 2,0
# Diagonal line... skip!
# -----6-----
# Runtime: 00:00:01
# 0,9 -> 2,9
# Horizontal line
# draw_line(0x9 -> 2x9)
# xmin:0 xmax:2 ymin:9 ymax:9
# -----7-----
# Runtime: 00:00:01
# 3,4 -> 1,4
# Horizontal line
# draw_line(1x4 -> 3x4)
# xmin:1 xmax:3 ymin:4 ymax:4
# -----8-----
# Runtime: 00:00:01
# 0,0 -> 8,8
# Diagonal line... skip!
# -----9-----
# Runtime: 00:00:01
# 5,5 -> 8,2
# Diagonal line... skip!
# 5

# .......•..
# ..•....•..
# ..•....•..
# .......•..
# .••2•••2••
# ..........
# ..........
# ..........
# ..........
# 222•••....

```

----------------------------------------------------------

## --- Part Two ---

Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture; you need to also consider diagonal lines.

Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. In other words:

An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.
Considering all lines from the above example would now produce the following diagram:

```
1.1....11.
.111...2..
..2.1.111.
...1.2.2..
.112313211
...1.2....
..1...1...
.1.....1..
1.......1.
222111....
```

You still need to determine the number of points where at least two lines overlap. In the above example, this is still anywhere in the diagram with a 2 or larger - now a total of 12 points.

Consider all of the lines. At how many points do at least two lines overlap?

### Usage

```bash
./challenge2.sh ./input.txt

# Test example
DEBUG=1 ./challenge2.sh test.txt board2-test.txt 0 10
# -----0-----
# Runtime: 00:00:00
# 0,9 -> 5,9
# Horizontal line
# draw_line(0x9 -> 5x9)
# xmin:0 xmax:5 ymin:9 ymax:9
# -----1-----
# Runtime: 00:00:00
# 8,0 -> 0,8
# Diagonal line... don't skip! :(
# draw_line(0x8 -> 8x0)
# xmin:0 xmax:8 ymin:0 ymax:8
# -----2-----
# Runtime: 00:00:00
# 9,4 -> 3,4
# Horizontal line
# draw_line(3x4 -> 9x4)
# xmin:3 xmax:9 ymin:4 ymax:4
# -----3-----
# Runtime: 00:00:00
# 2,2 -> 2,1
# Vertical line
# draw_line(2x2 -> 2x1)
# xmin:2 xmax:2 ymin:1 ymax:2
# -----4-----
# Runtime: 00:00:00
# 7,0 -> 7,4
# Vertical line
# draw_line(7x0 -> 7x4)
# xmin:7 xmax:7 ymin:0 ymax:4
# -----5-----
# Runtime: 00:00:00
# 6,4 -> 2,0
# Diagonal line... don't skip! :(
# draw_line(2x0 -> 6x4)
# xmin:2 xmax:6 ymin:0 ymax:4
# -----6-----
# Runtime: 00:00:00
# 0,9 -> 2,9
# Horizontal line
# draw_line(0x9 -> 2x9)
# xmin:0 xmax:2 ymin:9 ymax:9
# -----7-----
# Runtime: 00:00:00
# 3,4 -> 1,4
# Horizontal line
# draw_line(1x4 -> 3x4)
# xmin:1 xmax:3 ymin:4 ymax:4
# -----8-----
# Runtime: 00:00:00
# 0,0 -> 8,8
# Diagonal line... don't skip! :(
# draw_line(0x0 -> 8x8)
# xmin:0 xmax:8 ymin:0 ymax:8
# -----9-----
# Runtime: 00:00:00
# 5,5 -> 8,2
# Diagonal line... don't skip! :(
# draw_line(5x5 -> 8x2)
# xmin:5 xmax:8 ymin:2 ymax:5
# 12

# •.•....••.
# .•••...2..
# ..2.•.•••.
# ...•.2.2..
# .••23•32••
# ...•.2....
# ..•...•...
# .•.....•..
# •.......•.
# 222•••....


```