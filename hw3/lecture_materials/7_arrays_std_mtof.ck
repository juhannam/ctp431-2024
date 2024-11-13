// https://chuck.cs.princeton.edu/doc/program/stdlib.html

// Example 1 //
string words[2];
"Hello" => words[0];
"World" => words[1];
<<< words[0], words[1] >>>;


// Example 2 //
SinOsc osc => dac;
0.25 => osc.gain;
// @=> : "at-Chuck" operator
// we do not need to give size of the array
[110, 220, 440, 660, 770, 880, 1320] @=> int frequencies[];

[60, 62, 64, 65, 67, 69, 71, 72] @=> int pitches[];

while(true)
{
    // frequencies.cap() returns the capacity of the array
    for(0 => int i; i < frequencies.cap(); i++)
    {
        // Std stands for the chuck standard library, contains several convenient methods
        // Std.mtof returns frequency when given MIDI pitches (mtof: MIDI to frequency)
        // Std.mtof(pitches[i]) => osc.freq;

        frequencies[i] => osc.freq;

        200::ms => now;
    }
}