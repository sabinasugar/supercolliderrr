{2}.dup = 2.dup(2) = 2 ! 2


d = Buffer.read(s, "/Users/ivainkalashnik/Documents/Wehlt/adaditive_fluxafsd_s/Audio 22 [2022-02-01 004538].wav");

(
{
  var size, inA, chainA, inB, chainB, chain, snd;
	size = 16384; // 16384*2;
    inA = Blip.ar(MouseX.kr(1, 40), MouseY.kr(40, 2000), 0.5);
    inB = PlayBuf.ar(2, d, BufRateScale.kr(d), loop: 1);
	chainA = FFT({LocalBuf(size)}.dup, inA, wintype: 1);
	chainB = FFT({LocalBuf(size)}.dup, inB, wintype: 1);
    chain = PV_MagMul(chainA, chainB); // writes into bufferA
    snd = IFFT(chain) * 0.2;
	snd = Limiter.ar(snd.softclip);
}.play;
)

d.free;