// create our OSC receiver
OscIn oscin;
// a thing to retrieve message contents
OscMsg msg;
// use port 8338 for FaceOSC input
8338 => oscin.port;

// FaceOSC input addresses
// Listen for "/gesture/mouth/width" and "/gesture/mouth/height" messages
oscin.addAddress("/gesture/mouth/width");
oscin.addAddress("/gesture/mouth/height");

// print the input values
<<< "Listening for OSC messages from FaceOSC on port 8338...", "" >>>;
<<< " |- expecting \"/gesture/mouth/width\" and \"/gesture/mouth/height\" with continuous parameters...", "" >>>; 

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
        // determine the address of the received message
        if (msg.address == "/gesture/mouth/width")
        {
            // retrieve the mouth width parameter
            float mouthWidth;
            msg.getFloat(0) => mouthWidth;
            
            // map mouth width to 0-1 range
            mapMouthParam(mouthWidth, 10, 16) => float mappedWidth;
            
            // output the original and mapped mouth width to the console
            chout <= "Original mouth width: " <= mouthWidth <= ", Mapped width (0-1): " <= mappedWidth <= IO.nl();
        }
        else if (msg.address == "/gesture/mouth/height")
        {
            // retrieve the mouth height parameter
            float mouthHeight;
            msg.getFloat(0) => mouthHeight;
            
            // map mouth height to 0-1 range
            mapMouthParam(mouthHeight, 5, 10) => float mappedHeight; // adjust range as needed
            
            // Output the original and mapped mouth height to the console
            chout <= "Original mouth height: " <= mouthHeight <= ", Mapped height (0-1): " <= mappedHeight <= IO.nl();
        }
    }
}