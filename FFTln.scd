s.boot;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
SynthDef("help-magStretch", { arg out=0, bufnum=0;
    var in, chain;
    in = LFSaw.ar(200, 0, 0.2);
    chain = FFT(LocalBuf(2048), in);
    chain = PV_MagShift(chain, MouseX.kr(0.25, 4, \exponential) );
    Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s);
)


s.boot;
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
//trig with MouseY
SynthDef("help-binScramble", { arg out=0, soundBufnum=2;
    var in, chain;
    in = PlayBuf.ar(1, soundBufnum, BufRateScale.kr(soundBufnum), loop: 1);
    chain = FFT(LocalBuf(2048), in);
    chain = PV_BinScramble(chain, MouseX.kr , 0.1, MouseY.kr > 0.5 );
    Out.ar(out, 0.1 * IFFT(chain).dup);
}).play(s, [\soundBufnum, b]);
)