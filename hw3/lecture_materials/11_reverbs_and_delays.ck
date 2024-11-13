// https://chuck.cs.princeton.edu/doc/program/ugen_full.html
// delay simply makes the input signal wait until the duration that we specify
<<< "Reverbs & Delays" >>>;
SinOsc osc => ADSR env1 => NRev rev1 => dac; // original signal with built-in reverb (NRev)
env1 => Delay delay1 => dac; // delayed signal 
delay1 => delay1; // feedback, delays again and again

// 0.2 => rev1.mix; // ratio to mix original signal and reverb

0.5::second => dur beat;
(1::ms, beat/8, 0, 1::ms) => env1.set;
0.25 => osc.gain;

beat => delay1.max; // Important parameter when setting delay, lets chuck know how much memory it should hold onto.
beat /4 => delay1.delay; // delay duration
0.85 => delay1.gain;

[0,4,7] @=> int major[];
[0,3,7] @=> int minor[];

60 => int offset;
int position;

for (0=> int i; i < 4; i++)
{
    for(0 => int j; j < minor.cap(); j++)
    {
        Std.mtof(minor[j] + offset + position) => osc.freq;
        1 => env1.keyOn;
        beat => now;
    }
}
