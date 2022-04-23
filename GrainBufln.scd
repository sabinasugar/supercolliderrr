(
s.boot;
MIDIClient.init;
MIDIIn.connectAll;
)

(
var windowenv, wbuffer;
~b1 = Buffer.readChannel(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/Synth Drum Machines/Cwejman S1/DevSnd Cwejman S1 - JK/DevSnd Cwejman S1 - JK Samples/Vactrol Acid.wav", 0, -1, 0);
windowenv = Env([0, 1, 0, 0], [0.01, 0.5, 0.5], -10);
wbuffer = Buffer.sendCollection(s, windowenv.discretize, 1);

SynthDef(\VactrolAcid, {
	arg rate, amp = 0.5;
	var grain, fft, filter, env;
	grain = GrainBuf.ar(1, // channels
		Impulse.kr(30), // trigger
		1, // grain size in secs
		~b1.bufnum, // sample buffer
		1, // rate
		LFSaw.kr(0.1), // pb position 0 = start, 1 = end
		4, // interpolation
		0, // pan
		wbuffer.bufnum, // grain envelope buffer
		100); // max grains
	fft = FFT(LocalBuf(2048), grain);
	fft = PV_MagShift(fft, MouseX.kr(0.1, 10, \exponential), 0.5);
	// fft = PV_RandComb(fft, 0., Impulse.kr(0.1));
	fft = IFFT(fft);
	filter = BLowPass4.ar(fft, MouseY.kr(20, 10000), 3.0).dup;
	env = EnvGen.ar(Env.perc(0.001, 3, 1.0, 0), doneAction: 2);
	Out.ar(0, filter * amp * env);
}).add;

MIDIdef.noteOn(\NoteOns, {
	arg vel, nn;
	[vel, nn].postln;
	Synth.new(\VactrolAcid, [\rate, nn.midicps, \amp, vel.linexp(1,127,0.01,0.3)]);
});
)


~b1.duration;
~b1.numFrames;
~b1.numChannels;
~b1.bufnum;
~b1.sampleRate;
~b1.query; // get all info
~b1.free;
Buffer.freeAll;


