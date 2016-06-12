---
layout: post
title:  "Branching Walker"
thumbnail: branching-walker.png
tags: python ascii art l-system random walker tree automata
---

Making some generative ASCII-art.

<!--more-->

{% highlight txt %}
 | |     | | | |  o-O-o  o-O--o|O---o--O-||| |o--O-o |  |  |  | |       || |   
-O-|       |   o---O| |  | |  |||   |    |||-O|    | |  |  |  | |       || o---
   |       |   |   || |  | |-O-o|   |    |||  |--O------o  o--O-|       || |   
   |       |   |   |o-O----| | |o------O--o|  |  |     o----O---o       |O |   
   |---O---o   |   || |    | |-O--o    |  |o-O---o     |    |   |       || |   
   |   |   |---OO--o| |    | o----O----o-O-| |   |     |    o----O------o| |   
---o   |   |    |  |O-|    | |    |    | | | |   |     |    ||   |    | |o-O---
 o-O---o   |    o-O---o--O-| |    |    | o-O-|   |     |    ||O--o    o-O| |   
 | |   | | | |-O--|   |  | | |    o-O--o |   |O--o-----O-----o|---------O--o   
-| |---O-o-O-o |  |   |  | o---O--o |  | |O--o|  | | o--O-----o |       |o-O---
{% endhighlight %}


## The Source

[Jump head](#outputs) if it seems to you like some kind of foreign poetry.

Or you can try to read it anyway.

{% highlight python %}
#!/usr/bin/env python3
from random import choice
import sys

w = 80
h = 40

if len(sys.argv) > 1:
    depth = int(sys.argv[1])
else:
    depth = 100

modular = True

x0 = w // 2
y0 = h // 2

start = "o"

# { node: { direction: [successor nodes]}}
rules = {
        "|": {
            "n": ["|", "|", "O"],
            "s": ["|", "|", "O"],
            },
        "O": {
            "w": ["-"],
            "e": ["-"],
            },
        "-": {
            "w": ["-", "-", "o"],
            "e": ["-", "-", "o"],
            },
        "o": {
            "n": ["|"],
            "s": ["|"],
            },
        }


def display(world):
    "Show the world"
    print("\n".join("".join(row) for row in world))


def put(world, node, x, y):
    "Position a node"
    if modular:
        x %= w
        y %= h

    world = world.copy()
    if x in range(w) and y in range(h):
        world[y][x] = node

    return world


def move(x, y, d):
    "Change x and y according to direction d"
    if d == "n":
        y -= 1
    elif d == "s":
        y += 1
    elif d == "e":
        x += 1
    elif d == "w":
        x -= 1
    elif d == "ne":
        x += 1
        y -= 1
    elif d == "nw":
        x -= 1
        y -= 1
    elif d == "se":
        x += 1
        y += 1
    elif d == "sw":
        x -= 1
        y += 1

    return x, y


def possible_directions(node):
    "Given a node return possible directions"
    return list(rules[node].keys())


def possible_successors(node, d):
    "Given a node and a direction return possible successors"
    return rules[node][d]


def is_empty(world, x, y):
    "Is a cell empty?"
    if modular:
        x %= w
        y %= h

    if x in range(w) and y in range(h):
        return world[y][x] == " "
    else:
        return False


def is_valid_direction(world, d, x, y):
    "Is the given direction valid?"
    return is_empty(world, *move(x, y, d))


def grow(world, node, x, y, depth):
    "Grow a node"
    if depth:
        directions = possible_directions(node)

        # Filter valid directions
        directions = [d for d in directions
                      if is_valid_direction(world, d, x, y)]

        if directions:
            for d in directions:
                if is_valid_direction(world, d, x, y):
                    new_x, new_y = move(x, y, d)
                    new_node = choice(possible_successors(node, d))

                    world = put(world, new_node, new_x, new_y)
                    world = grow(world, new_node, new_x, new_y, depth-1)

    return world


def main():
    "Main function"
    world = [[" "] * w for i in range(h)]

    world = put(world, start, x0, y0)
    world = grow(world, start, x0, y0, depth)

    display(world)


if __name__ == "__main__":
    main()


{% endhighlight %}


## Outputs

With `depth = 200`:
{% highlight txt %}
--o-O| || |        | |O-o|  | |  | | o-O----|| |    | | |-O-o|-O-o    o-O-o--O-
  |--O--o |        | |  ||  | |  | | | |    || |    | | o-O-||   |    ||| |  | 
  |     | |        | o--O|  o-O--o-O-| |    |o-O------o | | |o---O-----o| |  | 
  |     | |        | | | o------O|   | |    o---O--o  | | o-O|   |     |o-O--| 
-----O--| o----O---|-O-o |      |O-----o    |   |  |  |-------O--oO----|| |  o-
||   || | ||   |   | | | |      |      |   -O-  |  |  |-O-o   |  || o--O--o  | 
||   |o-O--o-O-o---O-o | |      |      |   |    | -O- | | |-O-|--Oo--O--o |  | 
|o-O-|| |  | | | |   | | |      o------O---o    |   o-O-o | | |   |  |  | |  | 
o| | || o--O-o-O-o   | | |      | |  | |   |    |   |   | | | |   |O-o--O-O----
|| | |O-|   || | |   |-O--      | |  | o---O----o   ||  | | | |   || |    |    
|| | |  |   || o-O---| |        | |  | o  | |   |   ||  |-O-o o---O| |    |    
O--o |  |   ||----O--| o--------O-o  | |  | |   |   ||  |   | | o-O| |    o----
   | |--O---o|    |--O--o  |  O   |  | |  | |   |   ||O-|   | | | || |    | |  
   | o----O--|    |     |  o-O|   |  | |  | o---O----o|||-----O---oo------O-o |
-O-| | |  |  |    o---O-|  | ||   |  o-O--o |    |   |||O----o    ||     ---O-o
 | |-O-o  |  |    |O--| |-O--oo---O-------|-O--- |   ||o--O--|----O|        | |
-o | | |  |  |    ||  | | |  ||    o-O----| |    |   |||  |  | |   |        o-O
 |-O-o |  |  |    ||  o-O-o  -O-   | |  |-O-o--O-o--O|||  |--O-o   |        | |
--O-o| |O-|--O-----o-O| |||   |    | |  |   |  | |  | ||  o--O-|-O----O---  | o
  | || || |        | || ||O---o--O-| |  o---O--o-O--o o-O-| || | |    |   o-O-|
{% endhighlight %}



And 20:
{% highlight txt %}

                              |    -O-|                                        
                              |     | |                                        
                              o--O--o |                                        
                              |  |  | |                                        
                              |  |  | |    |                                   
                              |  o--O-o-O--o                                   
                                 |  | | |  |                                   
                          o------O--|-O-o                                      
                                    o--O|                                      
                                    |  ||                                      
                           -O-      |  o|      |                               
                            |       |  ||      |                               
                            |       |  ||      o-O----                         
                            |       |  ||      | |                             
                            o----------O---------o                             
                            |                  | |                             
                            |                  o-O---o                         
                            |       --O--      |                               
                            |         |        |                               
                            O |       |                                        
{% endhighlight %}

