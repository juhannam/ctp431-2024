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