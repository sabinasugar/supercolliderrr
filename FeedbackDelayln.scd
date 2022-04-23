(
SynthDef(\SimpleDelay, { | dt, fb = 0.0, pitchRatio = 1.0 |
	var trig, input, delayline, feedback, delaymix;
	trig = Impulse.ar(MouseX.kr(1,5));
	input = LFSaw.ar(40) * EnvGen.ar(Env.perc(0.001, 0.2, 0.9, -6), trig);
	feedback = LocalIn.ar(1) + input;
	delayline = DelayC.ar(PitchShift.ar(feedback, MouseY.kr(0.0001,0.5), pitchRatio), 1.0, MouseY.kr(0.0001,0.5));
	feedback = LocalOut.ar(delayline * fb);
	delaymix = Limiter.ar(delayline);
	Out.ar(0, Pan2.ar(delaymix, 0.0, 1.0));
}).add
)

~sd = Synth(\SimpleDelay, [\dt, 0.005, \fb, 0.99]);
~sd.set(\pitchRatio, 0.999, \fb, 0.99);