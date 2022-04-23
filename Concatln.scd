b = Buffer.readChannel(s,"/Users/ivainkalashnik/Documents/1510/cm_test_live_v.wav", 0, -1, 1);
b.plot;
b.bufnum;
b.query;
b.numChannels;
b.numFrames;

c = Buffer.readChannel(s,"/Users/ivainkalashnik/Documents/1510/2-Audio 0001 [2021-10-15 014450].wav", 0, -1, 1);
c.plot;
c.bufnum;
c.query;
c.numChannels;
c.numFrames;
c.free;

(
{
var concat, control, input;

	control= Saw.ar(SinOsc.kr(10, 0, 10, MouseY.kr(12,100)));

input=PlayBuf.ar(1,b.bufnum,BufRateScale.kr(b.bufnum), loop:1);

concat= Concat.ar(control,input,1.0,0.01,5.0,MouseX.kr(0.1,0.5),0,MouseY.kr(0.1,1.0),0.1,2);

Out.ar(0,Pan2.ar(concat,0.0))}.play
)

(
SynthDef(\concatexample2, {arg freeze=0;
var concat, control, input, amp;

input= PlayBuf.ar(1,c.bufnum,BufRateScale.kr(c.bufnum), loop:1);

control= LFNoise0.ar(1, 1);

amp=Amplitude.ar(control);

concat= Concat.ar(control,input,5.0,5.0,5.0,MouseX.kr(0.0,0.3),freeze,MouseY.kr(0.0,0.5),0.5,2);

Out.ar(0,Pan2.ar(4*concat*amp,0.0))
}).add;
)

a=Synth(\concatexample2,[\bufnum, b.bufnum]);

a.set(\freeze, 1); //set this on or off to stay with a set of collected sounds

a.set(\freeze, 0); //set this on or off to stay with a set of collected sounds

a.free

(
SynthDef(\ConcateSeq, {
	arg envsust, envrel;
	var concat, control, input, env;
	control = PlayBuf.ar(1,c.bufnum,BufRateScale.kr(c.bufnum)+LFNoise1.kr(0.01,1), loop:1);
	input = PlayBuf.ar(1,b.bufnum,BufRateScale.kr(b.bufnum)+LFNoise1.kr(0.05,0.3), loop:1);
	concat = Concat2.ar(control,input,10.0,10.0,10.0,MouseX.kr(0.01,0.5), 0,MouseY.kr(0.0,5.0),0.5,0.5);
	env = EnvGen.ar(Env([0, 1, 1, 0], [0.01, envsust, envrel], -5), doneAction: 2);
	Out.ar(0,Pan2.ar(concat * env,0.0));
}).add;
)

(
{

	inf.rand.do {
		Synth(\ConcateSeq, [\envsust, 6.0.rand, \envrel, 0.1]);
		9.0.wait;
	};

}.fork;
)
