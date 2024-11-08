// MIDI input
MidiIn midi;
MidiMsg msg;

// Open MIDI device
0 => int device; // default device ID
if( me.args() ) me.arg(0) => Std.atoi => device; // get device ID from command line if provided
if( !midi.open( device ) ) me.exit(); // open the device or exit if failed
<<< "MIDI device opened:", midi.num(), "->", midi.name() >>>; // Notify which device was opened

// signal chain
NRev rev => Pan2 pan => dac;

// Mapping parameters
0 => int Osc;
1.0 => float volume;
1000.0 => float lpfCutoff;
10.0 => float hpfCutoff;
0.0 => float panning;
0.0 => float reverb;
1::ms => dur decayUnit;
200::ms => dur decay;

// Function to handle a note
fun void PlayBeep(int note, int vel)
{
    if(vel > 0) // note on
    {
        SinOsc sinOsc => ADSR env => LPF lpf => HPF hpf => rev; // create new oscillator and envelope each time
        TriOsc triOsc;
        SqrOsc sqrOsc;
        if(Osc == 0) {sinOsc => env; triOsc =< env; sqrOsc =< env;}
        else if(Osc == 1) {sinOsc =< env; triOsc => env; sqrOsc =< env;}
        else if(Osc == 2) {sinOsc =< env; triOsc =< env; sqrOsc => env;}

        vel/127.0*volume  => sinOsc.gain => triOsc.gain => sqrOsc.gain; // set gain

        (1::ms, decay, 0.0, 1::ms) => env.set; // set ADSR parameters

        lpfCutoff => lpf.freq; // set low-pass filter cutoff
        2 => lpf.Q; // set low-pass filter Q
        hpfCutoff => hpf.freq; // set high-pass filter cutoff
        0.2 => hpf.Q; // set high-pass filter Q
        panning => pan.pan; // set panning
        reverb => rev.mix; // set reverb mix

        note => Std.mtof => sinOsc.freq => triOsc.freq => sqrOsc.freq; // convert MIDI note to frequency and set oscillator
        1 => env.keyOn; // trigger envelope

        200::ms => now; // Calculate total envelope duration and keep this shred alive for that duration
        1 => env.keyOff; // ensure envelope release is called
    }
}

fun void PlayBack()
{
    // Create a buffer object send its output to the DAC
    SndBuf buffer => dac;

    // Load audio file from the path into the buffer
    "./playback-audio.wav" => buffer.read;
    // Move the play head to the end of the buffer to prevent immediate playback
    buffer.samples() => buffer.pos;

    // Set the play head position back to the beginning of the buffer
    0 => buffer.pos;
    // Play the audio for the entire duration of the buffer
    buffer.length() => now;
}

// Process incoming MIDI messages
while( true )
{
    midi => now; // wait for next MIDI message
    
    while( midi.recv(msg) ) // retrieve all pending MIDI messages
    {
        // pan (Joystick)
        if( (msg.data1 == 224)){msg.data3/128.0*2 -1 => panning;<<<panning>>>;}

        // osc (Pad)
        if( (msg.data1 == 153) && (msg.data2 == 40)) {1 => Osc;}
        else if( (msg.data1 == 153) && (msg.data2 == 41)){2 => Osc;}
        else if( (msg.data1 == 153) && (msg.data2 == 42)){0 => Osc;}
        // playback (Pad)
        else if( (msg.data1 == 153) && (msg.data2 == 43)){spork ~ PlayBack();}

        // volume (Knob K1)
        if( (msg.data1 == 176) && (msg.data2 == 70)){msg.data3/127.0 => volume;}

        // LPF
        if( (msg.data1 == 176) && (msg.data2 == 71)){(msg.data3/127.0*900.0 + 100) => lpfCutoff;}

        // HPF
        if( (msg.data1 == 176) && (msg.data2 == 72)){(msg.data3/127.0*990 + 10) => hpfCutoff;}

        // reverb
        if( (msg.data1 == 176) && (msg.data2 == 73)){(msg.data3/254.0) => reverb;}

        // decay (Knob)
        if( (msg.data1 == 176) && (msg.data2 == 74)){( (msg.data3/127.0*120 + 80) * decayUnit) => decay;}

        // Note on
        if( (msg.data1 == 144) && msg.data3 > 0 ) // note on with velocity > 0
        {
            spork ~ PlayBeep(msg.data2, msg.data3); // play note
            <<< msg.data1, msg.data2, msg.data3>>>; // print note and velocity
        }
    }
}
