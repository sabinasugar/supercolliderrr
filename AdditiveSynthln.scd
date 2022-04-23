s.boot

(
SynthDef(\AddSynthTest, {
	arg pitch, amp = 0.5;
	var nblip, nsin, nsq, lagsaw, fillblipup, fillblipdown, fillsinup, fillsindown, lohifade;

	nblip = 4; // number of blip instances
	nsin = 24; // number of sin instances
	nsq = 4; // number of square instances

	lagsaw = (Lag.kr(LFSaw.kr(MouseY.kr(0.5, 20)), 0.005)+1)/2;

	fillblipup = Mix.fill(nblip, {
		arg index;
		var osc;
		osc = Blip.ar(
			MouseY.kr(2, 150) + ((index)*MouseX.kr(100, 1000)) + (lagsaw*MouseY.kr(0, -50)), // freq
			MouseX.kr(1, 10), // harm
			(0.5/nsin)*(index+1)) * -10.dbamp;
		Pan2.ar(osc, Rand(-0.5,0.5));
	});

	fillblipup = BLowPass4.ar(fillblipup, (lagsaw + 40) * 400, 0.05);

	fillblipdown = Mix.fill(nblip, {
		arg index;
		var osc;
		osc = Blip.ar(
			MouseY.kr(2, 150) + ((index)*MouseX.kr(100, 1000)) + (lagsaw*MouseY.kr(0, -50)), // freq
			MouseX.kr(1, 10), // harm
			0.5/(index+1)) * -5.dbamp; // amp
		Pan2.ar(osc, Rand(-0.5,0.5));
	});

	fillblipdown = BLowPass4.ar(fillblipdown, (lagsaw + 40) * 400, 0.05);

	fillsinup = Mix.fill(nsin, {
		arg index;
		var osc;
		osc = SinOsc.ar(
			MouseY.kr(2, 150) + ((index)*MouseX.kr(100, 1000)) + (lagsaw*MouseY.kr(0, -50)), // freq
			0.0, // phase
			(0.5/nsin)*(index+1)) * -14.dbamp; // amp
		Pan2.ar(osc, Rand(-0.5,0.5));
	});

	fillsindown = Mix.fill(nsq, {
		arg index;
		var osc;
		osc = Pulse.ar(
			MouseY.kr(2, 150) + ((index)*MouseX.kr(100, 1000)) + (lagsaw*MouseY.kr(0, -50)), // freq
			0.5, // width
			0.5/(index+1)) * -10.dbamp; // amp
		Pan2.ar(osc, Rand(-0.5,0.5));
	});

	lohifade = SelectX.ar(lagsaw, [fillsinup + fillblipup, fillsindown + fillblipdown]); // lo-hi instances filter

	Out.ar(0, lohifade * amp);
}).add;
)

Synth(\AddSynthTest);


0.5/(index+1) / 2 // partials go down
(0.5/nsin)*(index+1) / 2 // partials go up


(
SynthDef(\test, {
var mix, env;
mix = Mix.fill(200, {
	arg index;
		SinOsc.ar(((index+1)*MouseY.kr(5, 500)) + Rand(0.2, 50), 0.0, EnvGen.ar(Env.perc(0.0001, (5.0/(index+1)).postln, 0.5/(index+1), -5)));
});
	env = EnvGen.ar(Env.perc(0.0001, 5.0, 1.0, -5), doneAction: 2);
	Out.ar(0, Pan2.ar(mix * env, 0.0, 0.5));
}).add;
)

Synth(\test);



