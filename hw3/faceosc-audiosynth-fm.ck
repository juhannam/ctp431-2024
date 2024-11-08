// create our OSC receiver
OscIn oscin;
// a thing to retrieve message contents
OscMsg msg;
// use port 8338 for FaceOSC input
8338 => oscin.port;

// listen for "/gesture/mouth/width" message
oscin.addAddress("/gesture/mouth/width");

// print message to show listening state
<<< "Listening for OSC message from FaceOSC on port 8338...", "" >>>;
<<< " |- expecting \"/gesture/mouth/width\" with 1 continuous parameter...", "" >>>; 

// array to hold parameters
1 => int NUM_PARAMS;
float params[NUM_PARAMS];

// basic FM synthesis setup
// modulator to carrier connection
SinOsc m => SinOsc c => dac;

// set sync for FM synthesis
2 => c.sync;

// initial carrier frequency
440 => float cf => c.freq;
// initial modulator frequency
110 => float mf => m.freq;
// initial modulation index
300 => float index => m.gain;

// map the input value to a 0-1 range
fun float mapInput(float width, float min, float max)
{
    return Math.max(0.0, (width - min) / (max - min));
}

// infinite loop to handle incoming OSC messages
spork ~ updateModulatorFrequency();
while (true)
{
    // wait for OSC message to arrive
    oscin => now;
    
    // check if a message has been received
    while (oscin.recv(msg))
    {
        // unpack parameter (expecting only one for mouth width)
        msg.getFloat(0) => params[0];
        
        // map to 0-1 range
        mapInput(params[0], 10, 16) => float mouthControl;
        
        // update modulator frequency based on mouthControl
        20 + (mouthControl * 1000) => mf => m.freq;
        
        // print the mapped mouth width and modulator frequency for debugging
        <<< "Mapped mouth width:", mouthControl, "Modulator Frequency:", mf >>>;
    }
}

// function to modulate frequency in real-time
fun void updateModulatorFrequency()
{
    while (true)
    {
        // set carrier frequency and modulator gain for FM synthesis
        cf => c.freq;
        index => m.gain;
        
        // advance time by 1 sample
        1::samp => now;
    }
}