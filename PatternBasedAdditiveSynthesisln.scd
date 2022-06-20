(Platform.userAppSupportDir +/+ "/boot.scd").load;

(
b = ();
b.osenv = Buffer.sendCollection(s, Env.perc(0.8, 0.8, 1.0, 0.0).discretize, 1);
SynthDef(\sin, {
	var snd;
	snd = Blip.ar(\freq.kr(440), \numharm.kr(1));
	snd = snd * Osc1.ar(b.osenv, \envDur.kr(1.0)); // Env.perc(0.6, 0.6, 1.0, 0.0).kr(2, \gate.kr(1.0));
	snd = Pan2.ar(snd, \pan.kr(0.0), \amp.kr(0.2));
	Out.ar(\out.kr(0), snd);
}).add;
)


(
k = Bus.control(s, 1);
c = SynthDef(\lfo, {
  Out.kr(k, LFNoise1.kr(1).range(0.0, 35.0));
}).play;

Tdef(\updateDur, {
  inf.do({
    k.get({|v|
      v.postln;
      Pdefn(\lfn, v);
    });
    0.1.wait;
  })
}).play;
)




Tdef(\updateDur).stop;

~lfn = {LFNoise1.kr(LFNoise1.kr(5).range(0.2, 7.0)).range(0.0, 7.0)};



(
~out[0] = Pbind(
	\instrument, \sin,
	\dur, 0.02,
	\envDur, Pwhite(0.1, 1.5, inf),
	\midinote, Prand([
		Plprand(10.0, 90.0, 32),
		Phprand(10.0, 90.0, 8)], inf) + Pdefn(\lfn),
	\numharm, ~lfn,
	\pan, Pwhite(-1.0, 1.0, inf),
	\amp, 0.08

);
)

(
~out[1] = \filter -> { | in |
	var snd;
	// trig = Impulse.kr(LFNoise1.kr(3).range(0.1, 7));
	// snd = SelectX.ar(LFNoise1.kr(1).unipolar(1), [in, in * Env.perc(0.001, 0.2, 1.2, -2.0).kr(0, trig)]);
	snd = SelectX.ar(0.5, [in, JPverb.ar(in,
		t60: 1,
		damp: 0.5,
		size: 1.0,
		earlyDiff: 0.707,
		modDepth: 0.1,
		modFreq: 2.0,
		low: 1.0,
		mid: 1.0,
		high: 1.0,
		lowcut: 500.0,
		highcut: 8000.0)]);
	snd = snd * -2.dbamp;
};
~out.set(\wet1, 1.0);
)

~out.play;
~out.stop;
~out.pause;
~out.clear;

