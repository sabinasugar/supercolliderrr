s.boot;

(
SynthDef(\Sin,
	{arg freq = 440;
		var env, envgen, generator;
		env = Env.perc(0.01, 1, 0.3, -10);
		envgen = EnvGen.kr(env, 1, doneAction: Done.freeSelf);
		generator = SinOsc.ar(freq,0,0.3);
		Out.ar(0, {generator * envgen});
		Out.ar(1, {generator * envgen});
}).add;
)

// or EnvGen.kr(Env.perc(0.01, 1, 0.5, -10), doneAction: Done.freeSelf);

a = Synth(\Sin,[\freq,1000.rand]);



Env.perc(0.01, 1, 0.3, -7).test.plot;

Env.new(levels: [0, 1, 0.9, 0], times: [0.1, 0.5, 1], curve: [-5, 0, -5]).plot; // Env.new type envelope

(
{
    EnvGen.kr(
        Env.new(
            levels: [0, 1, 0.5, 0],
            times: [0.01, 0.01, 0.01],
            releaseNode: 2 // sustains at level 0.5 until gate is closed
        ),
		gate: Trig.kr(Impulse.kr(3), dur: 0.3) // gate is a trigger input for EnvGen (??)
    );
}.plot(duration: 1);
)

{Trig.kr(Impulse.kr(3), dur: 0.3)}.plot(duration: 1) // Trig.kr triggered by Impulse.kr for 0.3 msec