(Platform.userAppSupportDir +/+ "/boot.scd").load;
Safety.all;

c = TempoClock(1).permanent_(true);
l = LinkClock.newFromTempoClock(c).permanent_(true);
l.tempo = 140/60;
p.clock = l;


b = ();
b[1] = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Syncussion Drums/Kick Drums/Layered/wasc_layeredkick_soft.wav");
b[1];

(
SynthDef(\smp, {
	var snd;
	snd = PlayBuf.ar(1, \sndbuf.kr(0), \rate.kr(1.6), \gate.kr(1.0), \startPos.kr(0.0), 0.0);
	snd = snd * Env.adsr(\atk.kr(0.001), \dec.kr(0.4), \sus.kr(0.0), \rel.kr(0.1), curve: 0.0).kr(2, \gate.kr(1.0));
	snd = snd * \amp.kr(1.0);
	snd = Pan2.ar(snd, 0.0, 1.0);
	Out.ar(0, snd);
}).add;
)

Synth(\smp, [\sndbuf, b[1].bufnum]);

~out1.reset;

(
~out1 = Pbind(
	\instrument, \smp,
	\rate, Pseq([Pn([4], 1), Pn([1.0], 8)], inf),
	\dur, Prand([1.0, 1.0, 1.0, 2.0], inf),
	\sndbuf, b[1],
	\amp, -2.dbamp
);
~out1.quant = 4;
)

~out1.pause;
~out1.resume;
~out1.stop;
~out1.play;

MIDIClient.init;
m = MIDIOut(0);

(

var mOut = MIDIOut(0);

(
~midi1 = Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, mOut,
	\chan, 2,
	\ctlNum, 20,
	\control, Pwhite(0, 127, inf),
	\dur, 1.0
).play(quant: 4);
)
)

(
MIDIClient.init;
m = MIDIOut(0);
b.free; x = Bus.control(s);
)

(
Ndef(\zzz, {
	LFDNoise3.kr(1).range(70, 127) ;
}).setBus(x);
Tdef(\zzzOutputMidi, {loop{m.control(1, 7, x.getSynchronous.round.asInteger.postln); 0.1.wait}}).play;
)



