(Platform.userHomeDir +/+ "/Desktop/boot.scd").load;

b = ();
b.buf = Buffer.read(s,"/Users/ivainkalashnik/Desktop/d 12.02.54 PM.wav" );
b.buf2 = Buffer.read(s, "/Users/ivainkalashnik/Desktop/Tony Lugo - Snare 7-ApB.wav");
b;

//beat resynthesis match by ZCR and spec centroid

(
~concat = {arg bufnum, freeze=0;
	var concat, concatfft, control, input, amp;
	input = PlayBuf.ar(2,b.buf2,BufRateScale.kr(b.buf2), loop:1);
	control = PlayBuf.ar(2, b.buf,BufRateScale.kr(b.buf) * LFSaw.kr(LFNoise2.kr(1).range(1, 5)).range(0.5, 1.5), loop:1);
	concat = Concat.ar(input,control,6.0,5.0,1.0, LFNoise0.kr(4).range(0.1,0.5),0,MouseY.kr(0.0,1.0),0.0,1.0);
	concat = DFM1.ar(concat, (EnvDetect.ar(concat, 0.0, 0.0001).range(-4000, 15000)).clip(20, 15000).poll, 0.2, 1.0, 0, 0.0);
	concat = SineShaper.ar(concat, 0.5) * 1.2;
	concatfft = FFT({LocalBuf(2.pow(10))}.dup, concat);
	concatfft = PV_MagNoise(concatfft);
	concatfft = PV_MagFreeze(concatfft, Demand.ar(Dust.ar(15), 0, Dseq([-1.0, 1.0], inf))); // Drand([-1.0, 1.0], inf);
	concatfft = IFFT(concatfft);
	concat = Splay.ar(Pan2.ar(concat, LFNoise2.kr(4) * 0.5) + Pan2.ar(concatfft, LFNoise2.kr(4) * 0.5), 0.5, 1, 0.0);
};
)


~concat.play;
~concat.ar(2);

s.reboot;
currentEnvironment;

(
m = ProxyMixer(p, 8);
m.parent.alwaysOnTop_(true); // show mixer in front of IDE
)