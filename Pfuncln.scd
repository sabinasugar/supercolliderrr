s.boot;
s.quit;

(Platform.userAppSupportDir +/+ "/boot.scd").load;

(
Buffer.freeAll;
b.clear;
b = ();
b.buf = ();
b.buf.path = ;
PathName(b.buf.path).entries.collect({
	arg n,i;
	n.extension.postln;
	b.buf[i] = Buffer.read(s, n.fullPath);
});
)

b.buf[6].play;

currentEnvironment;
p.reshaping = \elastic;
p.quant = 4;
p.fadeTime = 1;


(
SynthDef(\player, {
	var snd;
	snd = PlayBuf.ar(2, \sndbuf.kr(0), \rate.kr(1.0) * BufRateScale.ir(\sndbuf.kr(0)) + LFNoise0.kr(1).range(0.3, 2.0), 1.0, \spos.kr(0.0), 0.0, 0);
	snd = snd * Env.perc(0.001, 1.3, 1.0, -5.0).kr(2, \gate.kr(1.0));
	snd = snd * \amp.kr(-15.dbamp);
	/*snd = FFT({LocalBuf(2.pow(11))}.dup, snd);
	snd = PV_MagSmooth(snd, LFNoise1.kr(2).unipolar(1.0));
	snd = PV_Diffuser(snd, LFNoise1.kr(50));
	snd = PV_Freeze(snd, LFNoise1.kr(50));
	snd = IFFT(snd);*/
	snd = Limiter.ar(snd);
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\player, [\sndbuf, 2]);

(

~out.source = Pbind(
	\instrument, \player,
	\dur, Prand([
		Pseq(0.2!4, 1),
		Pseq(0.1!2, 1),
		Pseq([0.4/3], 1),
		Pseq(0.2!8, 1)
	], inf) * Pwrand([
		Pseq(1!4, 1),
		Pseq(0.5!4, 1)], [0.2, 0.8], inf) * Pdup(Prand([2, 4, 8, 16], inf), Prand([0.5, 0.1, 1.5, 2.0], inf)),
	\sndbuf, Pwrand([Pfunc({b.buf.choose}), Pdup(Prand([2, 4], inf), Pfunc({b.buf.choose}))], [0.7, 0.3], inf).trace,
	\spos, 0.0,
	\amp, 0.7
);
)

~out.play;

(
~out[1] = \filter -> { | in |
	var snd;
	snd = FFT({LocalBuf(2.pow(10))}.dup, in);
	snd = PV_MagSmooth(snd, LFNoise1.kr(2).unipolar(1.0));
	snd = PV_Diffuser(snd, LFNoise1.kr(50));
	snd = PV_Freeze(snd, LFNoise1.kr(50));
	snd = IFFT(snd);
	snd = snd * 1.3;
};
~out.set(\wet1, 0.8);
)

~out.clear;

(
~out[2] = \filter -> { | in |
	var snd;
	snd = FreeVerb2.ar(in[0], in[1], 1.0, 0.9, 0.8);
	snd = snd * 0.9;
};
~out.set(\wet2, 0.2);
)