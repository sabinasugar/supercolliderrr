// Streams

7.next.postln;

(
var a;
a = FuncStream.new({ #[1, 2, 3, 4].choose });
5.do({ a.next.postln; });    // print 5 values from the stream
)

// Routines are functions that can return a value from the middle and then be resumed from that point when called again. The yield message returns a value from the Routine.

(
var a;
a = Routine.new({
        3.do({ arg i; i.yield; }) // what is i?
    });
4.do({ a.next.postln; });    // print 4 values from stream
)

(
var a, b;
// a is a stream that counts from 0 to 9
a = Routine.new({
        10.do({ arg i; i.yield; })
    });
b = a.squared;    // stream b is a square of the stream a
12.do({ b.next.postln; });
)

(
y = Routine({3.do({
		arg x; x.yield;
})});

	5.do({y.next.postln;
});
)

// Patterns

// a Routine vs a Pattern
(
    a = [-100, 00, 300, 400];            // the array to iterate

    p = Pseq(a);                    // make the Pattern
    q = p.asStream;                    // have the Pattern make a Stream
    r = Routine({ a.do({ arg v; v.yield}) }) ;    // make the Stream directly

    5.do({ Post << Char.tab << r.next << " " << q.next << Char.nl; });
)

