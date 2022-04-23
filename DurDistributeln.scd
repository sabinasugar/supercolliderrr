

(                                                      // buffers

~perc1 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Syncussion Drums/Percussion/wasc_perc_moonshine.wav");
~perc2 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Syncussion Drums/SP-12 Perc/wasc_sp12_perc_trip.wav");
~perc3 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Syncussion Drums/SP-12 Perc/wasc_sp12_perc_grained.wav");
~perc4 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Syncussion Drums/Kick Drums/dry/wasc_drykick_looser.wav");
~perc5 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Syncussion Drums/Kick Drums/dry/wasc_drykick_bounce.wav");
~perc6 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Syncussion Drums/Kick Drums/dry/wasc_drykick_lispsub.wav" );
~nupg1 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Wehlt/1-Audio 1 [2021-12-23 133045].wav");
~nupg2 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Wehlt/2-Audio 0003 [2021-12-12 134605].wav");

)


(                                                      // synthdefs

SynthDef(\msamp, { | bufnum, freq, trig = 1, startPos = 0, loop = 0, atk = 0.001, sus = 1, rel = 0.01, gate = 1, fpass = 0, ffreq = 3000, fbandw = 1.0, amp = 0.5 |
	var scaledRate, player, env, filter, sig;
	scaledRate = BufRateScale.kr(bufnum) * freq;
	player = PlayBuf.ar(1, bufnum, scaledRate, trig, startPos, loop);
	filter = BBandPass.ar(player, ffreq.clip(10, 20000), fbandw);
	sig = Select.ar(fpass, [player, filter]);
	env = EnvGen.ar(Env.asr(atk, sus, rel, -2), gate, doneAction: 2);
	Out.ar(0, Pan2.ar((sig * env).tanh, 0.0, amp));
}).add;

SynthDef(\ssamp, { | bufnum, freq, trig = 1, startPos = 0, loop = 0, atk = 0.001, sus = 1, rel = 0.01, gate = 1, fpass = 0, ffreq = 3000, fbandw = 1.0, amp = 0.5 |
	var scaledRate, player, env, filter, sig;
	scaledRate = BufRateScale.kr(bufnum) * freq;
	player = PlayBuf.ar(2, bufnum, scaledRate, trig, startPos, loop);
	filter = BBandPass.ar(player, ffreq.clip(10, 20000), fbandw);
	sig = Select.ar(fpass, [player, filter]);
	env = EnvGen.ar(Env.asr(atk, sus, rel, -4), gate, doneAction: 2);
	Out.ar(0, Pan2.ar((sig * env).tanh, 0.0, amp));
}).add;

)

(                                                      // clock

(
~clock = TempoClock(150/60);
~clock.permanent_(true);
);
~clock.tempo_(140/60);
)


(                                                      // percpat1

Pbindef(\percpat1,
	\instrument, \msamp,
	\bufnum, Pseq([~perc1, ~perc2, ~perc1], inf),
	\legato, Pseq((0.05, 0.10..1.0).clipExtend(16), inf),
	\dur, Prand([
		Pseq([
			4/32
		], 1),
		/* Pseq([
			4/16
		], 1),
		Pseq([
			4/(32/3)
		], 1), */
	], inf),
	\rel, Prand([
		Pseq([
			0.1, 0.2
	], 2),
		Pseq([
			0.1, 0.4
	], 2),
		Pseq([
			0.5, 0.2
	], 2),
	], inf),
	\freq, Prand([
	Pseq([
		1, \, \, \, \, \, 1, \,
		\, \, \, \, 1, \, \, \,
		\, \, 1, \, \, \, \, \,
		1, \, \, \, \, \, \, \,
	], 1),
		Pseq([
		1, \, 1, \, 1, \, 1, \,
		1, \, \, \, \, \, 1, \,
		1, \, 1, \, 1, \, 1, \,
		1, \, \, \, \, \, 1, \,
	], 1) + 0.5,
		Pseq([
		\, \, \, \, \, \, \, \,
		1, \, 1, \, 2, \, 1, \,
		\, \, \, \, \, \, \, \,
		1, \, 1, \, 2, \, 1, \,
	], 1),
		Pseq([
		1, \, \, \, \, \, 1, \,
		\, \, \, \, 1, \, \, \,
		\, \, 2, \, \, \, \, \,
		2, \, \, \, \, \, \, \,
	], 1),
		Pseq([
		1, \, 1, \, 2, \, 1, \,
		\, \, \, \, \, \, \, \,
		1, \, 1, \, 2, \, 1, \,
		\, \, \, \, \, \, \, \,
	], 1),
		Pseq([
		1, \, \, \, \, \, 2, \,
		\, \, \, \, 3, \, \, \,
		\, \, 1, \, \, \, \, \,
		2, \, \, \, \, \, 3, \,
	], 1),
		Pseq([
		\, \, \, \, \, \, \, \,
	], 4),
		Pseq([
		\, \, \, \, \, \, \, \,
	], 2)
	], inf),
	\amp, 0.2 * -15.dbamp
).play(~clock, quant: 8);

)

