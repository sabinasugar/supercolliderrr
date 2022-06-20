(Platform.userAppSupportDir +/+ "/boot.scd").load;

g = Env([0, 1, 0], [0.001, 1.0], [0, -7]);
e = Buffer.sendCollection(s, g.discretize, 1);


(
~out = {
	var trig, snd;
	trig = Dust2.ar(MouseX.kr(1, 500));
	snd = GrainFM.ar(
		numChannels: 2,
		trigger: trig,
		dur: 0.3,
		carfreq: Demand.ar(trig, 0, Dseq(Dseries(100, 100, 20), inf)),
		modfreq: Demand.ar(trig, 0, Dseq(Dseries(10, 10, 50), inf)) + MouseY.kr(-1000, 1000),
		index: Demand.ar(trig, 0, Dseq([1, 2, 5, 10, 50], inf)),
		pan: Demand.ar(trig, 0, Dwhite(-0.5, 0.5, inf)),
		envbufnum: e) * 0.1;
};
)

~out.play;

(
{
	var n = 4;
	var trig = Impulse.ar(440);
	var trigs = PulseDivider.ar(trig, n, (0 .. n-1));
	Decay.ar(trigs, 0.005)
}.plot(0.02);
)

(
// custom granular envelopes
~getCustomEnvs = {
	var tri = Env([0, 1, 0], [1, 1], \lin);
	var perc = Env.perc(0.01, 1, 1, -4);
	var customEnvs = [tri, perc];
	customEnvs.collect{|env| Buffer.sendCollection(s, env.discretize(2048), 1) };
};
~customEnvs = ~getCustomEnvs.();
)

(
SynthDef(\pulsar, { |envBuf|

	var trig = \trig.tr(1);
	var sig, pan;

	var spectrum = [ 1.0, 2.2954172674277, 3.5984846739581, 4.9032805732124, 6.2087321305725, 7.514500962484, 8.8204471056119, 10.126502295694, 11.432629299891, 12.738806093605 ];

	var tension = (1 + (spectrum * spectrum * \inharmonic.kr(0.001))).sqrt;
	var freqs = \freq.kr(68, 0.3) * spectrum * tension;
	var tilt = (log2(spectrum) * \tilt.kr(-3)).dbamp;

	pan = Demand.kr(trig, 0, Dseq([-1, 1], inf) * \panMax.kr(0.8));

	sig = GrainSinJ.ar(
		numChannels: 2,
		trigger: trig,
		dur: \granDur.kr(1),
		freq: freqs,
		grainAmp: tilt,
		pan: pan,
		envbufnum: envBuf,
		maxGrains: 2048
	);

	sig = sig.sum;

	sig = sig * -25.dbamp;

	sig = sig * \amp.kr(0.25);

	Out.ar(\out.kr(0), sig);
}).add;
)

(
Pdef(\pulsar,
	Pmono(\pulsar,

		\freq, 51.913,

		\bufIndex, 1,
		\envBuf, Pfunc{ |ev| ~customEnvs[ev[\bufIndex]] },

		\tFreq, Pseg([51.913, 5.913], [5], \exp, inf),
		\dur, 1 / Pkey(\tFreq),
		\overlap, 1,

		\granDur, Pkey(\dur) * Pkey(\overlap),

		\amp, 0.5,
		\out, 0,
	)
).play;
)