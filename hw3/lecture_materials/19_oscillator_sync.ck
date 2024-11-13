// Set up two sine wave oscillators and an ADSR envelope
SinOsc mod1 => ADSR env1 => 
SinOsc carrier => 
dac => 
WOut wave => 
blackhole;

// Set the WAV file name
"test.wav" => wave.wavFilename;

// Set frequency and synchronization
2 => carrier.sync;
0.8 => carrier.gain;
220 => carrier.freq; // Carrier frequency
210 => mod1.freq;    // Modulation frequency
500 => mod1.gain;    // Modulation gain

// Set up the ADSR envelope
(1::ms, 2::second, 0, 1::ms) => env1.set;
1 => env1.keyOn;     // Start the sound
2::second => now;    // Play sound for 2 seconds