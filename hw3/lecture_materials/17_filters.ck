<<< "Filters" >>>;

SawOsc osc => LPF filter => dac => WvOut waveOut => blackhole;
// SawOsc osc => HPF filter => dac => WvOut waveOut => blackhole;

"filters.wav" => waveOut.wavFilename;

2000 => filter.freq;
// 440 => osc.freq;
10 => filter.Q;
0.5 => osc.gain;

1::second => now;