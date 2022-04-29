s.boot;
p.pop;

(
~size = 2.pow(11);
~sig = Signal.sineFill(
	~size,
	[1, 0, 0.5, 0, 0.5, 0.25, 0, 0.1],
	[0, 0, pi/2, 0, pi, 0, 0, pi]
);
)

~sig.plot;

~sig.play(true, 0.2, 2);

(
~imag = Signal.newClear(~size);
~cosTable = Signal.fftCosTable(~size);
~complex = fft(~sig, ~imag, ~cosTable);
)

~complex;

(
plot(
	[
		~complex.magnitude[0..15].normalize * ~sig.peak,
		~complex.phase[0..15] + (pi/2) % 2pi
	],
	bounds: Rect(900, 400, 800, 600)
).plotMode_(\bars);
)

 2048/44100 // segment size in ms 0.046439909297052

b = Buffer.read(s, "/Users/ivainkalashnik/Desktop/yPLO - Stop Constant/yPLO - 6.wav");
b.play;

(
~sig = Signal.newClear(~size);
b.getn(0, ~size, { | frames |
	~sig.waveFill({ | val, old, index |
		frames[index]})
});
)

~sig.plot;
~sig.class; // ~sig now a signal class

(
// calculate fft for sample
Window.closeAll;
~imag = Signal.newClear(~size);
~cosTable = Signal.fftCosTable(~size);
~complex = fft(~sig, ~imag, ~cosTable);
~mag = ~complex.magnitude.normalize * ~sig.peak;
~phs = ~complex.phase + (pi/2) % (2pi);
)

(
// first n bins data
var n = 50;
plot(
	[
		~mag[0..n+1],
		~phs[0..n+1],
	],
	bounds: Rect(1100, 600, 800, 400),
	minval: [0, 0], maxval: [~sig.peak, 2pi]
).plotMode_(\bars);
)

FFT

//see PV_ChainUGen for descriptions of pvcalc, pvcalc2, and pvcollect
//these are "choose your own adventure" server-side FFT methods which allow custom procesing of magnitudes and phases, and even individual processing on each bin!

//these three methods tend to create very big SynthDefs that require a lot of processing power! the PV_ChainUGen help file includes tips for optimizing the processing requirements.

