<<< "breaks.ck" >>>;

SndBuf fakeAmen => Pan2 pan => dac;
fakeAmen => NRev rev => dac;

rev =< dac;         // unchuck operator
0.4 => rev.mix;
0.5 => rev.gain;

0.6 => fakeAmen.gain;
me.dir() + "break2.wav" => string filename;
<<< "Attempting to read file:", filename >>>;
filename => fakeAmen.read;

1.4 => float MAIN_RATE;
second / (2 * MAIN_RATE) => dur beat;

MAIN_RATE => fakeAmen.rate;

function void cutBreak(int sliceChoice, dur duration) {
    fakeAmen.samples() / 32 => int slice;
    slice * sliceChoice => int position;
    fakeAmen.pos(position);
    duration => now;
}

while(true) {
    cutBreak(8, 2 * beat);
    cutBreak(24, 2 * beat);
    cutBreak(2, 1 * beat);
    cutBreak(2, 1 * beat);
    cutBreak(8, 1.5 * beat);
    cutBreak(8, 0.25 * beat);
    cutBreak(8, 0.25 * beat);
    
    cutBreak(8, 2 * beat);
    cutBreak(24, 2 * beat);
    rev => dac.right;      // reverb to right
    cutBreak(2, 1 * beat);
    rev =< dac.right;      // unchuck reverb
    rev => dac.left;       // reverb to left
    cutBreak(2, 1 * beat);
    rev =< dac;            // unchuck reverb
    cutBreak(8, 2 * beat);
}