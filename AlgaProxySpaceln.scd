(
Server.killAll;
c = TempoClock.new(1).permanent_(true);
p = AlgaProxySpace.boot(
	onBoot: {
		AlgaSynthDef(\playBuf, {
		PlayBuf.ar(2, \sndbuf.ir(0), BufRateScale.kr(\buf.ir), doneAction:2)
	}, sampleAccurate: true).add;

		Buffer.freeAll;
		b.clear;
		b = ();
		b.buf = ();
		b.buf.path = "/Users/ivainkalashnik/Documents/Storage/Okuch/Splice";
		PathName(b.buf.path).entries.collect({
			arg n,i;
			n.extension.postln;
			b.buf[i] = Buffer.read(s, n.fullPath);
		});

		s.sync;

}, server: Server.default, clock: c);
)

(
~a = (
	def: \playBuf,
	dur: 0.5,
	buf: b.buf[3]
).play(chans: 2).stopPatternBeforeReplace_(false).replaceDur_(true);
)






~a = { SinOsc.ar(\freq.kr(300)) * 0.7 };
~a.interpTime = 2;
~a.playTime = 10;
~a.play(chans:2);
~a.stop(time: 10);

~a.from(~b, \freq, time: 10);
~b = { SinOscFB.ar(\freq.kr(100), \fb.kr(0.9), 200) + 200 };
~b.interpTime = 10;
~b.clear;

~c.playTime = 5;
~c.play(chans: 2);

(
~c = (
	def: { SinOsc.ar(\freq.kr(300), mul: 0.5) * EnvPerc.ar(0.01, 0.5, -8) },
	dur: 0.2,
	freq: Pseq([100, 200, 300, 400, 500, 600, 700, 800, 900, 1000], inf)
);
)

~c.from(~a, \in, time: 15);
~c.interpTime = 5;
~c.sched = 4;

(
AlgaSynthDef(\splayer, {
	var buffer, sndbuf, rate, snd;
	buffer = \sndbuf.kr(0);
	rate = BufRateScale.ir(buffer) * \rate.kr(1.0, 0.05);
	snd = PlayBufLoop.ar(2, buffer, rate, \start.kr(0.0), \end.kr(1.0), \loop.kr(1), \keepLoop.kr(0));
	snd = snd * EnvPerc.ar;
	snd = snd * \amp.kr(1.0, 0.05);
	snd = Limiter.ar(snd);
}, sampleAccurate: true).add;
) // stereo looping player

s.sync;

(
Buffer.freeAll;
b.clear;
b = ();
b.buf = ();
b.buf.path = "/Users/ivainkalashnik/Documents/Storage/Okuch/Splice";
PathName(b.buf.path).entries.collect({
	arg n,i;
	n.extension.postln;
	b.buf[i] = Buffer.read(s, n.fullPath);
});
)

(
~c = (
	def: {
	var buffer, sndbuf, rate, snd;
	buffer = \sndbuf.kr(0);
	rate = BufRateScale.ir(buffer) * \rate.kr(1.0, 0.05);
	snd = PlayBuf.ar(2, buffer, rate, 1.0, \start.kr(1.0), \loop.kr(0));
	snd = snd * EnvPerc.ar;
	snd = snd * \amp.kr(1.0, 0.05);
	snd = Limiter.ar(snd);
},
	dur: 0.5,
	sndbuf: Pfunc( { b.buf.choose })
);
)

(
~c.playTime = 5;
~c.interpTime = 5;
~c.sched = 4;
~c.play(chans:2);
)
