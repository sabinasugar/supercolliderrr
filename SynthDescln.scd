SynthDescLib.new(\wehlt, s);

(
SynthDef("test", { arg out, freq, xFade;
    XOut.ar(out, xFade, SinOsc.ar(freq))
}).add(\wehlt);  // .store to store synth
);

SynthDescLib.global.browse;


(
SynthDef("test", {
			arg out, freq, xFade;
			XOut.ar(out, xFade, SinOsc.ar(freq));
}).writeDefFile("/Users/ivainkalashnik/Desktop", overwrite: true);  // to store synth on defined path
)

// .store(libname: 'global', dir, completionMsg, mdPlugin);
// Write the defFile and store it in the SynthDescLib specified by libname, and send a message to the library's server to load this file. When this asynchronous command is completed, the completionMessage (a valid OSC message) is immediately executed by the server. Default for libname is \global, for dir is synthdefs/. This is needed to use defs with the event stream system. See Streams and Pattern.

// SynthDesc.read(path, keepDefs: false, dict);
// Adds all synthDescs in a path to a dict. You should not use this method or *readFile to read SynthDescs into a SynthDescLib. Use SynthDescLib: read or SynthDescLib: readStream instead.