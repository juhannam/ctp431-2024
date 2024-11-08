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

// map the input value to a 0-1 range
fun float mapInput(float width, float min, float max)
{
    return Math.max(0.0, (width - min) / (max - min));
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
        
        // map to gain range (0-1 for volume)
        mapInput(mouthWidth, 10, 16) => float gain;
        
        // set the noise volume based on OSC input
        gain => n.gain;
        
        // Output the original mouth width and mapped gain to the console
        chout <= "Original mouth width: " <= mouthWidth <= ", Mapped gain (0-1): " <= gain <= IO.nl();
    }
    
    // advance time (keep the loop active for OSC reception)
    5::ms => now;
}