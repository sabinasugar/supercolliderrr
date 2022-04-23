(
s.quit;
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 16;
s.boot;
c = TempoClock(1).permanent_(true);
p = ProxySpace(s, 'proxyName', c);
p.push;
)

"input:" + s.options.numInputBusChannels.postln;
"output:" + s.options.numOutputBusChannels.postln;

currentEnvironment;

(
p.quant = 4;
p.fadeTime = 4;
)

(
SynthDef(\kick, {
	var ampEnv, snd;
	ampEnv = Env.perc(\atk.kr(0.001), \rel.kr(0.9), 1.0, \cur.kr(-3.0)).kr(doneAction: 2);
	snd = DC.ar(0);
	snd = snd + ((SinOsc.ar(XLine.ar(2300, 10, 0.007)) * Env.perc(0.0002, 0.01, curve: -10).ar) * 0.05);
    snd = snd + (BPF.ar(Impulse.ar(0) * SampleRate.ir / 44100, 11100, 1.0) * 3.dbamp);
    // snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 200, 0.9) * Env.perc(0.001, 0.5, 0.3, -1).ar);
	snd = BMoog.ar(snd, 4000, 0.0,  saturation: 0.99);
	snd = snd + (PitchShift.ar((SinOsc.ar(XLine.ar(322, 40, 0.07)) * Env.perc(0.0001, 0.9, curve: -5).ar(2)), 0, 0.0, 0, 0.0) * 5);
	snd = Limiter.ar(snd.distort);
	Out.ar(\out.kr(0), Pan2.ar(snd, \pan.kr(0.0), \amp.kr(0.4) * ampEnv));
}).add;
)

(
~kick = Pbind(
	\instrument, \kick,
	\dur, Prand([0.6, 0.6/3], inf),
	\cur, -3,
	\amp, 0.6
);
)

~kick.fadeTime = 0.02;
~kick.play;
~kick = {};
~kick.stop;
~kick.clear;