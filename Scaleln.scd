Bo.ot;

(
SynthDef(\sin, { | freq = 440, gate = 1.0, amp = 0.2 |
	var snd;
	snd = SinOscFB.ar(freq, \fb.kr(0.1))!2 * Env.perc(2.0, 3.5, 0.3).kr(2, gate);
	snd = snd * amp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Tuning.directory;
t = Tuning.werckmeister;

~px.clear;
~px.fadeTime = 5;

Scale.directory;

(
~px[0] = Pbind(
	\instrument, \sin,
	\dur, 0.5,
	\scale, Scale.sikahDesc,
	\degree, Pwhite([1, -4, 4, 12], [4, 2, 12, 24], inf) - Prand([Pn(12, 128), Pn(6, 128)], inf),
	\amp, [0.1, 0.05, 0.03, 0.01] + 0.05,
	\fb, Pseq([Pseries(0.0, 0.05, 24), Pseries(1.2, -0.05, 24)], inf)
);
)

~px.play;

(
~px[1] = \filter -> { | in |
	var snd;
	snd = HPF.ar(in, 320.clip(20, 20000));
	snd = AdCVerb2.ar(snd * 0.2, 1, SinOsc.kr(0.1).unipolar(0.7), 0.9, numCombs: 32);
};
)

~px.set(\wet1, 0.7);