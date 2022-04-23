
(
x = 1/Array.fill(300, {arg index;
	index}).reject({arg item, i;
	item.even});
)
y = x.reverse;


(
Array.fill(150, {arg index;
	((index.reciprocal).odd.postln)});
)


(
SynthDef(\test1, {
	arg fundamental = -50;
	var lagsaw, partials, revpartials, lohifade, filter;
	lagsaw = LFSaw.kr(MouseX.kr(0.1, 5));
	partials = DynKlang.ar(`[Array.fill(150, {arg index;
	(fundamental + (((index+1)*100))).postln}) + Array.fill(150, { arg i; i.rand * MouseY.kr(0.0, 200)}), // freq distribution
		1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}), // 1/even index for partial amps
		Array.fill(150, { 0.1.rand})], MouseX.kr(0.1, 2.0)).tanh;

	revpartials = DynKlang.ar(`[Array.fill(50, {arg index;
	(fundamental + (((index+1)*100))).postln}) + Array.fill(50, { arg i; i.rand * MouseY.kr(0.0, 100)}), // freq distribution
		(1/Array.fill(100, {arg count;
	count}).reject({arg item, i;
		item.even})).reverse, // 1/even index for partial amps
		Array.fill(50, { 0.1.rand})], MouseX.kr(0.1, 2.0))/6;

	lohifade = SelectX.ar(LinLin.kr(lagsaw, -1, 1, 0.0, 0.5), [partials, revpartials]); // lo-hi instances filter
	filter = MoogFF.ar(lohifade, Lag.kr(LinLin.kr(lagsaw, -1, 1, 100, 15000), 0.05), 2, mul: 0.5).tanh;
	Out.ar(0, Pan2.ar(filter, 0.0, 0.5));
}).add;
) // 150 partials

Synth(\test1)

Array.interpolation(150, 1, 5);

(
SynthDef(\test2, {
	var even, odd, evenpartials, oddpartials;

	even = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
	item.odd}).put(0, 1)), [0]].lace(151);
	even.removeAt(1);
	even;
	evenpartials = DynKlang.ar(`[[Array.fill(150, {arg index;
		(((index+1)*100)).postln})],
	even, nil]);
	odd = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(150);
	oddpartials = DynKlang.ar(`[[Array.fill(150, {arg index;
		(((index+1)*100)).postln})],
	odd,
	nil]);

	Out.ar(0, Pan2.ar(evenpartials, 0.0, 0.5));
}).add;
) // not working

Synth(\test2)


[0, 1, 2] * 2
[1, [1, 2]*2] * 2
Bag.fill(14, { arg i; i.rand });
[1,2].put(0, 2);

(
(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)).postln;
Array.fill(150, {arg index;
		(((index+1)*100))}).size;
)


[[1, 0.5, 0.25],[0]].lace(6);

(
x = [(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
	item.odd}).put(0, 1)), [0]].lace(151);
x.removeAt(1);
x.postln;
x.size;
) // 150 even partials array

Array.interpolation(10, [3.2, 1.1], [20.5, -10.0]);

(
[(1/Array.fill(300, {arg count;
	count}).reject({arg item, i;
		item.even}).put(0, 1)), [0]].lace(151)
)