e = ();
e.something = ();
e;
e.something.numbers = [3, 2, 1, 0];
e.something;
e.something.numbers[2];
// this way you can store buffers, numbers, everything you need

(
e = ();
e.buf = ();
e.buf.path = PathName(thisProcess.nowExecutingPath).parentPath ++ "audio/";
PathName(e.buf.path).entries.collect({
	arg n,i;
	e.buf[i] = Buffer.read(s, n.fullPath);
});
)

e.buf[5].play;
e.buf[2];

e.something = ();
e.something.numbers = [[3, 2, 1], [1, 2, 3], [0, 1, 7, 9]];
e.something.numbers.at(3.rand);
e.something[\numberrrs] = [[3, 2, 1], [1, 2, 3], [0, 1, 7, 9]];
e.something[\buf01] = Buffer.read(s, "/Users/ivainkalashnik/Desktop/SuperCollider Lectures/???/5trsampler/snd/clap.wav");
e.something[\numberrrs];
e.something;
e.something = ();
e.something = nil;

e.something[\buf01].play;
