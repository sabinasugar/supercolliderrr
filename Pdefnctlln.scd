(Platform.userAppSupportDir +/+ "/boot.scd").load;

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


