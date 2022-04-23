s.boot;

(
SynthDef(\OscFill, {
	var oscs;
	oscs = Mix.fill(50, {
		arg index;
		var sin;
		// index.postln;
		sin = VarSaw.ar(LinRand.new(100,1000), 1.0.rand, 1.0.rand, 1)/(index+1)*0.2;
		Pan2.ar(sin, 1.0.rand2);
	}) * EnvGen.ar(Env.perc(7, 7, 0.8, 0), doneAction: 2);
	Out.ar(0, Pan2.ar(oscs, 0.0));
}).add;
)

Synth(\OscFill);

(
{

	inf.do {
		Synth(\OscFill);
		6.0.wait;
	};

}.fork;
)

// --------------------------------------------------------------------------------------------------------

(
(2..10).do{|num|

    SynthDef("wiggler%".format(num), {|freq=440, amp=0.1|
        var oscs;
        oscs = Mix.fill(num, {|index|
            SinOsc.ar(freq * index)
        });
        Out.ar(0, oscs * amp);
    }).add;
}
)

x = Synth("wiggler2")

x.free

x = Synth("wiggler17")

x.free

// --------------------------------------------------------------------------------------------------------

(
SynthDef("test",
    {
        arg n=8;

        var cutoff = tanh( (1..16)-n-0.5 *100 ) * -1 / 2 + 0.5; // this

        f=Mix.fill(16, { // run it through the upper bound
            arg index;
            var freq, amp;
            freq=LinRand.new(100,200)*((7/6)**index);
            //freq.postln;
            amp=(1-(index / n)) / (n*(n+1) / (2*n));
			cutoff[index] * VarSaw.ar(LinRand(100, 400) + (EnvGen.ar(Env([LinRand(200,2000), 0], [0.1], -15))), 1.0.rand, 1.0.rand, 0.2*amp); // multiply with cutoff
        });
        //f=SinOsc.ar(440,0,0.2);
		Out.ar(0, Pan2.ar(f * EnvGen.ar(Env.perc(0.01, 2, 0.8, -5), doneAction: 2), 0.0, 1));
    }).add;
)

// The cutoff array has values 1 if index<n, and zeros after that. Lets say n=3, then cutoff==[1,1,1,0,0,0,...].

Synth(\test, [\n, 8]);
