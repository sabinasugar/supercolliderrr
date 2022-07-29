Bo.ot;

(
m = ();
m.set1 = ();
m.set1.state = ();
m.set1.state[1] = Pseq([1, \, \, \], 2);
m.set1.state[2] = Pseq([1, 1, 1, 1], 1);
m.set1.state[3] = Pseq([1, \, \, 1, \, \, 1, \], 1);
m.set1.state[4] = Pseq([1, \, \, 1, \, \, 1, \], 1);

m.mset = MarkovSet([
	[m.set1.state[1], [m.set1.state[1], m.set1.state[2]], nil],
	[m.set1.state[2], [m.set1.state[1], m.set1.state[3]], [0.2, 0.8]],
	[m.set1.state[3], [m.set1.state[3], m.set1.state[4], m.set1.state[1]], nil]
], true);
m.mset.makeSeeds;
x = m.mset.asStream;
)

(
b = ();
b.buf = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Black Octopus Sound - Dub Techno Vol. 1/Drums - Kicks/Dt1_D#_Kick_19.wav");
b.buf2 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Black Octopus Sound - Dub Techno Vol. 1/Drums - Claps/DT1_Clap_08.wav");
b.buf3 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Access Virus B/Hat06.wav");
b.buf4 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Black Octopus Sound - Dub Techno Vol. 1/Bass - Loops/DT1_123_G#m7_Bass_Loop_27.wav");
b.buf5 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Splice/064bpm_F_Candy_pad.wav");

)

b.buf.play;

(
~k = Pbind(
	\instrument, \splayer,
	\dur, Prand([
		Pn(0.4, 16),
		Pn(0.2, 16)], inf),
	\sndbuf, b.buf,
	\rate, x,
	\amp, 0.5
);

~c = Pbind(
	\instrument, \splayer,
	\dur, 0.2,
	\sndbuf, b.buf2,
	\rate, x,
	\amp, 0.5
);

~h = Pbind(
	\instrument, \splayer,
	\dur, 0.4,
	\legato, 0.02,
	\rel, 0.22,
	\sndbuf, b.buf3,
	\rate, x,
	\amp, 0.2
);

~b = Pbind(
	\instrument, \splayer,
	\dur, 0.4,
	\sndbuf, b.buf4,
	\rel, 0.5,
	\rate, x,
	\amp, 0.5
);

~pad = Pbind(
	\instrument, \splayer,
	\dur, Prand([0.2, 0.1], inf),
	\legato, 2,
	\sndbuf, b.buf5,
	\start, Pwhite(0.0, 1.0, inf),
	\atk, 2,
	\rel, 3,
	\curve, -5,
	\rate, x + 0.0,
	\amp, 0.7
);

)


~k.play;
~c.play;
~h.play;
~b.play;
~pad.play;
~pad.stop;
x.nextN(100);


(
b = ();
b.buf = ();
b.buf.path = "/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Jomox Xbase09";
PathName(b.buf.path).entries.collect({
	arg n,i;
	b.buf[i] = Buffer.read(s, n.fullPath);
});

b.bass = ();
b.bass.path = "/Library/Audio/Presets/Xfer Records/Serum Presets/Tables/Animoog5";
PathName(b.bass.path).entries.collect({
	arg n,i;
	b.bass[i] = Buffer.read(s, n.fullPath);
});

)

b.buf[3].play;

(
SynthDef(\mplayer, {
	var buffer, sndbuf, rate, snd;
	buffer = \sndbuf.kr(0);
	rate = BufRateScale.ir(buffer) * \rate.kr(1.0, 0.05);
	snd = PlayBuf.ar(1, buffer, rate, \trig.kr(1), \start.kr(0.0), \loop.kr(0));
	snd = snd * Env.adsr(\atk.kr(0.001), \dec.kr(0.1), \sus.kr(1.0), \rel.kr(0.1), curve: -4.0).kr(2, \gate.kr(1.0));
	snd = snd * \amp.kr(1.0, 0.05);
	snd = Pan2.ar(snd, \pan.kr(0.0, 0.05));
	Out.ar(\out.kr(0), snd);
}, metadata: (
	specs: (
		rate: [0.0, 2.0, \lin, 0.05].asSpec,
		pan: [-1.0, 1.0, \lin, 0.05].asSpec
	)
)).add;
)

(
SynthDef(\splayer, {
	var buffer, sndbuf, rate, snd;
	buffer = \sndbuf.kr(0);
	rate = BufRateScale.ir(buffer) * \rate.kr(1.0, 0.05);
	snd = PlayBuf.ar(2, buffer, rate, \trig.kr(1), \start.kr(0.0), \loop.kr(0));
	snd = snd * Env.adsr(\atk.kr(0.001), \dec.kr(0.1), \sus.kr(1.0), \rel.kr(0.1), curve: -4.0).kr(2, \gate.kr(1.0));
	snd = snd * \amp.kr(1.0, 0.05);
	snd = Pan2.ar(snd, \pan.kr(0.0, 0.05));
	Out.ar(\out.kr(0), snd);
}, metadata: (
	specs: (
		rate: [0.0, 2.0, \lin, 0.05].asSpec,
		pan: [-1.0, 1.0, \lin, 0.05].asSpec
	)
)).add;
)

SynthDescLib.global[\mplayer].makeGui
\mplayer.sVarGui.gui


(
~splay[0] = Pbind(
		\instrument, \mplayer,
		\dur, Pdup(2, Pwrand([0.1, 0.3, 0.6], [0.7, 0.25, 0.05], inf)),
		\sndbuf, Pdup(Prand([1, 2, 4], inf), Pfunc({ b.buf.choose })),
		\rate, Pwrand([1.0, 3.0, 2.0, \r], [0.15, 0.15, 0.5, 0.2], inf);
).collect({ |event|
    x = event;
});

~splay[1] = \filter -> { | in |
	var snd;
	snd = in + (CombN.ar(in, 0.2, \dtime.kr(0.02), \dectime.kr(0.2))*\combwet.kr(1.0));
	snd = DFM1.ar(snd, Env.perc(0.001, 0.1, 1.0, -5.0).kr(0, \gate.kr(1.0)).range(100, 8000).clip(0, 20000), 0.2, 2);
};
~splay.set(\wet1, 1.0);
~splay[2] = \set -> Pbind(
	\dectime, Pwhite(0.05, 0.3),
	\dtime, Pwhite(0.001, 0.05, inf),
	\dur, Pfunc({ x[\dur]}),
	\combwet, Pdup(2, Pwrand([0.0, 1.0], [0.8, 0.2], inf))
);

~bass = Pbind(
	\instrument, \mplayer,
	\dur, Pfunc({ x[\dur]}).trace,
	\sndbuf, Pdup(Prand([2, 4], inf), Pfunc({ b.bass.choose }))
);

~splay.play;
~bass.play;
)

