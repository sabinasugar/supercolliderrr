(
SynthDef(\testz, {
	arg freq = 440, amp = 0.5, gate = 1, fdecay, combdect = 0.005, combdelt = 0.1;
	var sig, env;
	sig = LFSaw.ar(freq);
	env = EnvGen.ar(Env.adsr(0.01, 0.2, 0.1, 0.7, 1.0, -7), gate, doneAction: Done.freeSelf);
	sig = MoogFF.ar(sig, LinLin.ar(EnvGen.ar(Env.perc(0.01, fdecay, 1.0, -5)), 0.0, 1.0, 300, 12000));
	sig = CombN.ar(sig, 0.1, combdect, combdelt);
	Out.ar(0, Pan2.ar(sig * env, 0.0, amp));
}).add;
)

CombN.ar(sig, 0.1, combdect, combdelt);

x = Synth(\testz, [\freq, 240.rand, \amp, 0.5.rand, \gate, 1, \fdecay, 1.0.rand]);
x.set(\gate, 0);

(
~freqs = List[340, 550, 260];
~vol = List[0.5, 0.5, 1];
{
	inf.do{
	x = Synth(\testz);

		{
		~freqs.do{arg val;
				x.set(\freq, val);
				0.5.wait;
			};
		}.fork;

		{
		~vol.do{arg val;
				x.set(\amp, val);
				0.5.wait;
			};
		}.fork;

	0.5.wait;
	x.set(\gate, 0);
	0.5.wait;
};
}.fork;
)
