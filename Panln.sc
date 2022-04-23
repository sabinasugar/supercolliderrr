(SynthDef(\NoiseClap, {
	var master;
	var prandpan;
	var env;
	master = Decay2.ar(Impulse.ar(1), 0.01, 0.3, PinkNoise.ar);
	prandpan = Prand(#[-1.0, -0.75, -0.5, -0.25, 0, 0.25, 0.50, 0.75, 1.0],inf).asStream;
	env = Line.ar(1.0, 0, 1, doneAction: Done.freeSelf);
	Balance2.ar(Out.ar(0, master), Out.ar(1, master), pos: prandpan, level: env);
}).add;)

a = Synth(\NoiseClap);
