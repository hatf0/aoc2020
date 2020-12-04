import std.stdio;
import std.file;
import std.algorithm.searching;
import std.algorithm.iteration;
import std.typecons : Flag, Yes, No;

void main()
{
    auto input = slurp!(int, int, char, string)("input", "%d-%d %c: %s");
    
    writeln("Part 1");
    {
        int valid = 0;
        foreach(line; input) {
            int min = line[0];
            int max = line[1]; 
            char search = line[2];
            string pw = line[3];
            auto count = pw.count!((a) => a == search);
            if (min <= count && count <= max) valid++; 
        }
        writeln(valid);
    }

    writeln("Part 2");
    {
        int valid = 0;
        foreach(line; input) {
            import std.conv, std.array;
            int min = line[0];
            int max = line[1];
            dchar search = to!dchar(line[2]);
            string pw = line[3];
            bool satisfiedMin = false;
            bool satisfiedMax = false;

            import std.array;
            pw.array.each!((i, a) {
                    if ((i + 1) == min) {
                        if (a == search) satisfiedMin = true;
                    } else if ((i + 1) == max) {
                        if (a == search) satisfiedMax = true;
                    }

                    return Yes.each;

            });

            if (satisfiedMin && !satisfiedMax) {
                valid++;
            } else if (!satisfiedMin && satisfiedMax) {
                valid++;
            }
        }
        writeln(valid);
    }

}
