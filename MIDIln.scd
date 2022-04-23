(
s.boot;
MIDIClient.init;
MIDIIn.connectAll;
)


MIDIFunc.defaultDispatchers

// MIDIdef.noteOn().permanent_(true); this means the cmd+enter will not remove this mididef

(
MIDIdef.noteOn(\NoteOns, {
	arg vel, nn;
	[vel, nn].postln;
	Synth.new(\Tone, [\freq, nn.midicps, \amp, vel.linexp(1,127,0.01,0.3)]);
});
)

(
SynthDef.new(\Tone, {
	arg freq = 440, amp = 0.3;
	var sig, env;
	sig = VarSaw.ar(freq * (SinOsc.ar(SinOsc.kr(1,0,Rand(0,10)),0,0.01))+500, 0, Rand(0.01, 1));
	env = EnvGen.kr(Env.perc(Rand(0.01,0.7), Rand(0.1,10.0), curve: -15), doneAction: 2);
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(sig, 0.0));
}).add;
)
