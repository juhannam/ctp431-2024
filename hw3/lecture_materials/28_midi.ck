// set up audio chain
SinOsc osc => ADSR env1 => NRev rev => dac;
0.5 => osc.gain;
(1::ms, 100::ms, 0.0, 1::ms) => env1.set;
0.1 => rev.mix;

// get MIDI device input
MidiIn midi;
MidiMsg msg;
0 => int device;
if( me.args() ) me.arg(0) => Std.atoi => device;
if ( !midi.open( device ) ) me.exit();
<<< "MIDI device:", midi.num(), " -> ", midi.name() >>>;

fun void PlayBeep(int key) {
    key => Std.mtof => osc.freq;
    1 => env1.keyOn;
    100::ms => now;
    1 => env1.keyOff;
}

while (true) {
    midi => now;
    while (midi.recv(msg)) {
        if (msg.data1 == 144) {
            spork ~ PlayBeep(msg.data2);
            <<< msg.data1, msg.data2, msg.data3 >>>;
        }
    }
}