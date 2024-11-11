// https://chuck.cs.princeton.edu/doc/program/ugen_full.html

<<<"Our sound">>>;
// blackhole : when you don't want to route signals to output devices
SawOsc osc => dac => WvOut waveOut => blackhole;

// Save the sound to a file
"test.wav" => waveOut.wavFilename;

440 => osc.freq;
0.5 => osc.gain;

1::second => now;