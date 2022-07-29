(
Server.killAll;
t = TempoClock(1).permanent_(true);
p = AlgaProxySpace.boot(clock: t);
p.interpTime = 5;
p.playTime = 0.1;
c = (); // TempoClock tracking
c.track = Tdef(\tempo, {
	loop {
		("tempo: " ++ t.tempo.asString).postln;
		1.wait;
	};
});
)

c.track.play;
c.track.stop;
Alga.interpolateTempo(tempo: 70/60, time: 10, delta: 0.1, schedInSeconds: false, sched: AlgaQuant(4));

(
AlgaSynthDef(\playBuf, {
	var snd;
	snd = PlayBuf.ar(2, \sndbuf.ir(0), BufRateScale.kr(\sndbuf.ir) * \rate.kr(1.0), startPos: \start.kr(0.0)) * EnvGen.ar(Env.perc(\atk.kr(0.01), \rel.kr(0.9), 1.0, \curve.kr(-7)), doneAction: 2); // EnvPerc.ar(\atk.kr(0.01), \rel.kr(0.9), \curve.kr(-7));
	snd = snd * \amp.kr(1.0);
}, sampleAccurate: true).add;

AlgaSynthDef(\comb, {
	var comb;
	comb = LeakDC.ar(CombC.ar(\in.ar(0), delaytime: \dt.kr(0.1), decaytime: \dct.kr(0.2)));
	comb = comb * EnvPerc.kr(0.001, 0.6, -6, 0);
	// AlgaDetectSilence.ar(comb); // ?
	comb;
}).add;

AlgaSynthDef(\tube, {
	var snd;
	snd = (NTube.ar(\in.ar(0),`[0.97,1.0,1.0,1.0,1.0,0.97],`[0.5, 0.2, 0.7,-0.4],`([0.01,0.02,0.01,0.005,0.05]*\in2.kr(0.5)))*0.1).dup;
	// snd = LeakDC.ar(snd);
	snd = snd * EnvPerc.kr(0.001, 1.5, -3, 0);
	// AlgaDetectSilence.ar(comb); // ?
	snd;
}).add;

)

(
~a.interpTime = 5;
~a.playTime = 5;
~a.play(chans: 2);
)

( // or
~a.it = 7;
~a.pt = 3;
~a.play(chans: 2);
)

(
~c = { LFSaw.kr(0.2).range(0.55, 4.0) };
~c.pt = 5;
~c.it = 5;
)
~c.clear;

(
~a = (
	def: \playBuf,
	dur: Pdup(Prand([1, 2, 4, 8], inf), Pseq([Prand([0.1, 0.2], 8), Pn(0.4, 1)], inf)),
	sndbuf: Pfunc( { [b.buf[rrand(1, 20)], \r].wchoose([0.8, 0.2]) }),
	rate: 1,
	amp: -8.dbamp,
	rel: 1.5,
	get: Pkey(\dur, inf), // yes it is possible
	fx: Pwrand([
		(
		def: \comb,
		dt: Pwhite(Pseq([Pn([0.01], 8), Pn([0.09], 8)], inf), Pseq([Pn([0.05], 8), Pn([0.2], 8)], inf), inf),
		dct: Pn(Pseries(0.2, 0.2, 8), inf)
		),
		(
		def: \tube,
		in2: ~in2mod
	),
		\dry], [0.2, 0.5, 0.3], inf)
);
)

/*~a.from(~c, \rate, time: 8);
~a <<.rate ~c;*/

~c >>.rate ~a;

(
~b = {
	var snd;
	snd = XFade2.ar(AdCVerb2.ar(Splay.ar(\in.ar(0), 1), SinOsc.ar(LFNoise2.kr(0.5).range(0.01, 20.0)).range(0.01, 0.99), 0.7, 1, 0.3, combScale: 1.0), \in.ar(0), pan: 0.9, level: 0.8);
};
)

~b.it = 5;
~b.pt = 10;
~b.from(~a, \in, time:8); // or
~a >>.in ~b;
~b.play(chans:2);

(
~a.clear(time: 15)
~a.stopPattern(sched: 0);
~b.clear(time: 15);
~c.clear(time: 15);
)

p.clear(time:2);

(
b.clear;
b = ();
b.buf = ();
b.buf.path = "";
PathName(b.buf.path).entries.collect({
	arg n,i;
	n.extension.postln;
	b.buf[i] = Buffer.read(s, n.fullPath);
});
)

b.buf2 = Buffer.read(s, "/Users/ivainkalashnik/Documents/1510/net and util.wav");

~d.it = 5;
~d.pt = 10;
(
~d = (
	def: \playBuf,
	dur: 2,
	rate: 0.8,
	rel: 1,
	curve: -5,
	amp: 0.9,
	sndbuf: b.buf2,
	start: Pfunc({ rrand(b.buf2.numFrames/2, b.buf2.numFrames) }),
);
)

~d.play(time:10);
~b.mixFrom(~d, \in, time:8);

~in2mod.it = 10;
~in2mod = { MouseX.kr(0.001, 1.0,'exponential').poll };
~in2mod = { LFSaw.kr(0.5.neg).range(0.001, 0.005) };

~d.interpolateStretch(2, time: 5, sched: AlgaQuant(4));
~a.interpolateDur(Prand([0.1, 0.5, 0.01], inf).trace, time: 5);


