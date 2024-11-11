// This .ck won't work because I didn't make "kick.ck" and "arpeggio.ck"
me.dir() + "kick.ck" => string kickFileName;
me.dir() + "arpeggio.ck" => string arpFileName;

0.5::second => dur beat;

Machine.add(kickFileName) => int kickId;

beat * 4 => now;

Machine.replace(kickId, arpFileName);

beat * 4 => now;

Machine.replace(kickId, kickFileName);
Machine.add(arpFileName) => int arpId;

beat * 4 => now;

Machine.remove(kickId);
Machine.remove(arpId);