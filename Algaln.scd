Alga.boot(server: s);

a = AlgaNode({ SinOsc.ar(\freq.kr(440))!2 * 0.3 }); //Play both channels
a.play;

a <<.freq 200;
a.from(40, \freq, time: 10);

a.replace({ Saw.ar(\freq.kr(20))!2 * 0.3  }, time: 10);
a.replace({ SinOsc.ar(\freq.kr(440))!2 * 0.3  }, time: 10);

b = AlgaNode({ LFNoise0.kr(\freq.kr(10)).range(20, 400) });


a.from(b, \freq, time: 5);

(
AlgaSynthDef(\sine, {
	SinOsc.ar(\freq.ar(440));
}).add;
)

c = AlgaNode(\sine, [\freq, 2]);

a.mixFrom(c, \freq, scale:[-200, 100], time: 1);
b.mixFrom(c, \freq, scale:[10, 20]);

c.clear(time: 10);
b.clear(time: 3);
a.clear(time: 10);

(
AlgaSynthDef(\wplayer, {
	var buffer, rate, pointer, snd;
	buffer = \sndbuf.kr(0);
	rate = \rate.kr(1.0, 0.2);
	pointer = LFSaw.ar(BufDur.ir(buffer).reciprocal(1) * rate, 0.0).linlin(0.0, 1.0, \start.kr(0.0, 0.2), 1.0, clip: \minmax);
	snd = WarpZ.ar(
		numChannels: 2,
		bufnum: buffer,
		pointer: pointer,
		freqScale: BufRateScale.kr(buffer) * \fScale.kr(1.0, 0.1),
		windowSize: \wSize.kr(0.2, 0.1),
		envbufnum: \wEnv.kr(-1),
		overlaps: \oLaps.kr(1.0, 0.1),
		windowRandRatio: \wRand.kr(0.0, 0.1),
		interp: 1,
		zeroSearch: 0.1,
		zeroStart: 0.1
	);
	snd = Select.ar(
		\normOn.kr(0, 0, spec: Spec.add(\normOn, [0, 1, \lin, 1].asSpec)), [
			snd,
			Normalizer.ar(in: snd, level: 0.9, dur: 0.009)]);
	snd = snd * 0.5; // Env.adsr(\atk.kr(0.001), \dec.kr(0.1), \sus.kr(1.0), \rel.kr(0.1), curve: \curve.kr(-4.0)).kr(2, \gate.kr(1.0));
	snd = snd * \amp.kr(1.0, 0.1, spec: Spec.add(\amps, [0.0, 1.0, \lin].asSpec));
	snd = Limiter.ar(snd);
	// snd = Pan2.ar(snd, \pan.kr(0.0, 0.05));
	// Out.ar(\out.kr(0), snd);
}, metadata: (
	specs: (
		rate: [0.0, 2.0, \lin, 0.01].asSpec,
		start: [0.0, 1.0, \lin, 0.01].asSpec,
		fScale: [0.001, 5.0, \lin].asSpec,
		wSize: [0.001, 5.0, \lin].asSpec,
		oLaps: [0.01, 15.0, \lin].asSpec,
		wRand: [0.0, 1.0, \lin].asSpec,
		atk: [0.0001, 2.0, \lin, 0.005].asSpec,
		dec: [0.05, 10.0, \lin, 0.01].asSpec,
		sus: [0.0, 1.0, \lin, 0.05].asSpec,
		rel: [0.005, 10.0, \lin, 0.01].asSpec,
		pan: [-1.0, 1.0, \lin, 0.05].asSpec
	)
)).add;
) // stereo warping player

(
AlgaSynthDef(\splayer, {
	var buffer, sndbuf, rate, snd;
	buffer = \sndbuf.kr(0);
	rate = BufRateScale.ir(buffer) * \rate.kr(1.0, 0.05);
	snd = PlayBufLoop.ar(2, buffer, rate, \start.kr(0.0), \end.kr(1.0), \loop.kr(1), \keepLoop.kr(1));
	snd = snd * \amp.kr(1.0, 0.05);
	snd = Limiter.ar(snd);
}).add;
) // stereo looping player

~buf = Buffer.read(s, "/Users/ivainkalashnik/Desktop/2-Audio 0001 [2022-07-04 233951].wav");
~buf2 = Buffer.read(s, "/Users/ivainkalashnik/Desktop/2-Audio 0001 [2022-07-04 233947].wav");

w = AlgaNode(\wplayer, [\sndbuf, ~buf, \oLaps, 10.5.rand, \wSize, 2.0.rand, \rate, 1.0.rand, \fScale, 2, \amp, 0.5, \wRand, 0.01, \start, 1.0.rand, \normOn, 1, \atk, 0.2, \sus, 0.0, \dec, 5, \curve, -10], interpTime: 2).play(chans:2);

w = AlgaNode(\splayer, [\sndbuf, ~buf, \start, 0.0, \end, 1.0, \loop, 1, \amp, 0.5], interpTime: 2).play(chans: 2);


w.from(10.5.rand.postln, \oLaps, time: 5);
w.from(2.0.rand.postln, \wSize, time: 5);
w.from(0.9, \rate, time: 5);
w.from(1, \fScale, time: 5);
w.from(0.1, \wRand, time: 2);
w.from(0, \normOn, time: 2);
w.from(10.dbamp, \amp, 5);
w.from(~buf, \sndbuf, time: 2);

~sin = AlgaNode({ SinOsc.kr(0.1) });
~sin.replace({ LFTri.kr(0.1).range(0.1, 0.9) });

w.from(~sin, \rate, time: 1);

w.from(0.5.rand, \start, time: 5);

(
t = Task({
	loop {
		w.from(0.9.rand, \start, time: 5);
		w.from([~buf, ~buf2].choose, \sndbuf, time: 6);
		10.wait;
	};
});
)

t.play;

