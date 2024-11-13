// https://chuck.cs.princeton.edu/doc/program/ugen_full.html

<<< "13: Samples and the SndBuf Ugen" >>>;

SndBuf guitar => dac;

// me.dir() -> directory that the chuck is running
me.dir() + "guitar.wav" => string filename;
filename => guitar.read;
// when read by SndBuf, ugen is set to start from sample zero
// we can manually select sample position by chucking a number to [sample].pos;

 // starts from the middle
// guitar.samples() / 2 => guitar.pos;

// plays 0.5 rate slowly
// 0.5 => guitar.rate; 

// plays backward
guitar.samples() -1 => guitar.pos; 
-1 => guitar.rate;


7::second => now; 



