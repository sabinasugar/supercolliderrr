Buffer.freeAll;

(
~b1 = Buffer.readChannel(s,"/Users/ivainkalashnik/Documents/Wehlt/2-Audio 0001 [2021-10-18 223740].wav", channels: 0);
~envload = Env([0, 1, 0], [0.01, 0.8], -5);
~envbuf = Buffer.sendCollection(s, ~envload.discretize, 1);
~envload2 = Env([0, 1, 0, 0], [0.15, 0.15, 0.5], -10);
~envbuf2 = Buffer.sendCollection(s, ~envload2.discretize, 1);
)

~b1.bufnum
~envbuf.plot
~envbuf2.plot


(
SynthDef(\ShiftPlay, {
	arg amp = 0.5;
	var grain, saw, fftbufA, fftbufB, fft, filter, env;

	grain = GrainBuf.ar(1, // channels
		Impulse.ar(5), // trigger
		1, // grain size in secs
		~b1.bufnum, // sample buffer
		0.5, // rate
		((LFSaw.ar(0.003)+1)/2), // pb position 0 = start, 1 = end
		4, // interpolation
		0, // pan
		~envbuf.bufnum, // grain envelope buffer
		512); // max grains
	// grain = FreqShift.ar(grain, MouseY.kr(-400, 400));

	fft = FFT(LocalBuf(512), grain);
	fft = PV_MagFreeze(fft, Gate.kr(LFNoise0.kr(2), LFNoise0.kr(15)));
	fft = PV_MagSmear(fft, LinLin.kr(LFNoise2.ar(0.1), -1.0, 1.0, 0, 10));
	fft = PV_MagGate(fft, 0.8, 10);
	// fft = PV_BinShift(fft, MouseY.kr(-1, 1), MouseX.kr(-1, 1));
	fft = IFFT(fft);
	// filter = BLowPass4.ar(fft, LinLin.ar(LFNoise2.ar(0.5), -1.0, 1.0, 40.0, 15000.0), 0.5).tanh;
	// env = EnvGen.ar(Env.perc(0.001, 3, 1.0, 20), doneAction: 2);

	Out.ar(0, Pan2.ar(fft, 0.0, amp).tanh);
}).add;
)

Synth(\ShiftPlay)

(
b = Buffer.alloc(s, 1024, 1);
c = Buffer.alloc(s, 1024, 1);
d = Buffer.read(s,"/Users/ivainkalashnik/Documents/Storage/Okuch/Okuchy/mlset2.wav" );
)

(
SynthDef("help-magMinus", { arg out=0, bufnumA=0, bufnumB=1, soundBufnum=2;
    var inA, inB, chainA, chainB, chain;
    inA = Warp1.ar(1, soundBufnum, ((LFSaw.ar(0.0008)+1)/2), LFNoise2.ar(0.1, 1.5)+ 0.5, 0.2, ~envbuf, 8, 0.0, 2, 0.5);
    inB = WhiteNoise.ar(LFNoise2.kr(50).max(0));
    chainA = FFT(bufnumA, inA);
    chainB = FFT(bufnumB, inB);
    chain = PV_MagMinus(chainA, chainB, MouseX.kr(0, 1));
	chain = PV_SpectralEnhance(chain, 8, 1.5, MouseY.kr(0, 0.5));
	// chain = PV_MagFreeze(chain, Gate.kr(LFNoise0.kr(15), LFNoise0.kr(15)));
    Out.ar(out,  IFFT(chain).dup);
}).play(s,[\out, 0, \bufnumA, b.bufnum, \bufnumB, c.bufnum, \soundBufnum, d.bufnum]);
)

