(
SynthDef(\AddSynthTestTwo, {
	arg pitch, amp = 0.5, env;
	var n, mix, out;
	n = 15;
	mix = Mix.fill(n, {
		arg indexone;
		var oscgroup, volume;
		oscgroup = Mix.fill(25, {
			arg indextwo;
			var osc;
			osc = SinOsc.ar(40 * (indexone + EnvGen.kr(Env.perc(0.001, 0.8, 3, -10))) * (indexone * EnvGen.kr(Env.perc(0.001, 0.9, 10, -50))), 0.0, 0.5 / (indextwo+1));
			Pan2.ar(osc, Rand(-0.5,0.5));
		});
		volume = oscgroup * 0.5/(indexone+1);
	});
	env = EnvGen.ar(Env.perc(0.001, 3, amp, -1), doneAction: 2);
	mix = CombC.ar(mix, 0.1, MouseX.kr(0.001, 0.1), MouseY.kr(-0.5, 0.5)).tanh;
	Out.ar(0, mix * env);
}).add;
)

Synth(\AddSynthTestTwo);
