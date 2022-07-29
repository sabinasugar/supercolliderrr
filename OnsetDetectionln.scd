b = Buffer.readChannel(s, "/Users/ivainkalashnik/Documents/1510/net and util.wav", channels:[0]);

//b= Buffer.read(s, Platform.resourceDir +/+ "sounds/break");

// Move the mouse to vary the threshold
(
SynthDef(\beat_track, {|bufnum= 0|
    var sig, chain, onsets, pips;
    sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum), loop: 1);
    chain = FFT(LocalBuf(512), sig);
    onsets = Onsets.kr(chain, MouseX.kr(0,1), \rcomplex);
	SendTrig.kr(onsets, id: 10, value: 1); // send trigger with value 1
	Out.ar(0 , sig);
}).add;
)

x= Synth(\beat_track, [\bufnum, b.bufnum]);

(
o = OSCFunc({ arg msg, time; // receive trigger
    [time, msg].postln; //msg[2] is id, msg[3] is value
    //trigger a synth to record or do something else from here
},'/tr', s.addr);
)

x.free;
o.free;