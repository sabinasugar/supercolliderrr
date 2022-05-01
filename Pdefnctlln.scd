(
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s.boot, \proxyName, c);
p.quant = 4;
m = ProxyMixer.small(p, 8);
m.parent.alwaysOnTop_(true);
ProxyMeter.addMixer(m);
)

(
c = Bus.control(s, 1);
d = SynthDef(\lfo, {
	Out.kr(c, MouseX.kr(0.002, 0.3));
}).play;

Tdef(\updateDur, {
  inf.do({
    c.get({|v|
      Pdefn(\dur, v);
    });
    0.1.wait;
  })
}).play;
)

(
Pdef(\foo, Pbind(
  \instrument, \default,
	\dur, Pdefn(\dur).trace,
  \degree, Pxrand((0..10), inf),
)).play;
)

Tdef(\updateDur).stop;
Pdef(\foo).stop;


