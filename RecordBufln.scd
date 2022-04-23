(
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
)

s.reboot;

(
c = TempoClock(1).permanent_(true);
p = ProxySpace(s, 'proxyName', c);
p.push;
)

Buffer.freeAll;

b = ();
b.buffer = Buffer.alloc(s, s.sampleRate * 0.001); /*0.05 sec buffer allocation*/
b.buffer.plot;

p.reshaping = \elastic;

~out.ar(2);
~out.play;
~out.stop;

(
~out = {
	var trig, src, buf, scale, snd;
	trig = Dust2.kr(30);
	src = LFTri.ar(1) * Env.perc(0.01, 0.1, 1.0, -9.0).kr(0, Dust2.kr(100));
	buf = RecordBuf.ar(src, b.buffer, 0.0, 1.0, -8.dbamp, 1.0, 1.0, 1.0);
	snd = PlayBuf.ar(1!2, b.buffer, 50, loop: 1);
	scale = LFNoise0.ar(20).range(0.5, 10.0);
	snd = Pluck.ar(snd, trig, 200.reciprocal * scale, 300.reciprocal * scale, 1,
		coef: Lag.kr(TRand.kr(-0.99, 0.99, trig), 0.02));
	snd = GVerb.ar(snd, 4, LFNoise2.kr(2).range(0.05, 0.5), 0.95, 0.9, 100, 1);
	snd = Limiter.ar(snd);
};
)

