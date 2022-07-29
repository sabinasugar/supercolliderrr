({
	var dur_up_down = MouseX.kr(1,5);
	var ctl_maths = Maths2.ar(dur_up_down,dur_up_down, 0.9);

	var trig_rate = ctl_maths[0].linexp(0,1,5,50);
	var trig = Impulse.kr(trig_rate);

	var snd_maths0 = Maths2.ar(0.001, min(0.2, 1/trig_rate), 0.99, 0, 1, trig)[0];
	var freq0 = snd_maths0.linlin(0,1,50,300);
	var sound0 = SinOsc.ar(freq0, 0.0, 0.5)*snd_maths0.sqrt;

	var snd_maths = Maths2.ar(0.001, 0.018, 0.99, 0, 1, trig)[0];
	var env = Lag.ar((snd_maths-0.001)>0, 0.02);

	var freq1 = snd_maths.linlin(0,1,5300,6800);
	var sound1 = SinOsc.ar(freq1*[1,4,8], 0.0, 0.075).sum*env;

	var freq2 = snd_maths.linlin(0,1,3000,4100);
	var sound2 = SinOsc.ar(freq1*[1,4,8], 0.0, 0.075).sum*env;

	var mix = RLPF.ar(sound0+sound1+sound2, ctl_maths[0].linlin(0,1,400, 20000), ctl_maths[0].linlin(0,1,0.4,0.95), 1).dup;

	var out = mix+DelayC.ar(mix, 0.1, 0.018, ctl_maths[0].linlin(0,1,0.25,0));

	out = out;

	out.tanh
}.play)

({
	var maths, synth, trig, env;

	trig = Impulse.ar(0.5);
	maths = Maths2.ar(0.01, 1, 0.95, 0, 1, trig);
	env = Lag.ar((maths[0]-0.001)>0, 0.02);

	synth = Array.fill(5, {|i| SinOsc.ar((i+1)*maths[0].linlin(0,1,100,2500), 0, 0.05)}).sum*env;

	CombC.ar(synth.dup, 0.05, 0.04, 2)+CombC.ar(synth.dup, 0.03, 0.03, 2, 0.1, synth)
}.play) // by Sam_Pluta


(
{
	var trig, snd, freqs;
	trig = Impulse.ar(LFNoise2.kr(1).linexp(-1, 1, 1, 100));
	freqs = (60.5 + [0, 2, 4, 5, 7, 9, 10]).midicps;
	snd = Pluck.ar(Hasher.ar(Sweep.ar(trig)) * -10.dbamp, trig, freqs.reciprocal, freqs.reciprocal, 0.9, 0.5);
	snd = LeakDC.ar(snd).sum;
	snd = MoogFF.ar(snd, LFNoise2.kr(1).linexp(-1, 1, 500, 16000), 0);
	snd = snd ! 2;
	snd;
}.play(fadeTime: 0);
) // by nathan

// Sweep/Hasher trick to get the same noise profile every time is a beauty.

b = Buffer.alloc(s, 16384, 1);

