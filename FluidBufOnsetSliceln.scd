Bo.ot;

b = Buffer.read(s, "/Users/ivainkalashnik/Desktop/Audio_01/nuPg/— edit/2-Audio 0001 [2022-05-10 165413].wav");

(
~out = {
	var sig, onsets, env;
	sig = PlayBuf.ar(2, b, BufRateScale.ir(b) * LFNoise0.kr(0.4).range(0.8, 2.5), startPos: b.numFrames/5);
	onsets = FluidOnsetSlice.ar(sig, metric: 2, threshold: MouseX.kr(0.5, 100.0), minSliceLength: 2);
    sig = DelayN.ar(sig, 1, 1024 * SampleDur.ir); // compensate for a latency of windowSize samples
	env = sig * Env.perc(0.01, 0.2, curve: -15).kr(0, onsets);
	sig = FFT(LocalBuf(2.pow(17)).dup(2), sig);
	sig = PV_BinShift(sig, TRand.ar(1.0, 1.05, onsets).poll, 0.0, interp: 1);
	// sig = PV_Freeze(sig, onsets);
	sig = IFFT(sig);
	sig = sig * 3;
	// sig = Normalizer.ar(sig);
};
)

~out.play;

p.fadeTime = 2;

currentEnvironment;
p.pop;

~indices.numFrames;
~src.duration;

44100

Buffer


11.68 * 44100

(
{
    var gate_index = MouseX.kr(0,~indices.numFrames-1).poll(label:"slice index");
    var start = BufRd.kr(1, ~indices,gate_index,1,1);
    var end = BufRd.kr(1,~indices,gate_index+1,1,1);
    var phs = Phasor.ar(0,BufRateScale.ir(~src),start,end);
    BufRd.ar(1,~src,phs,1,4).dup;
}.play;
)

~src = Buffer.read(s, "/Users/ivainkalashnik/Documents/Storage/Okuch/All The Breaks/Lyn Collins - Think About It (Break 2).wav");

(
~indices = Buffer(s);
FluidBufOnsetSlice.processBlocking(s,~src,metric:9,indices:~indices,threshold:0.4,action:{
    "found % slice points".format(~indices.numFrames).postln;
    "with an average length of % seconds per slice".format(~src.duration / ~indices.numFrames).postln;
});
)

~indices.get(188, {|msg| msg.postln});

(
{ Array.fill(~indices.numFrames, { | i |
	var val;
	~indices.get(i, { | msg | val = msg });
	val;
});
};
)

(
~array = Array.zeroFill(~indices.numFrames);
~indices.numFrames.do({ | i | ~indices.get(i, { | msg | ~array.put(i, msg) }) });
)

Post << ~array;

Synth(\splayerf, [\sndbuf, ~src, \start, ~src.numFrames.rand]);

(
~px = Pbindef(
	\px,
	\instrument, \splayerf,
	\sndbuf, ~src,
	\rate, 1.2,
	\dur, Prand([Pn(0.2, 4), Pn(0.1, 2)], inf),
	\start, Prand([Prand(~array, 1), Pseq(~array, 1)], inf).trace, // Pfunc({ ~array.choose }).trace,
	\dec, Pif( Pkey(\dur) > 0.1, { 0.3/1.5 }, { 0.3 }),
	\sus, 0.0,
	\rel, 0.3
);
)

~px.play;

~src.numFrames;





a = Array.fill(~indices.numFrames, { | i | ~indices.get(i, { | msg | ~val = msg; }); ~val });





~indices.loadToFloatArray(index: 0, count: -1, action: { | a | ~indicesArray = a; });
~indicesArray.size;


~indices.numFrames;
~src.duration;
~indices.plot;

a = Array.newFrom(~indices);

Array.fill(~indices.numFrames, {

