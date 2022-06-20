Rcxn.boot;

k = ();
k[1] = Bus.control(s, 1);
k = Array.fill(10, { Bus.control(s, 1) });
"10 control busses binded to k"

(
~ctl = {
	var sig;
	sig = SinOsc.kr(0.2).range(0.05, 0.5);
	Out.kr(k[1], sig);
};
~ctl.quant = 0;
)

(
~pattern = Pbind(
	\instrument, \test,
	\dur, Pfunc({
		k[1].getSynchronous({ |val|
			[val];
		});
	}).trace + 0.01
);
)