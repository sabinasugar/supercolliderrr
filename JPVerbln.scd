Bo.ot;

p.fadeTime = 1.0;

(
Ndef(\src, {
	var snd;
	snd = Dust.ar(1);
	snd = snd + (WhiteNoise.ar(0.1)*Env.perc(0.001, 0.6, 1.0, -5.0).kr(0, snd));
	snd = Splay.ar(Pluck.ar(snd, snd, ([500, 440, 460] + MouseY.kr(-400, 100)).reciprocal, ([400, 440, 460] + MouseX.kr(-400, 100)).reciprocal, 9.0, 0.75).fold(0.9) * 0.9, 1.0, 5);
	// snd = Greyhole.ar(snd, delayTime: 0.0005, damp: 0.0001, size: 0.05, diff: 0.8, feedback: 0.2, modDepth: 0.5, modFreq: 0.2);
	snd = LinSelectX.ar(\dryWet.kr(0.5, 0.1, spec: Spec.add(\dryWet, [0.0, 1.0, \lin].asSpec)),
		[snd, JPverb.ar(
		snd,
		t60: \time.kr(0.1, 0.1, spec: Spec.add(\time, [0.1, 30.0, \lin].asSpec)),
		damp: \damp.kr(0.1, 0.1, spec: Spec.add(\damp, [0.0, 1.0, \lin].asSpec)),
		size: \size.kr(0.5, 0.1, spec: Spec.add(\size, [0.5, 5.0, \lin].asSpec)),
		earlyDiff: \early.kr(0.1, 0.1, spec: Spec.add(\early, [0.0, 1.0, \lin].asSpec)),
		modDepth: \modDepth.kr(0.1, 0.1, spec: Spec.add(\modDepth, [0.0, 1.0, \lin].asSpec)),
		modFreq: \modFreq.kr(0.1, 0.1, spec: Spec.add(\modFreq, [0.0, 10.0, \lin].asSpec)),
		low: 1.0,
		mid: 1.0,
		high: 1.0,
		lowcut: 500.0,
		highcut: 2000.0) * \JPVerbMul.kr(1.0, 0.1, spec: Spec.add(\JPVerbMul, [0.0, 2.0, \lin].asSpec))]);
	snd = Select.ar(
		\normOn.kr(0, 0, spec: Spec.add(\normOn, [0, 1, \lin, 1].asSpec)), [
			snd,
			Normalizer.ar(in: snd, level: 0.9, dur: 0.009)]);
});
)

Ndef(\src).fadeTime = 1;
Ndef(\src).play;
Ndef(\src).gui.parent.alwaysOnTop_(true);

Buffer.freeAll;



b = ();

(
b.pgsx = Array.fill(2, { | i |
	Buffer.readChannel(s, "/Users/ivainkalashnik/Desktop/Filt01.wav", channels: i);
});
)

b.pgsx[0]

b.pgsx; // array of right and left channel buffers

(
e = ();
e.perc = Env.perc(0.1, 0.9, 1.0, -10.0);
e.perc = Buffer.sendCollection(s, e.perc.discretize, 1);
)

(
~node[0] = {
	var rate, pointer, snd;
	rate = \rate.kr(1.0, 0.2, spec: Spec.add(\rate, [0.0, 2.0, \lin, 0.01].asSpec));
	pointer = LFSaw.ar(BufDur.ir(b.pgsx).reciprocal(1) * rate, 0.0).linlin(0.0, 1.0, \start.kr(0.0, 0.2, spec: Spec.add(\start, [0.0, 1.0, \lin, 0.01].asSpec)), 1.0, clip: \minmax);
	snd = Warp1.ar(
		numChannels: 1,
		bufnum: b.pgsx,
		pointer: pointer,
		freqScale: \fScale.kr(1.0, 0.1, spec: Spec.add(\fScale, [0.0, 5.0, \lin].asSpec)),
		windowSize: \wSize.kr(0.2, 0.1, spec: Spec.add(\wSize, [0.001, 5.0, \lin].asSpec)),
		envbufnum: e.perc,
		overlaps: \oLaps.kr(1.0, 0.1, spec: Spec.add(\oLaps, [0.01, 15.0, \lin].asSpec)),
		windowRandRatio: \wRand.kr(0.0, 0.1, spec: Spec.add(\wRand, [0.0, 1.0, \lin].asSpec)),
		interp: 1
	);
	snd = snd * \amp.kr(1.0, 0.1, spec: Spec.add(\amps, [0.0, 1.0, \lin].asSpec));
	snd = Select.ar(
		\normOn.kr(0, 0, spec: Spec.add(\normOn, [0, 1, \lin, 1].asSpec)), [
			snd,
			Normalizer.ar(in: snd, level: 0.9, dur: 0.009)]);
};
)



(
~node[1] = \filter -> { | in |
	var snd;
	snd = in + (SinOsc.ar(100)*\wNoise.kr(0.0, 0.2, spec: Spec.add(\wNoise, [0.0, 1.0, \lin].asSpec)));
};
)

~node[1] = nil;

{LFSaw.kr(1.0)}.plot(1.0);

~node.set(\wet1, 1.0);

~node.gui.parent.aslwaysOnTop_(true);
