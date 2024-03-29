(
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
c = TempoClock(1).permanent_(true);
p = ProxySpace.push(s.boot, \proxyName, c);
p.quant = 4;
)

currentEnvironment;

p.playingProxies;
p.fadeTime = 5;
c.tempo_(1);


(
Window.closeAll;
w = Window("tab rcxn", Rect(958.0, 314.0, 341.0, 512.0), false, true)
.front
.alwaysOnTop_(true);
w.view.decorator_(FlowLayout(w.bounds, 19@10, 1@1));

n.clear;
n = ();
n.params = ["param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9", "param10"]; // parameter names

10.do{ | i |
	StaticText(w, Rect(10, 10, 300, 20))
	.string_(n.params[i])
	.font_(Font("Monaco", 10))
	.align_(\center);
	Slider(w, 300@25);
};

w.view.children[1]
.action_({ | obj |
	var value;
	value = obj.value.linlin(0, 1, 30, 200).postln;
	~proxyName.map(\name, value);
});

w.view.children[3]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 2, 2000).postln;
	~proxyName.map(\name, value);
});

w.view.children[5]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

w.view.children[7]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

w.view.children[9]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

w.view.children[11]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

w.view.children[13]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

w.view.children[14]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

w.view.children[15]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

w.view.children[17]
.action_({ | obj |
	var value;
	value = obj.value.linexp(0, 1, 0.1, 100).postln;
	~proxyName.map(\name, value);
});

m = ProxyMixer(p, 8);
m.parent.alwaysOnTop_(true);
ProxyMeter.addMixer(m);
)

(
n = Window("node tree", Rect(616.0, 292.0, 341.0, 512.0), true, true, s, true)
.front
.alwaysOnTop_(true);
s.plotTreeView(0.5, n);
)

n.close;

//// v2

(
Window.closeAll;
w = Window("tab rcxn", Rect(706.0, 275.0, 625.0, 165.0), false, true)
.front
.alwaysOnTop_(true);
w.view.decorator_(FlowLayout(w.bounds, 1@12, 10@10));

n.clear;
n = ();
n.params = ["param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9", "param10"]; // parameter names
n.actions = [
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~out.map(\freq, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
	{ | ez | var value; value = ez.value.linlin(0, 1, 30, 200).postln; ~proxyName.map(\param, value);},
]; // actions

10.do{ | i |
	EZSlider(w, 300@20, n.params[i], ControlSpec(0.0, 1.0), n.actions[i].postln, 0.0, labelWidth: 45)
	.font_(Font("Monaco", 10))
	.setColors(numBackground: Color.new255(42, 42, 42), numNormalColor: Color.new255(150, 150, 150)); // opt
};

)

w.view.children[1].children

n.actions[1]

~out = {SinOsc.ar(\freq.kr(44).lag(0.2), mul: 0.5)!2};
~out.play;
~out.free;