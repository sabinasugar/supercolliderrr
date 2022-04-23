(
s.quit;
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 16;
s.boot;
c = TempoClock(1).permanent_(true);
p = ProxySpace(s, 'proxyName', c);
p.push;
)

"input:" + s.options.numInputBusChannels.postln;
"output:" + s.options.numOutputBusChannels.postln;

currentEnvironment;


(
p.quant = 0;
p.fadeTime = 4;
)

e = ();
Env([0, 1, 0], [0.001, 1.0], [0, -10]).plot;
e.[\env] = Buffer.sendCollection(s, Env([0, 1, 0], [0.001, 1.0], [0, -10]).discretize, 1);
e.[\snd] = Buffer.read(s,  "/Users/ivainkalashnik/Documents/Wehlt/ts 130805.wav") // "/Users/ivainkalashnik/Documents/Storage/Okuch/Blndre/Ambiences/2020-06-05 155306 test.wav"

"/Users/ivainkalashnik/Documents/Storage/Okuch/Blndre/2019-11-09 175734.wav"

~sig.clear(5);
~sig.ar(2);
~sig.numChannels;

(
~sig = {
	var sndNoise, sndDust, sndMain, snd, chainA, chainB, chain;
	sndDust = Dust2.ar(LFNoise0.kr(1).range(0, 50), 1);
	sndNoise = PlayBuf.ar(2, e.[\snd], 1.0, Impulse.kr(0.001), TRand.ar(0, e.[\snd].numFrames, sndDust), 1.0) * LFNoise0.ar(3).range(0.5, 2.5);
	sndMain = sndDust + FMGrainB.ar(sndDust, LFNoise1.kr(2).range(0.001, 0.05), 50, LFClipNoise.kr(5).range(1000, 10000), 1, e.[\env]).fold2(LFTri.ar(40 + (LFTri.ar(40) * LFNoise0.kr(5).range(1, 20)) + LFNoise2.kr(0.2, 1), 0.0, 0.5) * LFNoise0.ar(3).range(0.05, 1.0));
	snd = BLowPass4.ar(sndMain, LFNoise2.ar(0.3).range(120, 18000).clip(120, 18000), 0.4);
	chainA = FFT({LocalBuf(4096, 1)}.dup, {snd}.dup);
	chainB = FFT({LocalBuf(4096, 1)}.dup, sndNoise);
	chain = PV_Morph(chainA, chainB, LFNoise1.kr(2).range(0.2, 0.8));
	chain = IFFT(chain);
	// snd = chain + (SinOsc.ar(55 + SinOsc.kr(12, mul: 9)) * (LFTri.kr(0.5).unipolar(0.6) + 0.1)) * 0.4;
	snd = chain.softclip + (sndMain * 0.3);
	snd = Limiter.ar(snd);
	snd = Pan2.ar(snd, LFNoise2.ar(2), \amp.kr(0.9));
};
)

~sig = { LFTri.ar(50) ! 2 * \amp.kr(1)};
~sig = {};


~lfo = { SinOsc.kr(1).unipolar(1) * 0.5 };

~lfo2 = { SinOsc.kr(5).unipolar(1) * 0.5 };
~lfo3 = ~lfo + ~lfo2;
~sig.xmap(\amp, ~lfo3);

~sig.reshaping = \elastic;
~sig.fadeTime = 5;
~sig.play(0);
~sig.stop(5);


p.clear;

