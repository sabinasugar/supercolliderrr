(
~snd1 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Wehlt/1-Audio 0001 [2021-11-05 000118].wav", 0, -1, 0);
~snd2 = Buffer.read(s,"/Users/ivainkalashnik/Documents/1510/metalspeaks_live_v.wav", 0, -1, 0);
~snd3 = Buffer.read(s,"/Users/ivainkalashnik/Documents/Wehlt/ts 130750.wav" , 0, -1, 0);
)


(
SynthDef(\wlap, { | bufnum, start = 0, stretch = 1, wsize = 4, step = 1, wwsize = 0.1, wwlaps = 4, harm = 7, wwran = 0.1, atk = 0.001, dec = 0.1, sus = 1.0, rel = 0.1, curve = 0, gate = 1, out = 0, pan = 0.0, amp = 0.5 |
	var overlaps, snd, env;
	overlaps = 4;
	snd = WarpOverlap.ar(2, bufnum, overlaps, start, stretch, harm, wsize, step, wwsize, wwlaps, wwran);
	snd = Limiter.ar(snd);
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel, curve: curve), gate, doneAction: 2);
	snd = snd * env;
	snd = Limiter.ar(snd);
	Out.ar(out, Pan2.ar(snd, pan, amp));
}).add;
)

~wlap = Synth(\wlap, [\bufnum, ~snd3, \stretch, 6, \wwsize, 0.3, \wwlaps, 4, \step, 1]);
~wlap.set(\bufnum, ~snd3, \stretch, 4, \wwlaps, 2, \step, 1, \wsize, 6, \wwran, 2, \wwsize, 0.8, \amp, 0.5, \harm, [3, 7, 48].midiratio.asRef);

harm = [3, 7, 5, -12].midiratio.asRef;


3.midiratio