(
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
s.boot;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s, \proxyName, c);
p.quant = 4;
)

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