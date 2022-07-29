Bo.ot;

(
~interp = {
	var size, start, end, interp;
	size = 2;
	start = [0.0, 1.0, 2.0];
	end = [5.0, 6.0, 7.0];
	interp = SelectX.kr(MouseX.kr(0.0, 5.0), Array.interpolation(size, start, end));
};
)

a = "Array" ++ [".rand(5, 0.0, 1.0)", ".rand2(10, 10)"].choose;
a.interpret;

(
var    patternChoices = (
    up: { Pbind(\degree, Pseries(rrand(-4, 5), 1, rrand(4, 10)), \dur, 0.125) },
    down: { Pbind(\degree, Pseries(rrand(4, 11), -1, rrand(4, 10)), \dur, 0.125 * 4/3) }
);

p = Pspawn(Pbind(
    \pattern, Prand([\up, \down], inf),
    \delta, Pwhite(1, 5, inf) * 0.125,
    \method, \par
), (dict: patternChoices)).play;
)

Quarks.gui;

Quarks.install("https://github.com/musikinformatik/SuperDirt.git");
Quarks.install("Vowel");