(
SynthDef(\pvcalc, {
	var sig, chain, size=2048;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = chain.pvcalc(size, {
		arg mag, phs;
		mag = mag.rotate(-9); //rotate magnitudes
		[mag, phs];
	});
	sig = IFFT(chain) * \amp.kr(0.5)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

//open FreqScope.new; to more easily "see" the bin rotation
//with a negative rotation, energy at each bin shifts a bit lower on the spectrum, and the very lowest bins appear at the very top
x = Synth(\pvcalc, [\buf, ~buf]);

(
SynthDef(\pvcalc, {
	var sig, chain, size=2.pow(11);
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = chain.pvcalc(size, {
		arg mag, phs;
		//apply some randomness to magnitudes and phases
		mag = mag * ({Rand(-20.dbamp, 3.dbamp)}!(mag.size));
		phs = phs + ({rrand(0,2pi)}!(phs.size));
		[mag, phs];
	});
	sig = IFFT(chain) * \amp.kr(0.5)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\pvcalc, [\buf, ~buf]);

//pvcalc2 allows processing on the magnitudes and phases of two different FFT chains

(
//basic vocoder effect, i.e. daft punk, imogen heap, etc
SynthDef(\pvcalc2, {
	var sig, sig2, chain, chain2, size=1024;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	sig2 = Saw.ar([40,47,52,56,58,61,63].midicps * \trnsp.kr(0).midiratio, 0.05).sum;
	chain = FFT(LocalBuf(size), sig);
	chain2 = FFT(LocalBuf(size), sig2);
	chain = chain.pvcalc2(chain2, size, {
		arg mag, phs, mag2, phs2;
		mag = (mag * \blend.kr(1)) + (mag2 * (1-\blend.kr(1)));
		[mag, phs2];
	});
	sig = IFFT(chain) * \amp.kr(0.2)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

//phase vocoder effect (combining magnitudes of modulator signal with phases of carrier signal)
x = Synth(\pvcalc2, [\buf, ~buf]);
x.set(\trnsp, rrand(-2,14)); //transposition
x.set(\blend, 0.8); //magnitude crossfade
x.set(\blend, 0.5);

//this is not a particularly intersting use of pvcollect because it doesn't incorporate the bin number...see the helpfile for other ideas
(
SynthDef(\pvcollect, {
	var sig, sig2, chain, chain2, size=512;
	sig = PlayBuf.ar(1, \buf.kr(0), BufRateScale.ir(\buf.kr(0)), loop:1);
	chain = FFT(LocalBuf(size), sig);
	chain = chain.pvcollect(size, {
		arg mag, phs, bin;
		//each magnitude is modulated by a random sine wave LFO
		mag = mag + SinOsc.kr(Rand(0.1,0.5), Rand(0,2pi)).exprange(0.01,1);
		[mag, phs];
	});
	sig = IFFT(chain) * \amp.kr(1)!2;
	Out.ar(\out.kr(0), sig);
}).add;
)

x = Synth(\pvcollect, [\buf, ~buf]);
x.free;

(
{
    var in, chain, v;
    in = PlayBuf.ar(1, b, BufRateScale.kr(b), loop: 1);
	chain = FFT(LocalBuf(2.pow(13)), in);

    v = LFPar.kr(0.5).range(0.1, 1);

    chain = chain.pvcollect(2.pow(13), {|mag, phase, index|

//////// Try uncommenting each of these lines in turn and re-running the synth:
        // mag;
        //[mag, phase];
        //[mag, phase] / 3;
        //[mag, phase].sqrt;
        [mag, 3.14.rand];
        //[mag, LFNoise0.kr.range(0, 3.14)];
        [mag * Dseq([1, 0, 0, 1, 1, 0, 1, 0].stutter(8), 999999999999)]; // Can even use Demand ugens! One val demanded each frame
        [mag.sqrt, 3.14.rand];
        if(index % 7 == 0, mag, 0); // Comb filter
        //if(LFNoise0.kr(10) > 0.5, mag, 0);
        mag + DelayN.kr(mag, 1, v); // Spectral delay

		if((index - LFPar.kr(3).range(2, 1024/20)).abs < 10, mag, 0); // Swept bandpass

    }, frombin: 0, tobin: 512, zeroothers: 1);

    0.9 * IFFT(chain).dup
}.play
)

/////////////////////////////////////////////////////////////

(
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
s.reboot;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s, \proxyName, c);
p.quant = 4;
m = ProxyMixer(p, 8);
m.parent.alwaysOnTop_(true);
ProxyMeter.addMixer(m);
)

currentEnvironment;

p.playingProxies;
p.fadeTime = 5;
c.tempo_(1);

(
b = ();
b.yplo = Buffer.read(s, "/Users/ivainkalashnik/Desktop/1-Audio 0001 [2022-04-06 120226].wav");
)

b.yplo;

(
~out = {
	var size, snd, chain;
	size = 2.pow(12);
	snd = PlayBuf.ar(1, b.yplo, BufRateScale.kr(b.yplo), loop: 1);
	chain = FFT(LocalBuf(size), snd);
	snd = IFFT(chain);
	snd = Limiter.ar(snd);
};
)

(
~out = {
	var snd, chain;
	snd = PlayBuf.ar(1, b.yplo, BufRateScale.kr(b.yplo), loop: 1);
	chain = FFT(LocalBuf(2048), snd);
	chain = chain.pvcollect(2048, {
		| mag, phases, i |
		[mag, phases];
		if ( mag > 0.5, mag * 0, mag);
	}, 0, nil, 0);
	snd = IFFT(chain);
	snd = snd ! 2;
	snd = Limiter.ar(snd);
};
)

(
~out = {
	var n, size, imag, cosTable, complex, sig, snd, chain, chain2;
	n = 200;
	size = 2.pow(11);
	sig = Signal.sineFill(
	size,
	[(1/Array.fill(n*2, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(n),
	0 ! n
	);
	sig.plot;
	imag = Signal.newClear(size);
	cosTable = Signal.fftCosTable(size);
	complex = fft(sig, imag, cosTable);
	snd = PlayBuf.ar(1, b.yplo, BufRateScale.kr(b.yplo), loop: 1);
	chain = FFT(LocalBuf(size), snd);
	chain2 = chain.pvcalc(size, {
		| mag, phases |
		[complex.magnitude.postln, complex.phase + (pi/2) % 2pi]; // complex.phase + (pi/2) % 2pi
}, 0, nil, 0);
	chain = chain.pvcalc2(chain2, size, { | magnitudes1, phases1, magnitudes2, phases2  |
		[magnitudes1 - magnitudes2, phases1 - phases2];
	}, 0, nil, 1);
	snd = IFFT(chain);
	snd = snd ! 2;
	snd = Limiter.ar(snd);
};
)



p.reshaping = \elastic;
~out.ar(2);

(
x = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(150);
s = Signal.sineFill(
	2048,
	x,
	0 ! 150;
);
Post << x;
s.plot;
)



(
~out = {
	var n, size, sig, snd, snd2, chain, chain2;
	n = 300;
	size = 2.pow(15);
	sig = Buffer.alloc(s, size);
	sig = sig.sine1([(1/Array.fill(n*2, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(n), true, true);
	snd = PlayBuf.ar(1, b.yplo, BufRateScale.kr(b.yplo), loop: 1);
	snd2 = OscN.ar(sig, MouseY.kr(20.0, 1000.0), 0.0);
	chain = FFT(LocalBuf(size), snd);
	chain2 = FFT(LocalBuf(size), snd2);
	chain = PV_MagMul(chain, chain2);
	snd = IFFT(chain);
	snd = snd ! 2;
	snd = Limiter.ar(snd);
};
)

~out.play;

