(
SynthDef("help-PulseDivider",{ arg out=0;
    var p, a, b;
    p = Impulse.ar(8);
    a = SinOsc.ar(1200, 0, Decay2.ar(p, 0.005, 0.1));
    b = SinOsc.ar(600,  0, Decay2.ar(PulseDivider.ar(p, 6), 0.005, 0.5));

    Out.ar(out,(a + b) * 0.4)
}).play;
)



"the first value is %, and the second one is %, and the third is %".postf(1111, 9999, 9);

UGen.browse;

{({SinOsc.ar(4444.4.rand, 0, 0.005)}!500).sum}.play

{Saw.ar(MouseX.kr(100, 1000))}.freqscope
{LFSaw.ar(MouseX.kr(100, 1000))}.freqscope

(
f = {
        ({arg i;
                var j = i + 1;
                SinOsc.ar(300 * j, 0,  j.reciprocal * 0.5);
        } ! 30).sum // we sum this function 30 times
!2}; // and we make it a stereo signal
)

f.plot; // let's plot the wave form
f.play; // listen to it
f.freqscope; // view and listen to it


// we create a SynthDef
(
SynthDef(\oscsynth, { arg bufnum, freq = 440, ts= 1;
    a = Osc.ar(bufnum, freq, 0, 0.2) * EnvGen.ar(Env.perc(0.01), timeScale:ts, doneAction:2);
    Out.ar(0, a ! 2);
}).add;
)

// and then we fill the buffer with our waveform and generate the GUI
(
var bufsize, ms, slid, cspec, freq;
var harmonics;

freq = 220;
bufsize=4096;
harmonics=20;

b=Buffer.alloc(s, bufsize, 1);

x = Synth(\oscsynth, [\bufnum, b.bufnum, \ts, 0.1]);

// GUI :
w = Window("harmonics", Rect(200, 470, 20*harmonics+140,150)).front;
ms = MultiSliderView(w, Rect(20, 20, 20*harmonics, 100));
ms.value_(Array.fill(harmonics,0.0));
ms.isFilled_(true);
ms.valueThumbSize_(1.0);
ms.canFocus_(false);
ms.indexThumbSize_(10.0);
ms.strokeColor_(Color.blue);
ms.fillColor_(Color.blue(alpha: 0.2));
ms.gap_(10);
ms.action_({ b.sine1(ms.value, false, true, true) }); // set the harmonics
slid=Slider(w, Rect(20*harmonics+30, 20, 20, 100));
cspec= ControlSpec(70,1000, 'exponential', 10, 440);
slid.action_({
    freq = cspec.map(slid.value);
    [\frequency, freq].postln;
    x.set(\freq, cspec.map(slid.value));
    });
slid.value_(0.3);
slid.action.value;
Button(w, Rect(20*harmonics+60, 20, 70, 20))
    .states_([["Plot",Color.black,Color.clear]])
    .action_({    a = b.plot });
Button(w, Rect(20*harmonics+60, 44, 70, 20))
    .states_([["Start",Color.black,Color.clear], ["Stop!",Color.black,Color.clear]])
    .action_({arg sl;
        if(sl.value ==1, {
            x = Synth(\oscsynth, [\bufnum, b.bufnum, \freq, freq, \ts, 1000]);
            },{x.free;});
    });
Button(w, Rect(20*harmonics+60, 68, 70, 20))
    .states_([["Play",Color.black,Color.clear]])
    .action_({
        Synth(\oscsynth, [\bufnum, b.bufnum, \freq, freq, \ts, 0.1]);
    });
Button(w, Rect(20*harmonics+60, 94, 70, 20))
    .states_([["Play rand",Color.black,Color.clear]])
    .action_({
        Synth(\oscsynth, [\bufnum, b.bufnum, \freq, rrand(20,100)+50, \ts, 0.1]);
    });
)

(
SynthDef("manySines", {arg out=0;
    var sines, control, numsines;
    numsines = 20;
    control = Control.names(\array).kr(Array.rand(numsines, 400.0, 1000.0));
    sines = Mix(SinOsc.ar(control, 0, numsines.reciprocal)) ;
    Out.ar(out, sines ! 2);
}).add;
)

/*
Here we make an array of 20 frequency values inside a Control variable and pass this array to the SinOsc UGen which makes a "multichannel expansion," i.e., it creates a sinewave in 20 succedent audio busses. (If you had a sound card with 20 channels, you'd get a sine out of each channel) But here we mix the sines into one signal. Finally in the Out UGen we use "! 2" which is a multichannel expansion trick that makes this a 2 channel signal (we could have used signal.dup).*/


