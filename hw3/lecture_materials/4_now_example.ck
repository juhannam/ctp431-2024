1::second /2 => dur beat;

// sine oscillator connected to digital audio converter
SinOsc osc => dac;

// set frequency 200Hz
200 => osc.freq;
0.5 => osc.gain;

beat => now;

300 => osc.freq;

beat / 2 => now;

400 => osc.freq;

beat / 2 => now;