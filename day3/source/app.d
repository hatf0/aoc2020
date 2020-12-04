import std.stdio;
import std.algorithm.searching;
import std.file;

struct Coord {
    ulong x;
    ulong y;
}

void main()
{
    Coord[] trees;
    auto input = slurp!(string)("input", "%s");
    ulong height = 0;
    foreach(y, line; input) {
        if (y % 2) continue;
        foreach(x, c; line) {
            if (c == '#') {
                trees ~= Coord(x, y);
            }
        }
        height = y;
    }

    int findTreesHit(Coord slope) {
        Coord currentCoord = Coord(0, 0);
        int treesHit = 0;

        while (true) {
            if (trees.canFind(currentCoord)) {
//                writeln("hit a tree at coord ", currentCoord);
                treesHit++;
            }

            if (currentCoord.y > height) {
                break;
            }

            currentCoord.x += slope.x;
            currentCoord.y += slope.y;
            if (currentCoord.x > 30) {
                currentCoord.x -= 31; 
            }

//            writeln(currentCoord);
        }
        return treesHit;
    }
    
    Coord[] slopes = [Coord(1, 1), Coord(3, 1), Coord(5, 1), Coord(7, 1), Coord(1, 2)];

    writeln(findTreesHit(slopes[1]));

    ulong total = 0;
    foreach(i, slope; slopes) {
        if (i == 0) {
            total = findTreesHit(slope);
        } else {
            total *= findTreesHit(slope);
        }
    }

    writeln(total);
}




