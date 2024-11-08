// create our OSC receiver
OscIn oscin;
// a thing to retrieve message contents
OscMsg msg;
// use port 8338 for FaceOSC input
8338 => oscin.port;

// FaceOSC input addresses
// Listen for "/gesture/mouth/width" message
oscin.addAddress("/gesture/mouth/width");

// Print message to show listening state
<<< "Listening for OSC message from FaceOSC on port 8338...", "" >>>;
<<< " |- expecting \"/gesture/mouth/width\" with 1 continuous parameter...", "" >>>; 

// noise generator, biquad filter, dac (audio output)
Noise n => BiQuad f => dac;
// set biquad pole radius
.99 => f.prad;
// set biquad gain
.05 => f.gain;
// set equal zeros
1 => f.eqzs;

// mapping function to convert mouth width to frequency range
fun float mapMouthWidthToFreq(float width)
{
    // map mouth width from range [10, 16] to [100, 15000]
    return Math.max(100.0, 100.0 + ((width - 10) / (16 - 10)) * (15000.0 - 100.0));
}

// infinite loop to handle incoming OSC messages
while (true)
{
    // wait for OSC message to arrive
    oscin => now;
    
    // check if a message has been received
    while (oscin.recv(msg))
    {
        // retrieve the mouth width parameter
        float mouthWidth;
        msg.getFloat(0) => mouthWidth;
        
        // map to frequency range
        mapMouthWidthToFreq(mouthWidth) => float freq;
        
        // set the filter resonant frequency based on OSC input
        freq => f.pfreq;
        
        // Output the original mouth width and mapped frequency to the console
        chout <= "Original mouth width: " <= mouthWidth <= ", Mapped frequency: " <= freq <= IO.nl();
    }
    
    // advance time (keep the loop active for OSC reception)
    5::ms => now;
}