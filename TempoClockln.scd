(
~clock = TempoClock(150/60);
~clock.permanent_(true);
)

"current beats" + ~clock.beats;
"current bar" + ~clock.bar; // .beatsPerBar - sets the number of beats per bar. The default is 4.
~clock.schedAbs(~clock.beats.ceil, { arg beat, sec; [beat, sec].postln; 1 });

(
~postBeats = {~clock.beats.postln; 1};
~clock.schedAbs(~clock.nextBar, {~postBeats.value});
)
~postBeats = {} // stop

~clock.tempo_(1);
~clock.stop;