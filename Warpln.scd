s.boot;

(                                                      // buffers

~snd1 = Buffer.read(s,"/Users/ivainkalashnik/Documents/1510/net and util.wav" , 0, -1, 0);
~snd2 = Buffer.read(s,"/Users/ivainkalashnik/Documents/1510/metalspeaks_live_v.wav");
~snd3 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Wehlt/nupg 145600.wav", 0, -1, 0);
~grainenv = Env([0, 1, 0], [0.001, 1.0], [0, -4]);
~spike = Buffer.sendCollection(s, ~grainenv.discretize, 1);

)


(                                                      // synthdefs

SynthDef(\wsamp, { | bufnum, rate = 0.0, startPos = 0.0, freqScale = 1.0, windowSize = 0.2, envbufnum = -1, overlaps = 1, wRand = 0.0, zSearch = 0.2, zStart = 0.1, atk = 0.001, dec = 0.1, sus = 1.0, rel = 0.1, curve = 0, gate = 1, out = 0, pan = 0.0, amp = 1.0 |
	var pointer, snd, env;
	pointer = LFSaw.ar(BufDur.ir(bufnum).reciprocal(1), 0.0).linlin(0.0, 1.0, startPos, 1.0, clip: \minmax) * rate;
	snd = WarpZ.ar(2, bufnum, pointer, freqScale + MouseY.kr(0.01, 10), windowSize, envbufnum, overlaps, wRand, 4, zSearch, zStart);
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel, curve: curve), gate, doneAction: 2);
	snd = snd * env;
	snd = Limiter.ar(snd);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

)

~wsamp = Synth(\wsamp, [\bufnum, ~snd2, \amp, 0.5]);
~wsamp.set(\amp, 0.3, \bufnum, ~snd2, \freqScale, 1, \windowSize, 1, \overlaps, 5, \rate, 0.7, \zSearch, 0.2, \zStart, 0.1, \wRand, 0, \envbufnum, ~spikenvbuf);


(                                                      // fxs

SynthDef(\combfx, { | in = 12, delayTime = 0.001, decayTime = 0.5, dw = 1.0, pan = 0.0, amp = 0.9, out = 0 |
	var snd, fx, mix;
	snd = In.ar(in, 2);
	fx = CombC.ar(snd, 0.2, delayTime, decayTime);
	mix = LinSelectX.ar(dw, [snd, fx]);
	mix = Limiter.ar(mix);
	Out.ar(out, Pan2.ar(mix, pan, amp));
}).add;

)

(
~comb = Group.new;
~combnode = Synth.tail(~comb, \combfx);
~combnode.nodeID;
)

(                                                      // clock

~clock = TempoClock.new(150/60).permanent_(true);
~clock.tempo = (1);
~clock.beats;

)

(                                                      // pattern

Pbindef(
	\wsamp_pattern,
	\instrument, \wsamp,
	\bufnum, [~snd2, ~snd1, ~snd3],
	\envbufnum, ~spike,
	\windowSize, Pwhite(0.0001, 1.2, inf),
	\rate, Pn(Pseries(0.1, 0.1, 15), inf).trace(prefix: "rate: "),
	\freqScale, Pwhite(0.1, 5.0, inf).trace(prefix: "frequency: "),
	\wRand, Pwrand([0, 0.8], [0.8, 0.2], inf),
	\overlaps, Pwhite(3.0, 7.0, inf),
	\dur, Pwrand([0.1, 0.8, 0.6/3, 0.3], [0.5, 0.1, 0.1, 0.3], inf),
	\legato, Pwhite(0.05, 0.5, inf),
	\dec, 0.05,
	\sus, 0.8,
	\rel, (Pkey(\legato).wrap(0.05, 0.5) * 0.27).trace(prefix: "release: "),
	\curve, 0,
	\amp, [0.5, 0.5, 0.9] / 2,
	\startPos, Pwhite(0.0, 1.0, inf).trace(prefix: "position: "),
	\out, Prand([0, 12], inf)
).quant = 4;

)

(

Pbindef(
	\setcomb,
	\type, \set,
	\id, ~combnode.nodeID,
	\args, [\delayTime, \decayTime],
	\delayTime, Pseq([0.01, 0.006, 0.02], inf),
	\decayTime, Pseq([0.2, 0.2, 0.5], inf),
	\dur, Pwrand([0.1, 0.8, 0.6/3, 0.3], [0.5, 0.1, 0.1, 0.3], inf),
	\amp, 0.1
).quant = 4;

)

Pbindef(\wsamp_pattern).play(~clock);
Pbindef(\setcomb).play(~clock);
Pbindef(\setcomb).isPlaying;
Pbindef(\wsamp_pattern).isPlaying;



// add mod sources: sweep curve, lfos, lfnoise

// v2


(                                                      // buffers

~snd3 = Buffer.read(s,"/Users/ivainkalashnik/Documents/1510/225_live_v.wav" , 0, -1, 0);
~snd4 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Storage/Okuch/Black Octopus Sound - Dub Techno Vol. 1/Drums - Drum Loops/DT1_123_Drum_Loop_090.wav" );
~snd5 = Buffer.read(s, "/Users/ivainkalashnik/Documents/1510/fourflows2_live_v.wav", 0, -1, 0);
~snd6 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Wehlt/1-Audio 0001 [2022-01-12 145226].wav", 0, -1, 0);
~grainenv = Env([0, 1, 0], [0.001, 1.0], [0, -4]);
~spike = Buffer.sendCollection(s, ~grainenv.discretize, 1);

)


