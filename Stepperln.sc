s.boot;

(
SynthDef(\Harm, {
	arg frq_base = 440, frq_sin = 440;
	var n = 20;
    var amp_base = 0.1;
	var env = EnvGen.kr(Env.perc(0.01, 1.6, 1, -10), doneAction: Done.freeSelf);
	var mix = Mix.new([SinOsc.ar(frq_sin, mul:0.2), Mix.fill(n, { arg index;
			var step;
			var stepsm;
			var freq;
			step = Stepper.ar(Impulse.ar(100), 0, 100, 1000, 50);
			stepsm = BLowPass4.ar(step, freq: 20.0, rq: 1.0, mul: 1.0, add: 0.0);
            freq = stepsm + frq_base*(index+1);
            freq.postln;
            SinOsc.ar(freq , 0, amp_base / (index+1))
        })]);
	Out.ar(0, {mix * env});
	Out.ar(1, {mix * env});
}).add
)

// or separated var's for everything


a = Synth(\Harm, [\frq_base, 80+500.rand, \frq_sin, 80+500.rand]);


SynthDef("help-Stepper",{ arg out=0;
    Out.ar(out,
        SinOsc.ar(
            Stepper.kr(Impulse.kr(10), 0, 4, 16, 1) * 100,
            0, 0.05
        )
    )
	}).play;
)

{Stepper.kr(Impulse.kr(10), 0, 100, 10, 1)}.plot(duration: 1)

BLowPass4.ar(, freq: 1200.0, rq: 1.0, mul: 1.0, add: 0.0)



