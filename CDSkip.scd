s.boot;
s.quit;
Bo.ot;

b = ();
b.buf = Buffer.read(s, "/Users/ivainkalashnik/Desktop/reamb2.wav");

(
~out[0] = Pbind(
	\instrument, \splayer,
	\dur, 5,
	\rel, 5,
	\atk, 5,
	\fScale, 0.7,
	\start, Pwhite(0.0, 1.0, inf).trace,
	\sndbuf, b.buf
);
)

SynthDescLib.global.browse;

~out.play;

(
~out[1] = \filter -> { | in |
	var snd;
	snd = in + CDSkip.ar(in, 0.05, 1, 0.2, freeze: 0, clean: 1);
	snd = FreeVerb2.ar(snd[0], snd[1], 0.2, 0.7, 0.7);
	snd = snd * 2;
};
)

~out.release(10);

p.fadeTime = 3;
p.quant = 0.1;