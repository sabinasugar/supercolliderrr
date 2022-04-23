(
a = LSys("F1F1F1", [
	"0<0>0" -> "0",
	"0<0>1" -> "1[+F1F1]",
	"0<1>0" -> "1",
	"0<1>1" -> "1",
	"1<0>0" -> "0",
	"1<0>1" -> "1F1",
	"1<1>0" -> "0",
	"1<1>1" -> "0",
	"+" -> "-",
	"-" -> "+"
], "+-F[]");

k = a.applyRules(30).postln;

LSPlant

	(

		argAngle: 22.5,

		argColor:

			{

				[

					Color.green(0.6.rand + 0.4),

					Color.gray(0.6.rand)

				].choose;

			}

	).drawSize_(4).draw(k);

)

(
~lsysTransform = {
	arg lsysList = [], nodesTransfromDict = Dictionary.new;
	var transformedList = List.new;

	lsysList.do({
		arg nodeItem;
		if (nodeItem.isCollection, {
			transformedList.add(~lsysTransform.value(lsysList: nodeItem, nodesToFreqDict: nodesTransfromDict));
		}, {
			var dictItem = nodesTransfromDict.at(nodeItem.asString);

			if (dictItem === nil, {
				transformedList.add(nodeItem);
			}, {
				transformedList.add(dictItem);
			}
			)
		}
		)
	});
	transformedList
}
)

(
var lsysTree, lsysTreeParsed, nodesToFreqDict;
lsysTree = LSys("F1F1F1", [
	"0<0>0" -> "0",
	"0<0>1" -> "1[+F1F1]",
	"0<1>0" -> "1",
	"0<1>1" -> "1",
	"1<0>0" -> "0",
	"1<0>1" -> "1F1",
	"1<1>0" -> "0",
	"1<1>1" -> "0",
	"+" -> "-",
	"-" -> "+"
], "+-F[]");
nodesToFreqDict = Dictionary.with(*["F" -> 200, "1" -> 400, "0" -> 200]);

lsysTreeParsed = lsysTree.applyRules(30);
lsysTreeParsed = lsysTree.giveParsedString;

~lsysTransform.value(lsysList: lsysTreeParsed, nodesTranfromDict: nodesToFreqDict);
)

~buffer = Buffer.alloc(s, 2048);
~buffer.sine3(freqs: ({exprand(0,75, 40)}!16).sort, amps: ({exprand(0,75, 40)}!16).sort.reverse, phases: {rrand(0,2pi)}!16, asWavetable: true);
{Osc.ar(~buffer, MouseX.kr(10,10000,1)*[1,2.01], mul: 0.2!2)}.play;

