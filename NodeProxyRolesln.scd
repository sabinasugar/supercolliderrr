~snd = NodeProxy(s, \audio, 2); // make NodeProxy on default server with 2 channels output monitoring nodes
~snd.play(fadeTime: 5); // play monitoring process
~snd.source = {LFTri.ar(LFNoise0.ar(1).range(100, 400)).dup * 0.5}; // fill the source node with function
~snd.stop(fadeTime: 0.1); // stop monitoring process

~snd.fadeTime_(5);
~snd.fadeTime = 5;

~snd.release; // release source nodes
~snd.send; // reinitialize source nodes based on current function

~snd.end; // similar to .clear, but it releases the source nodes and playback process, but not complitely (same effect can be done with cmd + .)
~snd.clear; // releases source nodes and monitoring nodes complitely (~snd.source will be = nil)



a = NodeProxy(s);
a[0] = { |freq = 440, dt=0.1, rate=2| Ringz.ar(Impulse.ar(rate * [1, 1.2]), freq, dt)*0.1 };
a.play;
(
a[1] = \xset -> Pbind(
    \dur, Prand([1, 0.5], inf),
    \freq, Pwhite(200.0, 1000.0, inf),
    \rate, Pstutter(2, Prand([1, 3, 6, 10], inf)),
    \dt, Pwhite(0.01, 0.1, inf)
)
);
// modify the source in the meanwhile:
a[0] = { |freq = 200, dt=0.01, rate=0.5| Ringz.ar(Dust.ar(rate * [1, 1.2]), freq, dt)*0.1 };
a.fadeTime_(5);
a[1] = nil;
a.stop;
a.nodeMap.postln; // the values are not set in the node map.
a.clear(3);


Ndef(\snd, { SinOsc.ar([450, 320]) * 0.5 });
Ndef(\snd).fadeTime = 2;


~snd = Ndef(\snd);
~snd.stop;

Ndef(\a).play; // play to hardware output.
Ndef(\a).quant = 8;
Ndef(\a).fadeTime = 0.5; // fadeTime specifies crossfade
// set the source
Ndef(\a, { SinOsc.ar([350, 351.3], 0, 0.2) });
Ndef(\a, { Pulse.ar([350, 351.3] / 4, 0.4, 0.2) });
Ndef(\a, Pbind(\dur, 0.3, \freq, Pbrown(0, 1, 0.1, inf).linexp(0, 1, 200, 350)));