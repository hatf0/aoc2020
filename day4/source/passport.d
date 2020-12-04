module passport;
import std.stdio;

struct PassportEntry {
    string shortForm;
}

struct Optional {

}

struct Passport {
    @PassportEntry("pid")  ulong id;
    @Optional @PassportEntry("cid") int countryId;
    @PassportEntry("byr") int birthYear;
    @PassportEntry("iyr") int issueYear;
    @PassportEntry("eyr") int exprYear;
    @PassportEntry("hgt") int height;
                          bool heightInCm;
    @PassportEntry("hcl") string hairColor; 
    @PassportEntry("ecl") string eyeColor;

    static Passport deserialize(string _b) {
        import std.traits, std.string, std.algorithm.searching;
        Passport p;
        string b = _b.replace("\n", " ");

        static foreach(member; getSymbolsByUDA!(Passport, PassportEntry)) {{
            enum opt = hasUDA!(member, Optional);
            enum entryName = getUDAs!(member, PassportEntry)[0].shortForm;
            if (!b.canFind(entryName) && !opt) {
                throw new Exception("Missing field " ~ entryName);
            }
        }}
        
        outer: foreach(pair; b.split(" ")) {
            if (!pair.canFind(":")) {
                writeln("skipped ", pair);
                continue;
            }
            auto arr = pair.split(":");
            auto key = arr[0];
            auto val = arr[1];

            static foreach(member; getSymbolsByUDA!(Passport, PassportEntry)) {{
                enum opt = hasUDA!(member, Optional);
                enum entryName = getUDAs!(member, PassportEntry)[0].shortForm;

                // this is our val, extract the output
               if (key == entryName) { 
                    import std.conv, std.ascii, std.exception;
                    bool hexLiteral = false;
                    if (val.canFind("#")) {
                        val = val.strip("#");
                        if (val.strip(std.ascii.fullHexDigits).length != 0) {
                            throw new Exception("non well formed hex literal");
                        }
                        hexLiteral = true;
                    }

                    static if (isIntegral!(typeof(member))) {
                        static if (entryName == "hgt") {
                            auto v = val.strip(std.ascii.digits);
                            if (v.length == 0) {
                                throw new Exception("height needs a unit");
                            }
                            if (v != "cm" && v != "in") {
                                throw new Exception("invalid units");
                            }

                            if (v == "cm") {
                                p.heightInCm = true;
                            }
                            val = val[0 .. $ - 2];

                        }

                        static if (entryName == "pid") {
                            if (val.length != 9) {
                                throw new Exception("expected 9 digits");
                            }
                        }

                        static if (entryName == "byr" || entryName == "iyr" || entryName == "eyr") {
                            if (val.length != 4) {
                                throw new Exception("expected 4 digits");
                            }
                        }


                        if (hexLiteral) {
                            mixin("p." ~ member.stringof ~ " = val.to!(typeof(member))(16);");
                            continue outer;
                        }
                    }

                    static if (entryName == "hcl") {
                        if (!hexLiteral) {
                            throw new Exception("hcl needs to be a recognized hex literal");
                        }
                    }

                    mixin("p." ~ member.stringof ~ " = val.to!(typeof(member));");
                }
            }}
        }
        return p;
    }
}

unittest {
    string e1 = `ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm`;
    Passport p = Passport.deserialize(e1);
    assert(p.eyeColor == "gry");
    assert(p.id == 860033327);
    assert(p.exprYear == 2020);
}
