(
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
s.reboot;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s, \proxyName, c);
p.quant = 4;
p.reshaping = \elastic;
)

(
m = ProxyMixer(p, 8);
m.parent.alwaysOnTop_(true);
ProxyMeter.addMixer(m);
)

(
b = ();
b.samp = [Buffer.read(s, "/Users/ivainkalashnik/Desktop/Audio_01/OYOYO/[[stuck in a car] x3].wav")];
)


(
~out = {
	var n, snd, freqs, amps, rings;
	n = 150;
	snd = PlayBuf.ar(2, b.samp, \rate.kr(1.0, 0.1), 1.0, 0.0, 1.0);
	freqs = Array.fill(n, {arg index;
		(((index+1)**2))}).postln; // exp harmonics distribution
	amps = (1 ! n) / n;
	rings = (1!n) * MouseY.kr(0.1, 0.5);
	snd = DynKlank.ar(`[[freqs], [amps], [rings]], snd);
	snd = Limiter.ar(snd);
};
)

~out.play;

(
Array.fill(15, {arg index;
		(((index+1)**2))}).postln;
)

(

a = Array.fill(150, {arg index;
		(((index+1)**2))}); // exp harmonics distribution
a.postln;
a.size;

)


(
var n, amps;
n = 10 + 1;
amps = Array.fill( n/2, { | i |
	i+1;
});
amps = amps.mirror;
)