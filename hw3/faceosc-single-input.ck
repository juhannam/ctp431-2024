// create the OSC receiver
OscIn oscin;
// a thing to retrieve message contents
OscMsg msg;
// use port 8338 for FaceOSC input
8338 => oscin.port;

// FaceOSC input addresses
// Listen for "/gesture/mouth/width" message
oscin.addAddress("/gesture/mouth/width");

// print the input values
<<< "Listening for OSC message from FaceOSC on port 8338...", "" >>>;
<<< " |- expecting \"/gesture/mouth/width\" with 1 continuous parameter...", "" >>>; 

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
        
        // map to 0-1 range
        mapInput(mouthWidth, 10, 16) => float mappedWidth;
        
        // Output the original and mapped mouth width to the console
        chout <= "Original mouth width: " <= mouthWidth <= ", Mapped width (0-1): " <= mappedWidth <= IO.nl();
    }
}