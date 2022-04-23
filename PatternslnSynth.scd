(
SynthDef(\FMSynth, {
	arg freq = 440, moddecay = 0.1, modamt = 0, modfreq = 140, pan = 0.0, amp = 0.5, decay = 0.5;
	var modenv, modulator, carrier, env;
	modenv = EnvGen.ar(Env.perc(0.001, moddecay, 1.0, -15));
	modulator = SinOsc.ar(modfreq, 0.0, modamt);
	carrier = SinOsc.ar(freq + modulator, 0.0, 1.0);
	env = EnvGen.ar(Env.perc(0.001, decay, 1.0, -10), doneAction: 2);
	Out.ar(0, Pan2.ar(carrier * env, pan, amp));
}).add;
)

Synth(\FMSynth, [\freq, 100.rand, \modamt, 1000.rand, \modfreq, 2000.rand, \moddecay, 0.5.rand]);

(
Pdef(\x,
	Pbind(
		\instrument, \FMSynth,
		\freq, Pseq([100, 200, 400.rand, 1000], inf),
		\modfreq, Pseq([
			Prand([100, 2000, 300, 400], 4),
			250, 200, 250],
		inf),
		\modamt, Pseq([
			Pser([200, 2000] ++ (700 ! 10), 4),
			Pser([100, 200], 1)],
		inf),
		\dur,  Pseq([
			Pseries({ rrand(0.2, 0.1) }, 0.01, 8),
			Pseries({ rrand(0.2, 0.1) }, -0.01, 8)],
		inf),
		\moddecay, Pseq(Array.fill(16, {arg i;
			i + 0.1}), inf),
		\decay, Pseq([Pseries(1.5, -0.01, 16)], inf),
		\pan, Prand([-0.7, -0.5, -0.3, 0.0, 0.3, 0.5, 07], inf)
);
).clock;
)

Pdef(\x).play;
Pdef(\x).resume;
Pdef(\x).reset;
Pdef(\x).pause;


TempoClock.default

[200, 2000] ++ (300 ! 10)

Pbind(\freq, Prand([300, 500, 231.2, 399.2], inf), \dur, Prand([0.1, 0.3], inf)).play;