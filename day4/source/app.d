import std.stdio;
import passport;
import std.file;
import std.algorithm.searching;
import std.string;
import std.exception;

void main()
{
    auto e = readText("input").split("\n\n");
    int valid = 0;
    foreach(entry; e) {
        Passport p;
        try {
            p = Passport.deserialize(entry);
            enforce(1920 <= p.birthYear && p.birthYear <= 2002);
            enforce(2010 <= p.issueYear && p.issueYear <= 2020);
            enforce(2020 <= p.exprYear && p.exprYear <= 2030);
            if (p.heightInCm) {
                enforce(150 <= p.height && p.height <= 193);
            } else {
                enforce(59 <= p.height && p.height <= 76);
            }

            enforce(canFind(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], p.eyeColor));

            import std.ascii;
            enforce(p.hairColor.strip(std.ascii.fullHexDigits).length == 0);
            enforce(p.hairColor.length == 6);
            writeln(p);

            valid = valid + 1;
        } catch(Exception e) {
            writeln(e);
        }
    }

    writeln(valid);
}
