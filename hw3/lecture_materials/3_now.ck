<<< "Start" >>>;
// return the time
<<< now >>>;
// if we send duration to now, chuck plays your sound for that duration,
// and advances for that time.
1::second => dur beat; // type duration
beat => now;

<<< now >>>;
<<< "End" >>>;

1::samp => dur beat_;
beat_ => now;
<<< now >>>;
<<< "End" >>>;