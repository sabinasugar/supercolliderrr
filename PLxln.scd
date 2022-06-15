

(
p = Pn(Plazy { Pseq(~a, 1) });

~a = (60..70);

x = Pbind(
    \midinote, p,
    \dur, 0.2
).play;
)

~a = (75..84) ++ Pseq([85,86], 10);

~a[10] = 91;

(
p = Pbind(
    \midinote, PLseq(\a),
    \dur, 0.2
);

~a = (60..70);

y = p.play;
)

~a = (75..84) ++ Pseq([85,86], 10);

~a = Pseq([85,86,88], 4).asArray ++ Pseq([50, 85, 56], 2); // need to be .asSequenceableCollection


(
p = PLseq(\a);

~a = [
    Pbind(
        \midinote, Pwhite(60, 65, 3),
        \dur, 0.2
    ),
    Pbind(
        \midinote, Pwhite(80, 85, 3),
        \dur, 0.2
    )
];

x = p.play;
)
(
// LFO defined as Function

f = { |x| (x * 2).sin * 3 + (x * 0.3).sin };

p = Pbind(
    \dev, Ptime().collect(f), // current time passed to function
	\midinote, Pkey(\dev) + 60 + (0..64),
    \amp, 0.05/5,
    \dur, 0.15
).play;
)  // maybe use plx suite for real-time additive synthesis with pl patterns gui (?)