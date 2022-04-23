
s.boot;
(
c = TempoClock(150/60).permanent_(true);
p = ProxySpace.push(s, clock: c);
)


(
SynthDef(\who, { arg amp=0.1, freq=440, detune=0, gate=1, out=0, ffreq=800;
    var env;
    env = Env.asr(0.01, amp, 0.1);
    Out.ar(out, Pan2.ar(
        Formant.ar(freq + detune + ffreq, ffreq, 30, EnvGen.kr(env, gate, doneAction: Done.freeSelf)), Rand(-1.0, 1.0))
    )
}).add;

)


~out = Pbind(\instrument, \who, \freq, [606, 601], \ffreq, 800, \legato, 0.02);
~out.play;

// embed a control node proxy into an event pattern:
// this does not work for indirect assignment as \degree, \midinote, etc.,
// because there is calculations in the event! if needed, these can be done in the SynthDef.

~lfo = { SinOsc.kr(2, 0, 400, 700) };
~out = Pbind(\instrument, \who, \dur, Pwhite(0.3, 0.8, inf), \freq, Pwhite(10, 200, inf), \ffreq, ~lfo, \legato, 0.1);
~out.quant = 8;
~out.fadeTime = 0.1;
~out.stop;
~lfo.stop;

~lfo = { SinOsc.kr(SinOsc.kr(0.1, Rand(0,pi), 10, 10), 0, 400, 1000) };

~random = { LFNoise2.kr(MouseY.kr(0.1, 2000.0)).range(200.0, 900.0)};

