~clock = TempoClock(1).permanent_(true);
~clock.tempo_(1);
~clock.beats;

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
	)
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