(
a = {
	var notes = [49, 54, 56, 59, 63, 65, 70, 73, 75];
	var harmonics = [1, 2, 3.5, 2, 4, 7];
	var freqs = notes.midicps *.x harmonics *.x [1, 1.008];
	var exc = PinkNoise.ar * EnvGen.ar(Env.perc(0.001, 0.01));
	var sig = Klank.ar(`[freqs, 1 ! freqs.size, b.duration ! freqs.size], exc) * 0.05;
	RecordBuf.ar(sig, b, loop: 0, doneAction: 2);
	sig.dup
}.play;
)

(
z = {
	var pulse = Dust.ar(LFDNoise3.kr(0.2).exprange(3, 15));
	var excEg = Decay2.ar(pulse, 0.001, 0.02);
	var noise = PinkNoise.ar * excEg;
	var ffreq = LFDNoise3.kr(0.2).exprange(200, 10000);
	var frq = LFDNoise3.kr(0.12372).exprange(0.02, 0.4);

	noise = BLowPass4.ar(noise, ffreq, frq);

	(Convolution2.ar(noise, b, framesize: b.numFrames) * 0.1).dup
}.play;
) // by jamshark70

(
{
    arg mratio=4, amp=0.2, boost=2;
    var env, freq, freqenv, trig, index, sig;
    trig = Impulse.ar(LFNoise2.kr(1).linexp(-1, 1, 1, 100));
    env = Env.perc(0.0001, 1.0, curve: -8).ar(0, trig);
    freqenv = Env.perc(0.0001, 0.4, curve: -8).ar(0, trig);
    freq = 60.5.midicps / 16;
    freq = freq * freqenv.linexp(0, 1, 1, 40);
    index = MouseY.kr(0, 2);
    sig = SinOsc.ar(freq, SinOsc.ar(freq * mratio) * index);
    (sig!2 * boost).tanh * env * amp;
}.play;
) // by PitchTrebler

(
~numPartials = 10;
~bufAmps = Buffer.alloc(s, ~numPartials);

SynthDef(\additive, {
	arg shapeAmount=0.3, time=1, freq=150;

	var gainEnv = \gainEnv.ar(Env.newClear(8).asArray);
	var fltEnv = \fltEnv.ar(Env.newClear(8).asArray);
	var iEnv = \iEnv.ar(Env.newClear(8).asArray);

	var k = 2 * shapeAmount / (1 - shapeAmount);
	var numPartials = ~numPartials;
	var bufAmps = ~bufAmps;
	var trg = \gt.kr(1);
	var sig, mod;

	iEnv = EnvGen.kr(iEnv, trg, timeScale:time, doneAction:Done.none);
	fltEnv = EnvGen.kr(fltEnv, trg, timeScale:time, doneAction:Done.none);
	gainEnv = EnvGen.kr(gainEnv, trg, doneAction:Done.freeSelf);

	mod = SinOsc.ar(freq * \mRatio.kr(1), mul: iEnv);

	BufWr.ar(
		LFGauss.ar(
			duration: SampleDur.ir * numPartials * \factor.kr(1).reciprocal,
			width: gainEnv * LFNoise2.kr(1).linexp(-1, 1, \widthMin.kr(0.1, 0.5), \widthMax.kr(1.0, 0.5)),
			iphase: \phase.kr(0, 0.5).mod(4pi)
		),
		bufnum: bufAmps,
		phase: Phasor.ar(
			end: numPartials
		)
	);

	sig = Array.fill(numPartials, {
		arg i;
		SinOsc.ar(
			freq: ((i * 2) + 1) * freq * \cRatio.kr(1, 0.5),
			phase: mod.wrap(0, 4pi),
			mul: Index.ar(bufAmps, i)
		) / numPartials
	}).sum;

	sig = ((1 + k) * sig / (1 + (k * sig.abs)));
	sig = (sig * 2).tanh;
	sig = HPF.ar(sig, 75);

	sig = MoogFF.ar(sig, fltEnv * \fltFreq.kr(7500), 0);

	sig = sig * gainEnv;

	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.25));
	sig = LeakDC.ar(sig);
	OffsetOut.ar(\out.kr(0), sig);
}).add;

SynthDef(\combL, {
	arg in=0, out=0, mix=(-0.5), decay=1, amp=1, delHz=0.55, delStereoRatio=0.9, delMin=0.001, delMax=0.4;
	var sig, comb;
	sig = In.ar(in, 2);
	delHz = delHz * [1,delStereoRatio];
	comb = CombL.ar(
		sig,
		delMax,
		LFPar.kr(delHz,[0,pi/2]).exprange(delMin,delMax),
		decay,
	);
	sig = XFade2.ar(sig, comb, mix) * amp;
	Out.ar(out, sig);
}).add;
)

(
// assist data-sharing in pbindfx creation
// pbindfx is wrapped in a private environment (Penvir)
// arguments are just pdef names
~pbindFx = {|srcName ... fxNames|
    // add private environment, shared between source and fxs
    Penvir(Event.new(parent:currentEnvironment),
        PbindFx(
            // source: record latest event in ~src
            *[Pdef(srcName).collect(~src=_)]
            // add all fx: they can access source event saved in ~src
            ++ fxNames.collect(Pdef(_))
        )
    )
};

~utils = ();
~utils.hasEnv = {
    // calc this event's duration in seconds
	var durSeconds = ~sustain.value / thisThread.clock.tempo;
    // find all parameters ending in env or Env
    var envKeys = currentEnvironment.keys.select{|k|"[eE]nv$".matchRegexp(k.asString)};
    envKeys.do{|param|
        var value = currentEnvironment[param];
        if (value.isArray.not) { value = [value] };
        value = value.collect {|v|
            // pass rests along...
            if (v.isRest) { v } {
                // convert non-env values to a continuous, fixed value env
                if (v.isKindOf(Env).not) { v = Env([v, v], [1]) }
            };
            // stretch env's duration
            v.duration = durSeconds;
        };
        currentEnvironment[param] = value;
    };
};

Event.addParentType(\hasEnv,(
    finish: ~utils[\hasEnv]
));

t = TempoClock.new(60/60).permanent_(true);
)

(
Pdef(\additive,
	Pbind(
		\type, \hasEnv,
		\instrument, \additive,

		\dur, (Pseq((0..25).linexp(0, 25, 1, 75), inf).reciprocal).trace,

		\midinote, Pdup(26, Pseq([60 + [0, 4, 7, 11]], inf))
		+ Pseq([Pdup(25, Pseq([0.25])), Pseq([0.1667])], inf),

		\factor, Pdup(26, Pseq([3,1],inf)),
		\phase, 1,
		\widthMin, 0.1,
		\widthMax, 0.5,

		\atk, 0.0001,
		\rel, 1,
		\gainEnv, Pfunc{|e|
			Env.perc(e.atk, e.rel, curve: -8.0);
		},
		\sustain, Pfunc { |ev| ev[\gainEnv].duration },

		//Phase Modulation
		\mRatio, 1.5,
		\cRatio, 1,
		\index, 1,
		\iScale, 2,

		\iAtk, 0.001,
		\iRel, 0.35,

		\time, Pfunc { |ev| ev.use { ~sustain.value } / thisThread.clock.tempo },

		\iEnv, Pfunc{ |e|
			var cAtk = exprand(2,6);
			var cRel = exprand(-2,-6);
			Env([e.index, e.index * e.iScale, e.index], [e.iAtk, e.iRel], [cAtk, cRel])
		},

		\fAtk, 0.001,
		\fSus, 0.15,
		\fRel, 0.25,

		\fltFreq, 7500,

		\fltEnv, Pfunc{|e|
			var cAtk = exprand(2,6);
			var cRel = exprand(-2,-6);
			Env([0,1,1,0],[e.fAtk, e.fSus, e.fRel],[cAtk,0,cRel])
		},

		\pan, 0,
		\amp, 0.30,
		\out, 0,
		\finish, ~utils[\hasEnv],
		\cleanupDelay, Pkey(\sustain),
		\fxOrder, [1]
	)
);

Pdef(\additive_comb,
	Pbind(
		\fx, \combL,
        \mix, 0.5,
        \amp, 1,
        \delStereoRatio, 0.9,
        \delHz, 0.1,
        \delMin, Pfunc { (~src.dur == 1).if { 0.35 }{ 0.15 } },
		\delMax, Pkey(\delMin) + 0.01,
		\decay, Pfunc { (~src.dur == 1).if { 2 }{ 0.5 } },
        \cleanupDelay, Pkey(\decay)
));

Pdef(\additive_fx, ~pbindFx.(\additive, \additive_comb));
)

Pdef(\additive_fx).play(t, quant:1);

// by dietcv

(
{

	var numPartials = 64;
	var spectrum = (1..numPartials);

	var tension = (1 + (spectrum * spectrum * \inharmonic.kr(0.005))).sqrt;
	var tilt = (log2(spectrum) * \tilt.kr(-3)).dbamp;

	var freqs = \freq.kr(110) * spectrum * tension;

	var sig = SinOsc.ar(freqs, { Rand(0, 2pi) } ! numPartials);

	sig = (sig * tilt).sum;

	sig ! 2 * 0.05;

}.play;
) // by dietcv

(
{
    var n, partials, detunes, fenv, freqs, sig, envs;
    n = 64;
    partials = (1..n);
    detunes = (LFNoise1.kr(0.2 ! n) * \det.kr(0.2)).midiratio;
    fenv = XLine.kr(2.0, 1.0, partials.pow(0.7) / 10);
    freqs = \freq.kr(110) * partials * detunes * fenv;
    sig = SinOsc.ar(freqs, {Rand(0, 2pi)} ! n);
    sig = sig / partials.pow(\dampen.kr(0.9)); // dampen >= 0!
    envs = Env.perc(
        \atk.kr(0.1) * partials.pow(0.6) * ({Rand(0.5, 1.5)} ! n),
        \rel.kr(7.0) / (partials + 3).pow(0.9) * ({ExpRand(0.5, 2.0)} ! n)
    ).ar;
    sig = (sig * envs).sum;
    DetectSilence.ar(sig, doneAction: 2);
    sig ! 2 * 0.05;
}.play;
) // PitchTrebler

(
{

	var tFreq = LFDNoise3.ar(0.3).linlin(-1, 1, 1, 5);
	var trig = Impulse.kr(tFreq);
	var time = 1 / tFreq;

	var lpfEnv, gainEnv;
	var cutoff, tension, tilt, lpf, peakEQ;
	var sig, freqs, numPartials, spectrum;

	numPartials = 150;
	spectrum = (1..numPartials);

	lpfEnv = EnvGen.kr(Env(
		[0, 1, 0],
		[\fltAtk.kr(0.10), \fltRel.kr(0.90)],
		[\fltAtkCurve.kr(4.0), \fltRelCurve.kr(-8.0)]
	), trig, timeScale: time);

	gainEnv = EnvGen.ar(Env(
		[0, 1, 0],
		[\atk.kr(0.01), \rel.kr(0.99)],
		[\atkCurve.kr(4.0), \relCurve.kr(-4.0)]
	), trig);

	// harmonic tension
	tension = (1 + (spectrum * spectrum * \inharmonic.kr(0.01))).sqrt;

	// frequency spectrum
	freqs = \freq.kr(103.826) * spectrum * tension;
	sig = SinOsc.ar(freqs, { Rand(0, 2pi) } ! numPartials);

	// 3db/octave spectral tilt
	tilt = (log2(spectrum) * \tilt.kr(-3)).dbamp;

	// LPF
	cutoff = \lpfCutoff.kr(100) + lpfEnv.linlin(0, 1, 0, \lpfEnvAmount.kr(8000));
	lpf = ((log2(freqs) - log2(cutoff)) * \lpfSlope.kr(-12)).min(0).dbamp;

	// Peak EQ
	peakEQ = ((log2(freqs) - log2(cutoff)).abs * \peakSlope.kr(-12) + \peakRes.kr(24)).max(0).dbamp;

	sig = (sig * tilt * lpf * peakEQ).sum;

	sig = sig * gainEnv;

	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.05));

}.play;
) // dietcv