(                                                      // percpat2

Pbindef(\percpat2,
	\instrument, \msamp,
	\bufnum, Pseq([~perc4, ~perc5, ~perc6], inf),
	\dur, Prand([
		Pseq([
			4/32
		], 1),
		/* Pseq([
			4/16
		], 1),
		Pseq([
			4/(32/3)
		], 1), */
	], inf),
	\rel, Prand([
		Pseq([
			0.2, 0.7
	], 2),
		Pseq([
			0.2, 0.7
	], 2),
		Pseq([
			0.5, 0.7
	], 2),
	], inf),
	\freq, Prand([
		Pseq([
		2, \, \, \, \, \, 1, \,
		\, \, \, \, 2, \, \, \,
		\, \, \, \, \, \, \, \,
	], 1),
		Pseq([
		1, \, \, \, \, \, 1, \,
		\, \, \, \, 1, \, \, \,
		1, \, \, \, \, \, 1, \,
		\, \, \, \, 2, \, \, \,
	], 1),
		Pseq([
		1, \, 1, \, 1, \, 1, \,
		\, \, \, \, \, \, \, \,
		1, \, \, \, \, \, 1, \,
		\, \, \, \, 2, \, \, \,
	], 1),
		Pseq([
		1, \, 1, \, 2, \, 0.8, \,
		\, \, \, \, \, \, \, \,
		1, \, \, \, \, \, 1, \,
	], 1),
		Pseq([
		1, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		\, \, \, \, \, 2, \, \,
		\, \, \, \, \, \, \, \,
	], 2),
	], inf),
	\amp, 0.4
).play(~clock, quant: 8);

)

(                                                      // nu1pgpat1

Pbindef(\nupgpat1,
	\instrument, \ssamp,
	\bufnum, Pseq([~nupg1, ~nupg2], inf),
	\dur, Prand([
		Pseq([
			4/32
		], 1)
	], inf),
	\legato, Pseq((0.05, 0.10..1.0).clipExtend(16), inf),
	\sus, 0.5,
	\rel, Prand([
		Pseq([
			0.1, 0.3
	], 2),
		Pseq([
			0.1, 0.3
	], 2),
		Pseq([
			0.2, 0.3
	], 2),
	], inf),
	\freq, Prand([
		Pseq([
		1, \, \, \, \, \, 1, \,
		\, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
	], 1),
		Pseq([
		1, \, \, \, \, \, \, \,
		2, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		4, \, 3, \, 2, \, 1, \,
	], 1),
		Pseq([
		1, \, 1, \, 1, \, 1, \,
		\, \, \, \, \, \, \, \,
		1, \, \, \, \, \, 1, \,
		\, \, \, \, \, \, 2, \,
	], 1),
		Pseq([
		1, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		1, \, \, \, \, \, 2, \,
		\, \, \, \, \, \, \, \,
	], 1),
	], inf),
	\startPos, Pwhite(0.0, ~nupg.numFrames),
	\amp, 1 * -25.dbamp
).play(~clock, quant: 8);

)

(                                                      // nupgpat2

Pbindef(\nupgpat2,
	\instrument, \ssamp,
	\bufnum, Pseq([~nupg2], inf),
	\dur, Prand([
		Pseq([
			4/64
		], 16),
		Pseq([
			4/32
		], 16),
		Pseq([
			2
		], 8)
	], inf),
	\legato, 0.5,
	\sus, 1,
	\rel, 0.1,
	\freq, Prand([
		Pseq([
		1, \, \, \, \, \, 1, \,
		\, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		].stutter(4).clipExtend(16).rotate(-8), 1),
		Pseq([
		1, \, \, \, \, \, \, \,
		1, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		1, \, 1, \, 1, \, 1, \,
	].stutter(2).clipExtend(16), 1),
		Pseq([
		1, \, 1, \, 1, \, 1, \,
		\, \, \, \, \, \, \, \,
		1, \, 1, \, 1, \, 1, \,
		\, \, \, \, \, \, 1, \,
	].stutter(2).clipExtend(16), 1),
		Pseq([
		1, \, \, \, \, \, \, \,
		\, \, \, \, \, \, \, \,
		1, \, \, \, \, \, 1, \,
		\, \, \, \, \, \, \, \,
	].stutter(2).clipExtend(16), 1),
	], inf),
	\startPos, Pwhite(0, ~nupg.numFrames),
	\amp, 1 * -20.dbamp
).play(~clock, quant: 8);

)







