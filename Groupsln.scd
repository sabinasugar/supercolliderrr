(
// a stereo version
SynthDef(\tutorial_DecaySin2, { arg outBus = 0, effectBus, direct = 0.5, freq = 440;
    var source;
    // 1.0.rand2 returns a random number from -1 to 1, used here for a random pan
    source = Pan2.ar(Decay2.ar(Impulse.ar(Rand(0.3, 1), 0, 0.125), 0.3, 1,
        SinOsc.ar(SinOsc.kr(0.2, 0, 110, freq))), Rand(-1.0, 1.0));
    Out.ar(outBus, source * direct);
    Out.ar(effectBus, source * (1 - direct));
}).add;

SynthDef(\tutorial_Reverb2, { arg outBus = 0, inBus;
    var input;
    input = In.ar(inBus, 2);
    16.do({ input = AllpassC.ar(input, 0.04, Rand(0.001,0.04), 3)});
    Out.ar(outBus, input);
}).add;
)

// now we create groups for effects and synths
(
~sources = Group.new;
~effects = Group.after(~sources);     // make sure it's after
~bus = Bus.audio(s, 2);         // this will be our stereo effects bus
)

// now synths in the groups. The default addAction is \addToHead
(
x = Synth(\tutorial_Reverb2, [\inBus, ~bus], ~effects);
y = Synth(\tutorial_DecaySin2, [\effectBus, ~bus, \outBus, 0], ~sources);
z = Synth(\tutorial_DecaySin2, [\effectBus, ~bus, \outBus, 0, \freq, 660], ~sources);

g = Group.new;
h = Group.head(g);        // add h to the head of g
x = Synth.tail(h, \default);    // add x to the tail of h
s.queryAllNodes;        // this will post a representation of the node hierarchy
x.free; h.free; g.free;


~sources.free; ~effects.free; // this frees their contents (x, y, z) as well
~bus.free;

s.queryAllNodes;  // When a server app is booted there is a special group created with a node ID of 0. This represents the top of the server's node tree. There is a special server abstraction object to represent this, called RootNode. In addition there is another group created with an ID of 1, called the default group. This is the default target for all Nodes and is what you will get if you supply a Server as a target. If you don't specify a target or pass in nil, you will get the default group of the default Server.

// In general you should add nodes to the default group, or groups contained within it, and not before or after it. When adding an 'effects' synth, for instance, one should resist the temptation to add it after the default group, and instead create a separate source group within the default group. This will prevent problems with scoping or recording.

// default group [
    source group [
        source synth1
        source synth2
    ]
    effects synth
]
recording synth

g = Group.new;

// make 4 synths in g
// 1.0.rand2 returns a random number from -1 to 1.
4.do({ { arg amp = 0.1; Pan2.ar(SinOsc.ar(440 + 110.rand, 0, amp), 1.0.rand2) }.play(g); });

g.set(\amp, 0.005); // turn them all down

g.free;