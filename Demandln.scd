s.boot;

(
{
    var a, freq, trig, snd;
	a = Drand([1, 3, 2, 4, 2], inf);
    trig = Impulse.kr(MouseX.kr(1, 40, 1));
	freq = Lag.kr(Demand.kr(trig, 0, a) + 19, 0.3);
	snd = (LFTri.ar(freq, mul: Lag.kr(LFNoise0.kr(10).range(0.0, 1.0), 0.1)).fold(LFSaw.kr(LFNoise2.kr(10).range(5, 55), mul: 80)) ! 2) * 0.8;
	snd = snd * 2;
	snd = snd.fold(SinOsc.ar(20) * 150);
	snd = MoogVCF.ar(snd, LFNoise1.kr(5).range(40, 8000).clip(40, 10000), 0.2);
	snd = snd.tanh;
	snd = Limiter.ar(snd);
}.play;
)

