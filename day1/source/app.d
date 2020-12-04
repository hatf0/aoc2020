import std.stdio;
import std.file;

void main()
{
    auto entries = slurp!(int)("input", "%d");
    writeln("Part 1");
    {
        int a = 0, b = 0;
        outer: foreach(e; entries) {
            foreach(f; entries) {
                if (f == e) continue;
                if (e + f == 2020) {
                    a = e;
                    b = f; 
                    writeln("found"); 
                    break outer;
                }
            } 
        }

        writefln("a: %d, b: %d, a*b: %d", a, b, a*b);
    }
    writeln("Part 2");
    {
        int a, b, c;
        outer2: foreach(e; entries) {
            foreach(f; entries) {
                if (f == e) continue;
                foreach(g; entries) {
                    if (g == f || g == e) continue;
                    if (e + f + g == 2020) {
                        a = e;
                        b = f;
                        c = g;
                        writeln("found");
                        break outer2;
                    }
                }
            }
        }

        writefln("a: %d, b: %d, c: %d, a*b*c=%d", a, b, c, a*b*c);
    }

}