(                                                      // synthdefs

SynthDef(\wsamp2, { | bufnum, speed = 0.0, startPos = 0.0, freqScale = 1.0, pSrc = 0, pRate = 1, pMod = 0.0, windowSize = 1.0, envbufnum = -1, overlaps = 1, wRand = 0.0, zSearch = 0.2, zStart = 0.1, out = 0, pan = 0.0, amp = 1.0 |
	var sweep, pointer, snd, chain, env;
	sweep = EnvGen.kr(Env.circle([\slvl.kr(0), \elvl.kr(0)], [\time.kr(0.5)], \swCv.kr('lin')), levelScale: \lvlOt.kr(1.0), timeScale: \tOt.kr(1.0)) * \swAmt.kr(0);
	pointer = startPos + (LFSaw.ar(BufDur.ir(bufnum).reciprocal(1)) * speed);
	snd = WarpZ.ar(2, bufnum, pointer, freqScale + SelectX.kr(pSrc, [LFTri.kr(pRate * overlaps, mul: pMod), LFNoise0.kr(pRate * overlaps, pMod)]), windowSize, envbufnum, overlaps + sweep, wRand, 4, zSearch, zStart);
		env = EnvGen.kr(Env.adsr(\atk.kr(0.001), \dec.kr(0.1), \sus.kr(1.0), \rel.kr(0.1), curve: \curve.kr(0)), \gate.kr(1), doneAction: 2);
	snd = snd * env;
	snd = Limiter.ar(snd);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;

)

(                                                      // fxs

SynthDef(\combfx, { | in = 12, dwRatio = 1.0, rTrig = 0.0, pan = 0.0, amp = 0.9, out = 0 |
	var snd, fx, mix;
	snd = In.ar(in, 2);
	fx = NTube.ar(snd, `[0.95, 0.95, 0.95, 0.95, 0.95, 0.95], `[0.1, -0.1, 0.2, -0.2] + MouseY.kr(-0.7, 0.7), `([0.001,0.002,0.001,0.005,0.005]*TRand.kr(0.001, 0.3, Changed.kr(rTrig))))*0.3;
	mix = LinSelectX.ar(dwRatio, [snd, fx]);
	mix = Limiter.ar(mix);
	Out.ar(out, Pan2.ar(mix, pan, amp));
}).add;

)

(
~comb = Group.new;
~combnode = Synth.tail(~comb, \combfx);
~combnode.nodeID;
)


~wsamp2 = Synth(\wsamp2, [\bufnum, ~snd5, \amp, 0.5, \windowSize, 1]);
~wsamp2.set(\amp, 0.3, \bufnum, ~snd2, \freqScale, 1, \startPos, 1.0.rand, \windowSize, 0.8, \overlaps, 4, \speed, 0.01, \zSearch, 0.2, \zStart, 0.1, \wRand, 0.1, \envbufnum, ~spike, \pMod, 0, \pRate, 0.1, \pSrc, 0.5, \slvl, -20,  \elvl, 10, \time, 5, \swAmt, 0);

(

~pat = Pbindef(
	\pat,
	\instrument, \wsamp2,
	\dur, Plet(\dtrig, Pseq([Pn(Pwhite(0.1, 0.4), 8), Pn(Pwhite(0.1, 0.02), 8)], inf)),
	\legato, Pwhite(0.2, 0.5, inf),
	\wRand, 0.9,
	\overlaps, 8,
	\bufnum, [~snd3, ~snd4, ~snd2, ~snd6],
	\envbufnum, ~spike,
	\windowSize, 1.2,
	\speed, 0.4,
	\amp, [0.3, 0.2, 0.3, 0.4] * 10.dbamp,
	\atk, 0.001,
	\dec, 0.1,
	\sus, 1.0,
	\rel, Pn(Pseries(0.001, 0.025, 16), inf),
	\curve, -6,
	\startPos, 0.7 + Pseries(0.0, 0.01, inf),
	\freqScale, Pn(Pseries(2.5, 0.25, 16), inf),
	\pSrc, 0.0,
	\pMod, 0.0,
	\pRate, 0.1,
	\out, 12
).quant = 4;

~fxpat = Pbindef(
	\fxpat,
	\type, \set,
	\id, ~combnode.nodeID,
	\args, [\dwRatio, \rTrig, \pan, \amp],
	\rTrig, Pwhite(0.0, 1.0, inf),
	\dwRatio, Pn(Pseries(0.0, 0.1, 10), inf),
	\dur, Pget(\dtrig, 0.3, inf),
	\pan, Pwhite(-0.5, 0.5, inf),
	\amp, 0.2 * 10.dbamp
).quant = 4;

~patxfx = Plambda(Ppar(
		[
		~pat,
		~fxpat
	], inf),
).asEventStreamPlayer;

)

~patxfx.play(~clock);

(
{Pan2.ar(Limiter.ar(NTube.ar(Dust.ar(10, mul: 1).unipolar(1), MouseY.kr(0.9,0.999) ! 6, `(Array.rand(3,-1.0,1.0)) * MouseX.kr(0.0001,0.5), `(Array.rand(6,0.0001,0.002)), 0.5), 1.0), 0.0, 0.5)}.play;
)
