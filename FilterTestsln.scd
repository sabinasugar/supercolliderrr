Bo.ot;

p.fadeTime = 5;

(
~saw = {
	var freqMod, freqMod2, res, snd;
	freqMod = LFSaw.kr(LFNoise1.kr(0.1).range(0.2, 2.0).neg).exprange(100.0,2000.0).lag(0.4).clip(0, 20000);
	freqMod2 = LFSaw.kr(LFNoise1.kr(0.2).range(0.2, 3.0).neg).exprange(100.0,3000.0).lag(0.4).clip(0, 20000);
	res = 0.8;
	snd = SawDPW.ar([LFNoise1.kr(0.2).range(10, 90), LFNoise1.kr(0.3).range(10, 90)])/2;
	snd = snd * -10.dbamp;
	// snd = VALadder.ar(snd, freqMod, res, overdrive: 0.1, type:0);
	snd = DFM1.ar(snd, freqMod, res, 6.0, 0.0, 0.0003);
	snd = VADiodeFilter.ar(snd, freqMod2, res, overdrive:2);
	// snd = VadimFilter.ar(snd, freqMod, res, 0);
	// snd = VAKorg35.ar(snd, freqMod, res, 0);
	snd = DCompressor.ar(snd, 0, 0, 8, -50, 0.2, 100.1, 0.5, 1);
	// snd = AnalogTape.ar(snd, bias: 0.5, saturation: 0.1, drive: 0.1, oversample: 3, mode: 2);
	snd = snd * -10.dbamp;
};
) // VADiodeFilter + DFM1

~saw.play;

e = ();
e.saw = ~saw;
e.saw.play;

~dict = ('saw' : ~saw);
~dict[0].saw.stop;