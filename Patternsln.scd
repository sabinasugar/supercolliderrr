(
    x = Routine({
        1.yield;
        2.yield;
        3.yield;
    });
    4.do({ x.next.postln });
)
(
a = Routine {
    var    i = 0;
    loop {
        i.yield;
        i = i + 1;
    };
};
)
a.nextN(10);
(
a = Routine {
    (0..).do { |i|
        i.yield;
    };
};
)
a.nextN(10);

a = Pseries(start: 0, step: 1, length: inf).asStream;
a.nextN(10);

p = Pseries(0, 1, 10);
p.next;
q = p.asStream;
q.next;
r = p.asStream;
r.next;
q.next; // independent run of pseries


(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).play;
)

Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).asStream.all;

// or, to show the segments as separate arrays
Pslide(#[1, 2, 3, 4, 5, 6, 7, 8], 10, 3, 1, 0, false).clump(3).asStream.all;

c = [[0, 1], [9, 3]];
d = [[2, 1], [6, 3], [9, 3]];
d [1] + c [1];

e = (freq: 440, dur: 0.5);    // an Event

e.at(\freq)        // access a value by name
e[\freq]
e.freq

e.put(\freq, 880);    // Change a value by name
e[\freq] = 660;
e.freq = 220;

e.put(\amp, 0.6);    // Add a new value into the event
e.put(\dur, nil);    // Remove a value

(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).asStream;    // remember, you have to make a stream out of the pattern before using it
)

p.next(Event.new);

(
SynthDef(\bass, { |out, freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: Done.freeSelf);
    sig = LPF.ar(sig, ffreq);
    Out.ar(out, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 132/60;
p = Pxrand([
    Pbind(            // repeated notes
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.05], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // tritone jump
        \midinote, Pseq([36, 42, 89, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5,
		\detune, 1.005
    )
], inf).play(quant: 1);
)

p.stop;

(
SynthDef(\cfstring1, { arg i_out, freq = 360, gate = 1, pan, amp=0.1;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
    osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99, 1.01), Rand(0.99, 1.01)], 0, amp) }).distort * 0.2;
    eg = EnvGen.kr(Env.asr(1, 1, 1), gate, doneAction: Done.freeSelf);
    out = eg * RLPF.ar(osc, fc, 0.1);
    #a, b = out;
    Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).add;

e = Pbind(
    \degree, Pseq((0..12), inf),
    \dur, 0.2,
    \instrument, \cfstring1
).play; // returns an EventStream
)

// an interactive session
e.stop
e.play
e.reset

e.mute; // keeps playing, but replaces notes with rests

e.unmute;

(
e.stream = Pbind(
    \degree, Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf),
    \dur, Prand([0.2, 0.4, 0.8], inf),
    \amp, 0.05, \octave, 5,
    \instrument, \cfstring1, \ctranspose, 0
).asStream;
)

(
SynthDef(\acid, { arg out, freq = 1000, gate = 1, pan = 1, cut = 4000, rez = 0.8, amp = 1;
    Out.ar(out,
        Pan2.ar(
            RLPF.ar(
                Pulse.ar(freq, 0.05),
            cut, rez),
        pan) * EnvGen.kr(Env.linen(0.01, 1, 0.3), gate, amp, doneAction: Done.freeSelf);
    )
}).add;
)

(
c = Pbind(\instrument, \acid, \dur, Pseq([0.7, 0.5, 0.25], inf), \root, 0,
    \degree, Pseq([0, 5, 1, 1, 1, 11, 5, 1], inf), \pan, Pfunc({1.0.rand2}),
    \cut, Pxrand([1000, 500, 2000, 30], inf), \rez, Pfunc({0.9.rand +0.3}), \amp, 0.2).asStream;
)

c.next(()).play;

c.reset

( 'degree': 2, 'dur': 0.9 ).play;
('instrument': \acid, 'degree': 2, 'dur': 0.5).play;

d = Pwhite(0, 7, inf).asStream;
d.next;
d.reset;

p = Pbind(\degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 1).play;
p.stop;

p = Pmono(\default, \degree, Pwhite(0, 7, inf), \dur, 0.25).play;
p.stop;

v = Pfunc{ 0.7.coin.binaryValue }.asStream;
v.next;

(
TempoClock.default.tempo = 1;
p = Pbind(
	\instrument, \acid,
    \degree, Pseq([
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })    // down (step = -1)
    ], inf),
    \dur, Pseq([
		Pseries({ rrand(0.2, 0.1) }, 0.01, 5),
		Pseries({ rrand(0.2, 0.1) }, -0.01, 5)
	], inf)
).play;
)

(
p = Pbind(
	\instrument, \acid,
	\dur, Pseq([Pseries({ rrand(0.2, 0.1) }, 0.01, 5),
		Pseries({ rrand(0.2, 0.1) }, -0.01, 5)], inf)
).asStream;
)
p.next(());
