c = TempoClock(1).permanent_(true);
c.tempo;
c.beats;
c.isRunning;

p = ProxySpace(s, clock: c);
p.push; // jump into ProxySpace Environment
p.quant = 4;
p.pop; // exit ProxySpace and get back to default Environment

p.clear; // clear all proxies

currentEnvironment;

// or

(
s.boot;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s, \proxyName, c);
p.quant = 4;
)

p.playingProxies;
p.fadeTime = 5;


// store a buffer inside event collection (sub-class of environment)

Buffer.freeAll; // free all buffers for safe

e = ();
e.something = ();
e;
e.something.numbers = [3, 2, 1, 0];
e.something;
e.something.numbers[2];
// this way you can store buffers, numbers, everything you need

(
e = ();
e.buf = ();
e.buf.path = PathName(thisProcess.nowExecutingPath).parentPath ++ "audio/";
PathName(e.buf.path).entries.collect({
	arg n,i;
	e.buf[i] = Buffer.read(s, n.fullPath);
});
)

e.buf[5].play;
e.buf[2];

~out.clear;

(
SynthDef(\someSynth, {
	| sndbuf, rate = 1.0, startPos = 0.0, loop = 0, atk = 0.001, rel = 0.5, curve = -4, pan = 0.0, amp  = 1.0, out = 0 |
	var env, scaledRate, snd;
	env = EnvGen.kr(Env.perc(atk, rel, 1.0, curve), doneAction: Done.freeSelf);
	scaledRate = BufRateScale.ir(sndbuf) * rate;
	snd = PlayBuf.ar(
		numChannels: 1,
		bufnum: sndbuf,
		rate: scaledRate,
		trigger: 1.0,
		startPos: startPos,
		loop: loop,
		doneAction: 0);
	snd = snd * env;
	snd = Pan2.ar(snd, pan, amp);
	snd = Limiter.ar(snd);
	Out.ar(out, snd);
}).add;
)

(
SynthDef(\someSynth2, {
	| sndbuf, rate = 1.0, startPos = 0.0, loop = 0, atk = 0.001, rel = 0.5, curve = -4, pan = 0.0, amp  = 1.0, out = 0 |
	var env, scaledRate, snd;
	env = EnvGen.kr(Env.perc(atk, rel, 1.0, curve), doneAction: Done.freeSelf);
	scaledRate = BufRateScale.ir(sndbuf) * rate;
	snd = PlayBuf.ar(
		numChannels: 2,
		bufnum: sndbuf,
		rate: scaledRate,
		trigger: 1.0,
		startPos: startPos,
		loop: loop,
		doneAction: 0);
	snd = snd * env;
	snd = Pan2.ar(snd, pan, amp);
	snd = Limiter.ar(snd);
	Out.ar(out, snd);
}).add;
)

(
~out[0] = Pbind(
	\instrument, \someSynth,
	\dur, Prand([0.1, 0.4, 0.3], inf),
	\rate, Prand([Prand([1.5, 1.0, 1.5, 1.0], 6), Pn(~lfo, 1)], inf), // ~lfo (!)
	\startPos, Pwhite(0.0, 0.9, inf),
	\atk, 0.01,
	\legato, 0.1,
	\rel, 0.7,
	\curve, -5,
	\sndbuf, Prand(e.buf.asArray, inf),
	\amp, 1 * -5.dbamp
);
)

(
~out[1] = \filter -> { | in |
	var chain;
	chain = FFT(LocalBuf(512), in);
	chain = PV_MagFreeze(chain, LFClipNoise.kr(10));
	chain = IFFT(chain).dup;
	chain = Limiter.ar(chain);
};
)
~out.set(\wet1, 0.5);

(
~out[2] = \filter -> { | in |
	var chain;
	chain = FFT(LocalBuf(512), in);
	chain = PV_MagShift(chain, LFNoise1.kr(0.5).range(0.05, 4), LFNoise0.kr(2).range(-0.25, 1));
	chain = IFFT(chain).dup * 7.dbamp;
	chain = Limiter.ar(chain);
};
)

~out.set(\wet2, 0.3);


e.buf[5].asKeyValuePairs
~out.play;
~out.fadeTime = 4;
~out.stop;
~out.clear;

p.clear(5); // end and clear all nodes on p ProxySpace in 5 sec



~verb.play.fadeTime_(10);

(
~verb = {
	var snd;
	snd = FreeVerb.ar(\in.ar(0),
		mix: 1,
		room: 0.8,
		damp: 0.7);
	snd = Pan2.ar(snd, \pan.kr(0.0), \amp.ar(0.5));
	snd = Limiter.ar(snd);
};
)

~verb.fadeTime = 8;
~verb.xmap(\in, ~out);
~verb.unmap(\in);

~verb.stop;
~verb.clear;



~lfo = { LFNoise0.kr(1).range(0.5, 5.0) * 1 };
// no play
~lfo.fadeTime = 5;
~out.xmap(\rate, ~lfo);
~out.unmap(\rate);
~lfo.clear;


~out2.play;

(
~out2[0] = Pbind(
	\instrument, \someSynth2,
	\dur, Prand([2.0, 3.0, 1.2], inf),
	\rate, Prand([0.8, 0.9, 0.8, 0.8], inf), // ~lfo (!)
	\startPos, Pwhite(0.0, e.buf[5].numFrames, inf),
	\atk, 1,
	\legato, Pwhite(0.5, 1.0, inf),
	\rel, 3,
	\curve, -3,
	\sndbuf, e.buf[5].bufnum,
	\amp, 1 * 9.dbamp
);
)

(
~out2[1] = \filter -> { | in |
	var snd;
	snd = BLowPass4.ar(in, LFNoise1.ar(0.5).range(60, 17000).clip(70, 17000), 0.5) * 5;
	snd = snd.tanh;
	snd = Limiter.ar(snd);
};
)
~out2.set(\wet1, 0.8);
~verb.xmap(\in, ~out2);

(
~out2[2] = \filter -> { | in |
	var snd;
	snd = FFT(LocalBuf(2048), in);
    snd = PV_BinScramble(snd, MouseX.kr, 0.1, MouseY.kr > 0.5 );
    snd = IFFT(snd);
	snd = Limiter.ar(snd);
};
)

~out2.set(\wet2, 0.7);

(
~out2[3] = \filter -> { | in |
	var snd;
	snd = CombC.ar(in, 0.3, 0.24, 0.2) * 1.2;
	snd = Limiter.ar(snd);
};
)

~out2.set(\wet3, 0.3);