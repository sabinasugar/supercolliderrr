s.boot;

~b0 = Buffer.read(s, "/Users/ivainkalashnik/Documents/Wehlt/2-Audio 0001 [2021-11-06 114221].wav");

~b0.play;
~b0.free;

~b0.duration;
~b0.numFrames;
~b0.numChannels;
~b0.bufnum;
~b0.sampleRate;
~b0.query; // all


(
SynthDef.new(\Buf, {
	arg freq, buf, start, end, smooth, sendgain = 0.0;
	var run, sig, sawbuf, fftbuf, fftchain, mixer, masteramp, out, send;
	run = LPF.ar(LFDNoise1.ar(freq).range(start, end), smooth);
	sig = Pan2.ar(BufRd.ar(2, buf, run), 0.0, EnvGen.ar(Env.perc(0.03, 2, 1, -10)));
	fftbuf = FFT(Array.fill(2, { LocalBuf(2048, 1) }), sig);
	fftchain = PV_MagFreeze(fftbuf,LFNoise0.kr(1));
	fftchain = IFFT(fftchain);
	fftchain = MoogFF.ar(fftchain, XLine.kr(15000, 500, 2), 2, 0, 2);
	mixer = Mix([fftchain, sig * 0]);
	masteramp = EnvGen.ar(Env.perc(0.01, 7, 1, -10), doneAction: 2);
	out = Out.ar(0, mixer * masteramp);
	send = Out.ar(~freeverb.index, (mixer * masteramp) * sendgain);
}).add;
)

Synth.new(\Buf, [\buf, ~b0.bufnum, \freq, 0.02, \start, 0, \end, ~b0.numFrames, \smooth, 450, \sendgain, 0.3]);

~freeverb = Bus.audio(s,1);
~freeverb.index;

(
SynthDef.new(\FreeVerbSR, {
	arg room = 0.6, damp = 0.3, gain = 1.0;
	var input, reverb, output;
	input = In.ar(~freeverb.index, 1);
	reverb = FreeVerb.ar(input, 1.0, room, damp, 1, gain) ! 2;
	output = Out.ar(0, reverb);
}).add;
)

(
{

	inf.do {
		Synth.new(\Buf, [\buf, ~b0.bufnum, \freq, 0.02, \start, 0, \end, ~b0.numFrames, \smooth, 5000]);
		1.0.wait;
	};

}.fork;
)