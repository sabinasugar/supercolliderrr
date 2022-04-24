(
m = ProxyMixer(p, 8);
m.parent.alwaysOnTop_(true); // show mixer in front of IDE
ProxyMeter.addMixer(m); // requires JITLibExtensions quark
n = Window("node tree", Rect(616.0, 292.0, 341.0, 512.0), true, true, s, true)
.front
.alwaysOnTop_(true);
s.plotTreeView(0.5, n);
)