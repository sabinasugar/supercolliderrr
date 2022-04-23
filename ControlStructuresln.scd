(
~num = -6;
case
{~num == 0} {"WOW".postln}
{~num == 1} {"ONE!".postln}
{~num < 0} {"negative number!".postln} {true} {"last case scenario".postln}; )


if (expr, trueFunc, falseFunc);
// or
expr.if (trueFunc, falseFunc);

if ( [false, true].choose,                // Boolean expression (chooses one at random)
    { "expression was true".postln },    // true function
    { "expression was false".postln }    // false function
)

(
var a = 1, z;
z = if (a < 5, { 100 },{ 200 });
z.postln;
)

(
v = {
	var x;
if (x.isNil, { x = 99 });
	x.postln;
};
)

v.value;

Bag[1, 2, 3].add(4).postln;
Bag["abc", "def", "ghi"].add("jkl").postln;
Bag[1, 2, 3, 300].do({ arg item, i; item.postln });