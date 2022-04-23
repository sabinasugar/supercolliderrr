w = Window.new;
w.front;
w.alwaysOnTop;
w.alwaysOnTop = true; // or
w.alwaysOnTop_(false);

w.close;

(
w = Window.new("GUIln", Rect.new(500, 400, 400, 400), resizable: false, border: true, s, scroll: false)
.front
.alwaysOnTop_(true);
)

w.close;

GUI.current;

Window.closeAll;

w.bounds; // dimensions
w.bounds_(Rect.new(500, 400, 400, 400));

Window.screenBounds; // screen dimensions

(
w = Window.new("GUIln",
	Rect.new(
		Window.screenBounds.width/2 - 200, // subtract half the size of the width and height of the window
		Window.screenBounds.height/2 - 200,
		400,
		400),
	resizable: false,
	border: true,
	server: s,
	scroll: false)
.front
.alwaysOnTop_(true);
) // centered window

(
Window.closeAll;
w = Window("GUIln", Rect.new(500, 400, 400, 65), resizable: false, border: true, server: s, scroll: false)
.front
.alwaysOnTop_(true);

~slider = Slider(w.view, Rect(20, 20, 360, 25));
)

w.view.children;
~slider.parent; // hierarchy
~slider.visible_(true);
~slider.enabled_(true);

~slider.remove; // destroy slider object

~slider.value;
~slider.value_(0.4);
~slider.action_({"slider moved".postln});

(
~slider.action_({
	arg obj;
	w.view.background_(Color(obj.value*0.2 + 0.5, obj.value*0.8, obj.value*0.7, 1.0));
	obj.value.postln;
});
)

~slider.valueAction_(rrand(0.0, 1.0));

~slider.background;
~slider.background_(Color.rand);
~slider.knobColor_(Color.rand);
~slider.thumbSize_(50);

w.view.background_(Color.rand);

// ------------------------

s.boot;

(
SynthDef(\GUIln, { | freq = 440, amp = 1.0 |
	var snd;
	snd = PinkNoise.ar(1)!2;
	snd = BPF.ar(snd, freq, 1.0); // rates or adjust .lag(0.5) for xfading and avoiding pop clicks
	Out.ar(0, Pan2.ar(snd, 0.0, amp));
}, [0.1, 0.5]).add;
)

(
Window.closeAll;
w = Window("GUIln", Rect.new(500, 400, 411, 65), resizable: false, border: true, server: s, scroll: false)
.front
.alwaysOnTop_(true);

~slider = Slider(w.view, Rect(20, 20, 297, 25))
.action_({ | obj |
	var cf;
	cf = obj.value.linexp(0, 1, 100, 4000).postln;
	if(
		x.isPlaying,
		{x.set(\freq, cf)} // for watching if the node exists for avoiding error messages while dragging slider
	);
	~numberBox.value_(obj.value.linexp(0, 1, 100, 4000));
});

~numberBox = NumberBox(w, Rect(325, 20, 30, 25))
.value_(100)
.clipLo_(100)
.clipHi_(4000)
.font_(Font("Monaco", 10))
.align_(\center)
.decimals_(0)
.action_({ | obj |
	~slider.valueAction_(obj.value.linexp(100, 4000, 0, 1))
});

~button = Button(w.view, Rect(360, 20, 30, 25))
.states_([
	["on", Color.black, Color.new255(219, 219, 219)],
	["off", Color.white, Color.new255(42, 42, 42)]
])
.font_(Font("Monaco", 10))
.action_({ | obj |
	if(
		obj.value == 1,
		{x = Synth(\GUIln, [\freq, ~slider.value.linexp(0, 1, 100, 4000)]).register}, // nodeWatcher
		{x.free}
	);
});

~text1 = StaticText(w, Rect(190, 0, 30, 21))
.string_("ffreq")
.font_(Font("Monaco", 10))
.align_(\center);
)

x = Synth(\GUIln, [\freq, ~slider.value.linexp(0, 1, 100, 4000)]);

// focusing
// tab to switch
// r random
// c center
// x maximum
// n minimum

// decorator trick + ProxySpace test

(
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
s.reboot;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s, \proxyName, c);
p.quant = 4;
)

currentEnvironment;

p.playingProxies;
p.fadeTime = 5;
c.tempo_(1);


(
Window.closeAll;
w = Window("proxyControl1", Rect(550.0, 306.0, 341.0, 512.0), false, true)
.front
.alwaysOnTop_(true);
w.view.decorator_(FlowLayout(w.bounds, 19@10, 1@1));
n.clear;
n = ();
n.params = ["param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9", "param10"]; // parameter names
10.do{ | i |
	StaticText(w, Rect(10, 10, 300, 20)).string_(n.params[i]).font_(Font("Monaco", 10)).align_(\center);
	Slider(w, 300@25);
};

w.view.children[1]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 100, 4000).postln; // linlin for linear distribution
	x.set(\freq, value);
});

)

w.view.children[1].value_(0.5);
Window.allWindows;
w.fullScreen;

x = Synth(\GUIln, [\freq, w.view.children[1].value.linexp(0, 1, 100, 4000)]);


(
~out = {SinOsc.ar(\freq.kr(300).lag(0.5) + (LFPulse.ar(\freq2.kr(20).lag(0.5)) * \fm.kr(0.1).lag(0.5)))!2 * 0.5};

Window.closeAll;
w = Window("proxyControl1", Rect(550.0, 306.0, 341.0, 512.0), false, true)
.front
.alwaysOnTop_(true);
w.view.decorator_(FlowLayout(w.bounds, 19@10, 1@1));
n.clear;
n = ();
n.params = ["param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9", "param10"]; // parameter names
10.do{ | i |
	StaticText(w, Rect(10, 10, 300, 20)).string_(n.params[i]).font_(Font("Monaco", 10)).align_(\center);
	Slider(w, 300@25);
};

w.view.children[1]
.action_({ | obj |
	var value;
	value = obj.value.linlin(0, 1, 30, 200).postln;
	~out.map(\freq, value);
});

w.view.children[3]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 2, 2000).postln;
	~out.map(\freq2, value);
});

w.view.children[5]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~out.map(\fm, value);
});

)

~out = {SinOsc.ar(\freq.kr(300).lag(0.5).fold(SinOsc.ar(\freq2.ar(30))) + (LFPulse.ar(\freq2.kr(20).lag(0.5)) * \fm.kr(0.1).lag(0.5)))!2 * 0.5};

~out.play;

(
m = ProxyMixer(p, 8);
m.parent.alwaysOnTop_(true); // show mixer in front of IDE
)


~out2 = { (LFNoise1.ar(3)!2) + (\in.kr(0)*0.5)};
~out2.map(\in, ~out);

p.playingProxies;
p.clear;






