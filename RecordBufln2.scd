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
b.buffer = Buffer.alloc(s, s.sampleRate * 0.0005); /*0.05 sec buffer allocation*/
b.buffer.plot;

p.reshaping = \elastic;

~out.ar(2);
~out.play;
~out.stop;

(
~out = {
	var trig, src, buf, scale, snd;
	trig = Dust2.kr(30);
	src = LFTri.ar(40) * Env.perc(0.01, 0.1, 1.0, -9.0).kr(0, Dust2.kr(100));
	buf = RecordBuf.ar(src, b.buffer, 0.0, 1.0, -10.dbamp, 1.0, 1.0, 1.0);
	snd = PlayBuf.ar(1!2, b.buffer, 50, loop: 1);
	scale = LFNoise0.ar(18).range(0.1, 1.0);
	snd = Pluck.ar(snd, trig, 40.reciprocal * scale, 400.reciprocal * scale, 1,
		coef: Lag.kr(TRand.kr(-0.7, 0.9, trig), 0.05));
	snd = snd + GVerb.ar(snd, 9, LFNoise2.kr(4).range(0.05, 0.9), 0.97, 0.1, 100, 1, 0.8, 0.3);
	snd = Limiter.ar(snd);
};
)



(
~out = {
	var trig, src, buf, scale, snd;
	trig = Dust2.kr(10);
	src = LFTri.ar(50) * Env.perc(0.01, 0.1, 1.0, -9.0).kr(0, Dust2.kr(100));
	buf = RecordBuf.ar(src, b.buffer, 0.0, 1.0, -10.dbamp, 1.0, 1.0, 1.0);
	snd = PlayBuf.ar(1!2, b.buffer, 50, loop: 1);
	scale = LFNoise0.ar(18).range(0.1, 10.0);
	snd = Pluck.ar(snd, trig, 40.reciprocal * scale, 400.reciprocal * scale, 1,
		coef: Lag.kr(TRand.kr(-0.7, 0.9, trig), 0.1));
	snd = FFT({LocalBuf(2.pow(12))}.dup, snd);
	snd = PV_Freeze(snd, trig);
	snd = IFFT(snd);
	snd = snd + GVerb.ar(snd, 2.5, LFNoise2.kr(4).range(0.05, 0.9), 0.9, 0.2, 100, 1, 0.7, 0.3);
	snd = Limiter.ar(snd);
};
)

