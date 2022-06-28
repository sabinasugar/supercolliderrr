Bo.ot;


r = r {
	loop {
		rrand(0.1, 2.0).postln;
		1.0.wait;
		rrand(100, 200).postln;
		"hahahaha".postln;
		0.5.wait;
		Synth(\test);
		0.1.wait;
		Synth(\test);
	}
};


(
r = Task {
	loop {
		rrand(0.1, 2.0).postln;
		1.0.wait;
		rrand(100, 200).postln;
		"hahahaha".postln;
		0.5.wait;
		Synth(\test);
		0.1.wait;
		Synth(\test);
	}
};
)

r.play;
r.pause;
r.stop;
r.resume;
r.reset;

Plazy({ [Pseq((1..8), 1), Prand((1..8), 1)].wchoose([0.1, 0.9])});

(
SynthDef(\sy, {
	var snd;
	snd = SinOscFB.ar(\freq.kr(440) + Line.kr(10.0, -10.0, 2), \fb.kr(0.0))!2;
	snd = snd * Env.perc(1.0, 1.0, 1.0, 0).kr(2, \gate.kr(1));
	snd = snd * \amp.kr(0.6);
	Out.ar(\out.kr(0), snd);
}).add;
)

o = ();
o.pseq1 = Pseq([0.1, 0.2, 0.2, 0.2], 1);

Scale.directory;

(
~out = Pbind(
	\instrument, \sy,
	\dur, Pn(Plazy({ [o.pseq1, Prand((1..8).reciprocal, 1)].wchoose([0.2, 0.8])}).trace, inf),
	\note, PdegreeToKey(Pwhite(1, 15, inf), Scale.partch_o1, 12).trace(prefix: "note: "),
	\root, (1..64).takeThese({ | item | 0.5.coin}) + Pwhite(-10, 10, inf),
	\amp, 0.02,
	\fb, Pwhite(0.0, 0.9, inf)
);
)

~out.quant = 4;
~out.play;

w = SpectrogramWindow.new
w.start;

[1, 2, 3].removeAt(1);