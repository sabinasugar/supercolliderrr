s.boot

(
SynthDef(\ssaw, { | freq = 440, gate = 1, atk = 0.001, dec = 0.5, sus = 0.3, rel = 0.1, frel = 0.2, ffreq = 80, fres = 0.1, amp = 0.5, bus = 0 |
	var n, sig, fenv, fsig, env;
	n = 12;
	sig = Mix.fill(n, { | i |
		var sig;
		sig = Saw.ar(freq + 1.rand2);
		Pan2.ar(sig, 1.0.rand2, 1 / n);
	});
	fenv = LinLin.kr(EnvGen.kr(Env.perc(5, frel, 1.0, 0)), 0.0, 1.0, ffreq, 18000.0).clip(40, 18000);
	fsig = MoogVCF.ar(sig, fenv, fres);
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel, curve: -5), gate, doneAction: 2);
	Out.ar(bus, Pan2.ar(fsig, 0.0, amp));
}).add;
)

Synth(\ssaw);

(
Pbindef(
	\ssawp,
	\instrument, \ssaw,
	\freq, Prand([
		Pseq([[139, 408, 498]], 1),
		Pseq([[702, 408, 498]], 1),
		Pseq([139,408], 2),
		Pseq([1107], 1)
], inf),
	\dur, 0.9,
	\ffreq, Pseq([800, 100, 800], inf),
	\frel, Pseq([2, 3, 3, 4], inf),
	\fres, 0.1,
	\dec, Pseq((0.1,0.2..0.8), inf),
	\rel, Prand([
	Pseq([6], 4),
	Pseq([7], 4)
	], inf)
).quant;
)

Pbindef(\ssawp).play;

(
Pbindef(\ssawp, \dur, Prand([
	Pseq([0.2/2], 2),
	Pseq([0.2], 6),
], inf)).quant
)

(
Pbindef(\ssawp, \legato, Prand([
	Pseq([3], 4),
	Pseq([6], 4)
], inf)).quant
)

(
Pbindef(\ssawp, \atk, Prand([
	Pseq([3], 4),
	Pseq([3], 4)
], inf)).quant
)

(
Pbindef(\ssawp,
	\freq, Prand([
	Pseq([386], 1),
	Pseq([300], 2),
	Pseq([140], 2),
	Pseq([100], 1)
], inf)).quant
)


	