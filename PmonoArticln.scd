s.boot;

(
SynthDef(\bup, {
	arg out=0,freq=440,ffreq=440,famp=1,fq=1,
	    fatk = 0.01, fdec = 0.1,
	    aatk = 0.01, adec = 0.1,
	    amp=0.5,gate=1, len=0.2,lag=0.1;

	var synth,ampEnv,filtEnv;

	filtEnv = EnvGen.kr(
		       Env.adsr(fatk,fdec,releaseTime:0.05),
                       gate,
		       freq*famp,
		       ffreq);
	ampEnv = EnvGen.kr(
		       Env.adsr(aatk,adec,releaseTime:0.05),
		       gate,
                       doneAction:2);
	synth = Mix.new([
		LFSaw.ar(Lag.kr([freq*2,freq],lag),[0,pi],amp),
		LFTri.ar(Lag.kr([freq,freq*2],lag),[pi,0],amp)
	]);
	synth = Pan2.ar(synth) * ampEnv;
	synth = RLPF.ar(synth,filtEnv,fq);
	Out.ar(out,synth);
}).add;
)
TempoClock.default = TempoClock.new(120/180);
(
p=PmonoArtic(
	\bup,
	\dur,Pseq((0.25!3)++(0.125!2),inf),
	\ffreq, Pseq([1,2,3,4,5]*500,inf),
	\fq,    Pseq([2,2,1,1,1,2,1,1,0.65,0.52],inf),
	\legato, Pseq([0.3,1,0.83,1],inf),
	\degree, Pseq([0,2,4,7,9]+.t[0,4,9],inf),
	\scale, Scale.dorian,
	\octave, Pseq([1,3]+.t[0,2],inf),
	\mtranspose, Pseq((0!20)++(2!20)++(4!20)++(5!20),2)
).play;
)