("/boot.scd").loadRelative;

File.mkdir(PathName(thisProcess.nowExecutingPath).parentPath ++ "audio/");

// put files into audio/ directory manually or by code

(
a = ();
a.buf = ();
a.buf.path = PathName(thisProcess.nowExecutingPath).parentPath ++ "audio/";
PathName(a.buf.path).entries.collect({
	arg n,i;
	a.buf[i] = Buffer.read(s, n.fullPath);
});
)

p.playingProxies;
p.fadeTime = 5;