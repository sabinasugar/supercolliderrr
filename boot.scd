(
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s.boot, \proxyName, c);
p.quant = 4;
m = ProxyMixer.small(p, 8);
m.parent.alwaysOnTop_(true);
ProxyMeter.addMixer(m);
)

// boot.scd is supposed to be loaded like this: ("/boot.scd").loadRelative; for ProxySpace envir or: (Platform.userHomeDir +/+ "/Desktop/boot.scd").load; or: (Platform.systemExtensionDir +/+ "/boot.scd").load

Platform.classLibraryDir

Platform.systemExtensionDir