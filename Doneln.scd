(
SynthDef("Done-help", { arg out, t_trig;
    var line, a, b;

    line= Line.kr(1,0,1);

    a= SinOsc.ar(440,0,0.1*line); //sound fading out
    b= WhiteNoise.ar(Done.kr(line)*0.1); //noise starts at end of line
	FreeSelf.kr(TDelay.kr(Done.kr(line),1));
    Out.ar(out, Pan2.ar(a+b));
}).add;
)

Synth("Done-help");

(
play {
    var env = Line.kr(1,0,2);
    var sig = PinkNoise.ar(env);
    FreeSelf.kr(TDelay.kr(Done.kr(env),7));
    GVerb.ar(sig,70,7);
}
)

// Another way to free a synth when some UGen is done playing is to use FreeSelfWhenDone, or FreeSelf in combination with Done. For example, this can be used to delay the freeing to let reverb tails fade out, etc.

(
SynthDef(\PS, {
	var z, lin, amp, ps;
    z = Blip.ar(100, 60, 0.1);
	lin = Line.kr(4,0.1,2);
	amp = EnvGen.ar(Env.perc(0.01, 4, 1, -5));
    ps = PitchShift.ar(z, 0.9, lin, 0, 0.001);
	FreeSelf.kr(TDelay.kr(Done.kr(amp),4));
	Out.ar(0, GVerb.ar((Pan2.ar(ps) * amp * 30),70, 4, 0.3));
}).add;
)

Synth(\PS);