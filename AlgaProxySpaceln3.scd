(
Server.killAll;
t = TempoClock(1).permanent_(true);
p = AlgaProxySpace.boot(clock: t);
p.interpTime = 5;
p.playTime = 2;
p.replacePlayTime = 0.1;
c = (); // TempoClock tracking
c.track = Tdef(\tempo, {
	loop {
		var prev;
		prev = t.tempo;
		0.25.wait;
		if ( t.tempo == prev, {}, { ("tempo: " ++ t.tempo.asString).post; Post.comma; Post.space; });
		0.25.wait;
	};
});
c.track.play;
)

c.track.stop;


Alga.interpolateTempo(tempo: 60/60, time: 5, delta: 0.05);


~out = { SinOsc.ar(\freq.kr(500)) * 0.6 };
~out.it = 5;
~out.pt = 5;
~out.play(2);
~out.stop(time: 10);
~out.reset(param: \freq, time: 5); // or
~out <| \freq;

~mod1 = { 100 + LFPulse.ar(SinOsc.kr(0.2).range(0.1, 100), mul: LFNoise1.kr(2).range(0.1, 400),)};
~mod1 >>.freq ~out;
~out.from(~mod1, \freq);

(
~comb = {
	var snd;
	snd = \in.ar(0);
	snd = CombC.ar(snd, 0.2, LFNoise2.kr(1).range(0.005, 0.2), 1.5);
	snd = snd * 0.5;
};
)

~out >>.in ~comb;
~comb.play(2);
~comb.stop(5);
~comb <| \in;


(
~a = (
	def: \playBuf,
	dur: 0.1,
	sndbuf: b.buf2,
	start: Pfunc({ | ev | ev.sndbuf.numFrames.rand }).trace,
	rate: 2,
	amp: -8.dbamp,
	rel: 0.8,
	leagto: 0.6,
	get: Pkey(\dur, inf), // yes it is possible
	fx: Prand([(
		def: \tube,
		in2: ~in2mod
	), \dry], inf)
);
)

~a.interpolateDur(0.4, time: 5);

~in2mod = { LFNoise1.kr(1).range(0.2, 0.9) };

~a.play;
~a.stop(10);




