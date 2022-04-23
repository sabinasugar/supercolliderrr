(
~buffers = Buffer.allocConsecutive(numBufs:10, server:s, numFrames:4096, numChannels:1, completionMessage:nil, bufnum:nil);
~wtArr = 10.collect({
  arg i;
  var numSegs = i.linexp(0,9,15,40).round;
  Env(
   [0]++({1.0.rand}.dup(numSegs-1) * [1,-1]).scramble++[0],

   {exprand(1,i.linexp(0,9,1,50))}.dup(numSegs),

   {[\sine,0,exprand(1,20) * [1,-1].choose].wchoose([9-i,3,i].normalizeSum)}.dup(numSegs)
  ).asSignal(1024);
});
 ~buffers.do({
    arg buf, i;
    buf.loadCollection(~wtArr[i])
  });
)

(
  SynthDef.new(\lpad, {
    arg buf=0, freq=1000, detune=0.2,
  amp=0.3, pan = 0.0, out = 0, rout = 0, rsend = (-20),
    atk = 0.1, dec = 0.1, sus = 1.0, rel = 1, curve = -4, gate = 1;
  var sig, env, detuneCtrl;
	env = EnvGen.ar(Env.adsr(atk, dec, sus, rel, curve: curve), gate,
   doneAction: 2
  );

  detuneCtrl = LFNoise1.kr(0.2!50).bipolar(detune).midiratio;
  sig = Osc.ar(buf, freq * detuneCtrl, {Rand(0,2pi)}!10);

  sig = Splay.ar(sig);
  sig = LeakDC.ar(sig);
  sig = Pan2.ar(sig, pan, amp);
  Out.ar(out, sig * env);
  }).add
)

~clock = TempoClock(1).permanent_(true);

(
~testInst = Pbindef(
	\pattern1,
	\instrument, \lpad,
	\dur, Prand([0.9, 0.7], inf),
	\legato, Pseq([0.2,0.3, 0.5, 0.7], inf),
	\atk, 6,
	\dec, 0.1,
	\sus, 0.4,
	\rel, 6,
	\curve, -5,
	\detune, Pwhite(0.05, 0.5, inf),
	\freq, Pseq([100, [200, 220, 240], 200, 40], inf),
	\amp, 0.8,
	\out, 0
).quant = 4;
)

~testInst.clear;
~testInst.play(~clock);

a = Synth(\lpad, [\freq, 100, \out, 0]);
a.set(\gate, 0);
