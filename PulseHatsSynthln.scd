(
s.boot;
MIDIClient.init;
MIDIIn.connectAll;
)

(
SynthDef(\HH, {
	arg hold, amp = 1.0, freqshift, attack, release;
	var ad, ahd, pulses, impact, body, mix;
	ahd = EnvGen.ar(Env.asr(0.004, amp, 0.1, -10), hold, doneAction: Done.freeSelf);
	ad = EnvGen.ar(Env.perc(0.015, 0.2, 1.0, -40));
	pulses = HPF.ar(FreqShift.ar(
		Mix.fill(6, {Pulse.ar(rrand(600, 850).postln, 0.5, 0.25)}), // 6 pulse oscs
		freqshift + 1000), // freq shift (arg)
	4000); // hpf cut-off freq
	impact = BBandPass.ar(pulses + WhiteNoise.ar(0.2), LinLin.kr(ad, 0.0, 2.0, 2000, 15000)) * ad * 0.2;
	body = HPF.ar(pulses, LinLin.kr(ahd, 0.0, 1.0, 6000, 9000)) * ahd;
	mix = Mix([body, impact]) * 2;
	Out.ar(0, Pan2.ar(mix, 0.0, ahd));
}).add;
)

a = Synth(\HH, [\hold, 1]);
a.set(\hold, 0);

// 822, 744, 786, 695, 625, 850 + live's ring mod 2.29 khz

(
~notes = Array.newClear(128);

MIDIdef.noteOn(\NoteOns, {
	arg vel, nn;
	[vel, nn];
	~notes[nn] = Synth(\HH, [\amp, vel.linexp(1, 127, 0.01, 0.7),\hold, 1]);
});
MIDIdef.noteOff(\NoteOffs, {
	arg vel, nn;
	~notes[nn].set(\hold, 0);
});
)

MIDIdef(\NoteOffs).permanent_(false); // true to stay while cmd + enter

