s.boot

~clock = TempoClock(1).permanent_(true);
~clock.beats;

(

SynthDef(\ads, { | tilt = 0.0, waveFocus = 0.0, oeRatio = 0.5, fModeMix = 0, linFund = 100, expFund = 5.0, linexp = 0.0, fScale = 1.0, fOffset = 0.0, atk = 0.001, dec = 0.1, sus = 1.0, rel = 0.1, curve = 0, gate = 1, out = 0, pan = 0.0, amp = 0.5 | // additive distributor
	var partialsNum, odd, reversedOdd, even, reversedEven, oddToeven, selectFix, waveShaper, lin, exp, rand, linToexp, linToexpMix, fDistr, ampDistr, phaseDistr, snd, env;

	partialsNum = 150; // fixed

	odd = [(1/Array.fill(partialsNum*2, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(partialsNum); // amps: 150 odd partials array
	reversedOdd = odd.reverse;
	odd = Array.interpolation(2, odd, reversedOdd);
	odd = SelectX.kr(tilt, odd);

	even = [(1/Array.fill(partialsNum*2, {arg count;
	count}).reject({arg item, i;
		item.odd}).put(0, 1)), [0]].lace(partialsNum+1); // amps: 150 even partials array
	even.removeAt(1);
	reversedEven = even.reverse;
	even = Array.interpolation(2, even, reversedEven);
	even = SelectX.kr(tilt, even);

	oddToeven = Array.interpolation(2, odd, even);

	waveShaper = SelectXFocus.kr(oeRatio, oddToeven, waveFocus).asArray; // waveFocus = 1.0 gives pure saw
	waveShaper = waveShaper.put(0, 1.0);

	lin = Array.fill(partialsNum, {arg index;
		(((index+1)*linFund)).postln});

	exp = Array.fill(partialsNum, {arg index;
		(((index+1)**expFund)).postln});

	rand = Array.rand(partialsNum, 20.0, 20000.0);

	linToexp = Array.interpolation(2, lin, exp);

	linToexpMix = SelectX.kr(linexp, linToexp);

	fDistr = Array.interpolation(2, linToexpMix, rand);
	fDistr = SelectX.kr(0.0 * fDistr.size, fDistr);

	ampDistr = waveShaper;

	phaseDistr = nil;

	snd = DynKlang.ar(`[fDistr, ampDistr, phaseDistr], fScale, fOffset);

	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel, curve: curve), gate, doneAction: 2);

	snd = snd * env;

	snd = Limiter.ar(snd);

	Out.ar(out, Pan2.ar(snd, pan, amp));

}).add;

)

~ads = Synth(\ads);
~ads.set(\fundFreq, 100, \linDistrNum, 50);

~pattern.reset;
~pattern.cleanup;

(
~pattern = Pbindef(
	\pattern,
	\instrument, \ads,
	\dur, 0.1,
	\legato, 0.05,
	\amp, 0.5,
	\atk, 0.001,
	\dec, 0.2,
	\sus, 0.1,
	\rel, [0.1, 0.1],
	\curve, [-9, -1],
	\oeRatio, 0.5,
	\waveFocus, Pseq([0.0, 1.0], inf),
	\linexp, [0.0, 1.0],
	\linFund, Pseq([Pseries(10, 50, 8), Pseries(100, 50, 16)], inf),
	\expFund, Pwhite(0.5, 10.0, inf),
	\tilt, 0,
	\amp, [0.2, 0.3]
).quant = 4;
)

~pattern.play(~clock);
~pattern.isPlaying;





(

~pattern = Pbindef(
	\pattern,
	\instrument, \ads,
	\dur, Pseq([Pseq([0.02], 16), 0.7], inf),
	\legato, 0.1,
	\amp, 0.5,
	\atk, Pseq([Pn(Pseries(0.1, -0.005, 16), 16), 0.001], inf),
	\dec, 0.1,
	\sus, 0.1,
	\rel, Pseq([Pn(Pseries(0.1, 0.1, 16), 16), 0.2], inf),
	\curve, -9,
	\linDistrNum, Pwhite(500, 600, inf),
	\expDistrNum, Pwhite(1.0, 7.0, inf),
	\oeRatio, 1,
	\tilt, Pwhite(0.0, 1.0, inf)
).quant = 4;

)

(
~pattern = Pbindef(
	\pattern,
	\instrument, \ads,
	\dur, 0.1,
	\legato, 0.7,
	\amp, 0.5,
	\atk, 0.001,
	\dec, 0.1,
	\sus, 0.9,
	\rel, 0.1,
	\curve, -9,
	\linDistrNum, Pseq([10, 120, 105], inf),
	\expDistrNum, Pseq([4.5 + Pn(Pseries(0, 0.1, 4), 1), 1 + Pn(Pseries(0.5, 0.1, 8), 1)], inf),
	\oeRatio, 0.7,
	\tilt, Pwhite(0.0, 0.1, inf)
).quant = 4;
)

~pattern.play(~clock);




// profiles

(

a = Array.fill(150, {arg index;
		(((index+1)*100))}); // lin harmonics distribution
Post << a;
a.size;

)

(

a = Array.fill(150, {arg index;
		(((index+1)**2))}); // exp harmonics distribution
a.postln;
a.size;

)


(

b = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(150); // odd particles amps
Post << b;

b.size;

)

(

b = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(150).reverse; // odd particles amps reversed
Post << b;

b.size;

)

(

b = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
	item.even}).put(0, 1)), [0]].lace(150).rotate(1); // rotating odd particles amps
Post << b;

b.size;

)

(
b = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(150); // odd particles amps
c = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
	item.odd}).put(0, 1)), [0]].lace(151); // even particles amps
c.removeAt(1);
d = b + c;
d.put(0, 1.0);
e = Array.interpolation(2, b, c);
Post << e;

c.size;

)

SelectX.kr(fModeMix, Array.fill(150, {arg index;
		(((index+1)*linDistrNum)).postln}));

rrand(pi ! 10, 2pi);

rrand(pi ! partialsNum, 2pi);