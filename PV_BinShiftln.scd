(
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
)

s.boot;

(
c = TempoClock(1).permanent_(true);
p = ProxySpace(s, 'proxyName', c);
p.push;
)

currentEnvironment;

p.fadeTime = 1;
p.quant = 0;
p.reshaping = \elastic;

Buffer.freeAll;

b = ();
b.slice[0] = Buffer.read(s, "/Users/ivainkalashnik/Documents/1510/warp_test_live_v.wav");
b.slice[0].numChannels;
b.slice[1] = Buffer.read(s, "/Users/ivainkalashnik/Documents/Wehlt/nupg 145600.wav");

~out.ar(2);
~out.play;

(
~out = {
	var snd, snd2;
	snd = LoopBuf.ar(2, b.slice[0].bufnum, 2.0, 1.0, b.slice[0].numFrames/2, b.slice[0].numFrames/2, b.slice[0].numFrames, 2.0);
	snd2 = PlayBuf.ar(2, b.slice[1].bufnum, 1.0, 1.0, 0.0, 1.0);
	snd = FFT({LocalBuf(2.pow(15))}.dup, snd);
	snd2 = FFT({LocalBuf(2.pow(15))}.dup, snd2);
	snd = PV_BinShift(snd, stretch: MouseX.kr(1.0, 5.0), shift: 0.0, interp: 1);
	snd2 = PV_BinShift(snd, stretch: MouseX.kr(1.0, 5.0), shift: 0.0, interp: 1);
	snd = PV_BinWipe(snd, snd2, MouseY.kr(-1.0, 1.0));
	snd = IFFT(snd);
	snd = snd * 0.7;
	snd = Limiter.ar(snd);
};
)