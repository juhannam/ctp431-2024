// https://chuck.stanford.edu/doc/program/ugen.html

<<<"This is on the command line!">>>;
// Concept : Chuck(connect) a sine oscillator to the digital-to-analog converter
SinOsc osc => dac; 

// Set the frequency of the oscillator to 440 Hz, and the gain to 0.5
440 => osc.freq;
0.5 => osc.gain;

// if we send duration to now, chuck plays your sound for that duration,
1::second => now;