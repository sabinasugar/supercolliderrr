s.boot;

(
SynthDef(\event,{ arg freq=140, amp=0.5, pan=0.0;
	var env;

	env = EnvGen.ar(  Env([0,1,1,0],[0.01, 0.1, 0.2]),  doneAction:2);

	Out.ar(0,  Pan2.ar(Blip.ar(freq) * env * amp, pan))
}).add;
)

Synth(\event)