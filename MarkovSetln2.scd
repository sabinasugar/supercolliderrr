(
a = MarkovSet([
	[1, [1, 2], [0.1, 0.9]],
	[2, [3, nil], [0.4, 0.6]]
], true);
a.makeSeeds;
a.asStream;
)

a.next;
a.reset;

(
b = Pfsm2(a, inf).asStream;
)
b.next;

(
b = Pfsm2(MarkovSet([
	[1, [1, 2], [0.1, 0.9]],
	[2, [3, 1], [0.4, 0.6]]
], true), inf).asStream;
)
b.next;

// interpolation MarkovSets in Alga ?

(
Server.killAll;
t = TempoClock(1).permanent_(true);
p = AlgaProxySpace.boot(clock: t);
p.interpTime = 5;
p.playTime = 0.1;
c = (); // TempoClock tracking
c.track = Tdef(\tempo, {
	loop {
		("tempo: " ++ t.tempo.asString).postln;
		1.wait;
	};
});
)

~a = (
	set:
	dur: Pfsm2(Pkey(\set), inf),

