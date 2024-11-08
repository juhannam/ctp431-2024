// the human interface device (HID)
Hid hi;
// the message for retrieving data
HidMsg msg;

// Open keyboard device
if( !hi.openKeyboard(1) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>; // print out device that was opened

// signal chain
NRev rev => Pan2 pan => dac;

// Mapping parameters
0 => int Osc;
1.0 => float volume;
1000.0 => float lpfCutoff;
1000.0 => float hpfCutoff;
0.0 => float panning;
0.0 => float reverb;
1::ms => dur decayUnit;
200::ms => dur decay;

// Function to handle a note
fun void PlayBeep(int note)
{
    SinOsc sinOsc => ADSR env => LPF lpf => HPF hpf => rev; // create new oscillator and envelope each time
    TriOsc triOsc;
    SqrOsc sqrOsc;
    if(Osc == 0) {sinOsc => env; triOsc =< env; sqrOsc =< env;}
    else if(Osc == 1) {sinOsc =< env; triOsc => env; sqrOsc =< env;}
    else if(Osc == 2) {sinOsc =< env; triOsc =< env; sqrOsc => env;}

    volume => sinOsc.gain => triOsc.gain => sqrOsc.gain; // set gain to 1

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

// Process incoming messages
while( true )
{
    hi => now; // wait for next message
    
    while( hi.recv(msg) && msg.which != 29) // retrieve all pending messages except the the ctrl key
    {

        if (msg.isButtonDown())
        {
            <<< "down:", msg.which, "(code)", msg.key, "(usb.key)", msg.ascii, "(ascii)" >>>;
            if ((msg.ascii >= 48) && (msg.ascii <= 57)) // if the key is a number
            {
                if (msg.ascii == 49) {1 => Osc;}
                else if (msg.ascii == 50) {2 => Osc;}
                else if (msg.ascii == 51) {0 => Osc;}
                else if (msg.ascii == 52) {
                    if (volume > 0.0) {volume-0.1 => volume;<<<"volume decrease: " + volume>>>;}
                    else {0.0 => volume;<<<"volume: " + volume>>>;} }
                else if (msg.ascii == 53) {
                    if (volume < 1.0) {volume+0.1 => volume;<<<"volume increase: " + volume>>>;}
                    else {1.0 => volume;<<<"volume: " + volume>>>;} }
                else if (msg.ascii == 54) {
                    if (lpfCutoff > 100) {lpfCutoff-100 => lpfCutoff;<<<"lpfCutoff decrease: " + lpfCutoff>>>;}
                    else {100.0 => lpfCutoff;<<<"lpfCutoff: " + lpfCutoff>>>;}}
                else if (msg.ascii == 55) {
                    if (lpfCutoff < 1000) {lpfCutoff+100 => lpfCutoff;<<<"lpfCutoff increase: " + lpfCutoff>>>;}
                    else {1000.0 => lpfCutoff;<<<"lpfCutoff: " + lpfCutoff>>>;}}
                else if (msg.ascii == 56) {
                    if (hpfCutoff > 0) {hpfCutoff-1000 => hpfCutoff;<<<"hpfCutoff decrease: " + hpfCutoff>>>;}
                    else {0.0 => hpfCutoff;<<<"hpfCutoff: " + hpfCutoff>>>;}}
                else if (msg.ascii == 57) {
                    if (hpfCutoff < 10000) {hpfCutoff+1000 => hpfCutoff;<<<"hpfCutoff increase: " + hpfCutoff>>>;}
                    else {10000.0 => hpfCutoff;<<<"hpfCutoff: " + hpfCutoff>>>;}}
                else if (msg.ascii == 48) {
                    spork ~ PlayBack(); // playback audio
                    <<< "playback : " + msg.ascii  >>>;
                }
            }
            else if ((msg.ascii >= 65) && (msg.ascii <= 90)) // if the key is a letter
            {
                spork ~ PlayBeep(msg.ascii); // play note
                <<< "note on : " + msg.ascii  >>>;
            }
        }
        else if (msg.isButtonUp())
        {
            if ((msg.ascii >= 48) && (msg.ascii <= 57)) // if the key is a number
            { }
            else if ((msg.ascii >= 65) && (msg.ascii <= 90)) // if the key is a letter
            {
                // <<< "note off: " +msg.ascii>>>;
            }
        }
    }
}