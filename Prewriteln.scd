// this works:

// A generative song
(
// Scale degrees going up
Pdefn(\a, Pseq((20,30..50), 1));
​
// Scale degrees going down
Pdefn(\b, Pseq((40,50..70), 1));
​
// Random scale degrees
Pdefn(\c, Pxrand((70,80..100), 8));

​
// Use the L-system to put together a sequence of keys
// Psym will then retrieve the patterns from the global Pdef dictionary
// See the post window for info about which of these are playing
Pdef(
	\pat,
	Pbind(
	\instrument, \default,
	\freq, Pnsym(
    Prewrite(\a, // start with pattern \a
        (
            \a: [\a, \a, \b],
            \b: [\c, \a],
            \c: [\a, \c],
    ), 8).trace
),
	\dur, 0.3
	)
).play;
)

Pbindef(\pat, \dur, 0.3);

(
a = Pseq([73, 71, 69], 2);
b = Pseq([0, 0, 0, 4, 0]+64);
c = Pswitch([a, b, 75], Pseq([2, 2, 2, 2], inf));
x = c.asStream;
Routine({
    loop({
        Synth(\help_sinegrain, [\freq, x.next.midicps]);
        0.18.wait;
    })
}).play;
)

// pswitch driven by prewrite (?) for use in pbindefs (?)

(
~one = Pseq([15,95,112],1);
~two = Prand([125,95,112],2);
~three = 40;

Pbindef(\pat2,
	\instrument, \default,
	\freq, Pswitch([~one,~two,~three, Pseq([32,75],8)], Prewrite(0,
	(
		0: [0, 1, 2, 3],
		1: [3, 3],
		2: [2, 0]
), 4).trace),
	\dur, Pswitch([0.2, 0.3, 0.3/3, 0.5], Prewrite(0,
	(
		0: [0, 1, 2, 3],
		1: [3, 3],
		2: [2, 0]
), 4).trace),
).play;
)

// yes!


// note: to check if a Pkey's result /equals/ another value,
// be sure to use |==|

p = Pbind(
    \a, Pseries(1, 1, inf),
    \b, Pif(
        Pkey(\a) |==| 2,
        "equals 2",
        "nope"
    )
).asStream;

p.next(());  // 'b' is always "nope"

(
p = Pbindef(
	\patz,
    \a, Pseries(1, 1, inf),
    \b, Pif(
        Pkey(\a) > 5,
		Pseq([1,2,3], inf),
        "nope"
    )
).asStream;
)

p.next(());  // 'b' is as expected

(
Pbindef(\patz).clear;
Pbindef(
	\patz,
	\instrument, \test,
    \a, Pseries(1, 1, inf),
	\dur, Plet(\patzdur, Pif(
        Pkey(\a) > 5,
		Pseq([0.1,0.2,0.4,0.4, 0.4], inf),
        0.6
	)).trace
).clock(~clock);
)


(
Pbindef(\patz,
	\dur, Pif(
        Pkey(\a) > 5,
		Pseq([0.1,0.2,0.4,0.4, 0.1].scramble, inf),
	0.6)
).clock(~clock);
)

// kak load key v pkey from another pbindef's key (?)

(
Pbindef(\patx,
	\instrument, \default,
	\freq, Pif(Pget(\patzdur, 50, repeats: inf) == 0.4,
	Pseries(20,10,inf),
	Pseries(120,-10,inf)
	).trace
).clock(~clock);
)

~clock = TempoClock(1).permanent_(true);
~clock.tempo_(1);


(

~patz = Pbindef(
	\patz,
	\instrument, \test,
	\a, Pseries(1, 1, inf),
	\dur, Plet(\network,
		Pif(
		Pkey(\a) > 4,
		Pseq([0.1, Rest(0.1), 0.4, 0.2, 0.4, 0.6, Rest(0.1), 0.2], inf), // true
		0.5) // false
	),
	\legato, Pget(\legatox, repeats: inf).linlin(0.05, 1.0, 1.0, 0.05)
);

~patx = Pbindef(
	\patx,
	\instrument, \default,
	\freq, Pif(Pget(\network, repeats: inf) >= 0.4,
		Pn(Pseries(800, 50, 6), inf), // true
		Pn(Pseries(500, -50, 4), inf)), // false
	\dur, Pif(Pget(\network, repeats: inf).trace >= Rest(0.1),
		Pn(Pseries(0.05, 0.01, 16), inf), // true
		Pn(Pseries(0.3, -0.01, 4), inf)), // false
	\legato, Plet(\legatox, Pseq([0.05, 0.1, 0.5, 1.0], inf))
);
)

(
~dnosadfs = Plambda(
	Ppar(
		[
		~patz,
		~patx
	], inf),
).asEventStreamPlayer;
)

~dnosadfs.play(~clock, quant:8);
" ~dnosadfs is playing: " + ~dnosadfs.isPlaying;
~dnosadfs.pause;
~dnosadfs.resume(quant:8);

(
Pbindef(\patz, \dur, Plet(\network, Pif(
				Pkey(\a) > 5,
				Pseq([0.1,0.2,0.9,0.1, 0.4, 0.2, 0.2, 0.2], inf),
				0.6
			)));
)



(
Pbindef(\patz).clear;
Pbindef(\patx).clear;
)
