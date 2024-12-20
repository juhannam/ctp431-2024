// https://chuck.cs.princeton.edu/doc/program/stdlib.html
TriOsc osc => ADSR env1 => NRev rev => Pan2 pan => dac;

0.15 => rev.mix;

-1.0 => pan.pan; // portion of signal to left channel or right channel (-1.0 ~ 1.0)

0.25::second => dur beat;
(1::ms, beat/8, 0, 1::ms) => env1.set;
0.25 => osc.gain;

[0,4,7] @=> int major[];
[0,3,7] @=> int minor[];

60 => int offset;
int position;

for (0=> int i; i < 4; i++)
{
    for(-1.0 => float j; j < 1.0; 0.1 +=> j)
    {
        // incrementing pan value from left to right
        j => pan.pan;
        Std.mtof(minor[0] + offset + position) => osc.freq;
        <<< "pan :", j >>>;
        1 => env1.keyOn;
        beat/4 => now;
    }
    for(-1.0 => float j; j < 1.0; 0.1 +=> j)
    {
        // Randomization of pan value
        Math.random2f(-1.0, 1.0) => float panValue;
        // Randomization of position, and note
        Math.random2(0, 3) * 12 => position;
        Math.random2(0, minor.cap()-1) => int note;
        // Randomize decay time
        beat / Math.random2(2, 16) => env1.decayTime;
        panValue => pan.pan;
        <<< "pan :", panValue >>>;
        Std.mtof(minor[note] + offset + position) => osc.freq;
        1 => env1.keyOn;
        beat/4 => now;
    }
}
