(Platform.userAppSupportDir +/+ "/boot.scd").load;

(
~a = { FoaPanB.ar(SinOsc.ar(100) * -10.dbamp, MouseX.kr(-pi, pi), MouseY.kr(-0.5pi, 0.5pi), SinOsc.kr(5).unipolar(0.8))};
~a.play;
)

p.pop;

~a.channels;

// ------------------------------------------------------------
// virtual microphone stereo decoder
//
// mono pink noise source
// omni encoder


// define encoder / decoder matrices
~encoder = FoaEncoderMatrix.newOmni
~decoder = FoaDecoderMatrix.newStereo


// inspect
~encoder.kind
~encoder.numChannels
~encoder.dirChannels

~decoder.kind
~decoder.numChannels
~decoder.dirChannels.raddeg

(
{
    var sig;// audio signal
    var angle, azim;            // angle and azimuth control


    // display encoder and decoder
    "Ambisonic encoding via % encoder".format(~encoder.kind).postln;
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // angle ---> top     = push to plane wave
    //            bottom  = omni-directional
    angle = MouseY.kr(pi/2, 0);

    // azimuth -> hard left     = back
    //          centre     = centre
    //          hard right     = back
    azim = MouseX.kr(pi, -pi);


    // ------------------------------------------------------------
    // test sig
    sig = PinkNoise.ar;             // mono pink noise


    // ------------------------------------------------------------
    // encode
    sig = FoaEncode.ar(sig, ~encoder);

    // ------------------------------------------------------------
    // transform
    sig = FoaTransform.ar(sig, 'push', angle, azim);


    // ------------------------------------------------------------
    // decode (to stereo)
    FoaDecode.ar(sig, ~decoder);

}.scope;
)


PlayBuf.ar(2, Buffer.read(s, "/Users/ivainkalashnik/Desktop/Audio_01/OYOYO/- long/- filter.wav"), 1.0, 1.0, 0.0, 1.0);

~xx = SinOsc.;

// ------------------------------------------------------------
// UHJ (stereo) decoder
//
// mono pink noise source
// omni encoder


// define encoder / decoder matrices
~encoder = FoaEncoderMatrix.newOmni
~decoder = FoaDecoderKernel.newUHJ    // kernel decoders should be freed after use!!
                                    // free below...

// inspect
~encoder.kind
~encoder.numChannels
~encoder.dirChannels

~decoder.kind
~decoder.numChannels
~decoder.dirChannels.raddeg

(
{
    var sig;// audio signal
    var angle, azim;            // angle and azimuth control


    // display encoder and decoder
    "Ambisonic encoding via % encoder".format(~encoder.kind).postln;
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // angle ---> top         = push to plane wave
    //            bottom        = omni-directional
    angle = MouseY.kr(pi/2, 0);

    // azimuth -> hard left     = back
    //          centre     = centre
    //          hard right     = back
    azim = MouseX.kr(pi, -pi);


    // ------------------------------------------------------------
    // test sig
	sig = SinOsc.ar(200);             // mono pink noise


    // ------------------------------------------------------------
    // encode
    sig = FoaEncode.ar(sig, ~encoder);

    // ------------------------------------------------------------
    // transform
    sig = FoaTransform.ar(sig, 'push', angle, azim);


    // ------------------------------------------------------------
    // decode (to stereo)
    FoaDecode.ar(sig, ~decoder);

}.scope;
)

// free kernel
~decoder.free

// ------------------------------------------------------------

// stereo??



~encoder = FoaEncoderMatrix.newStereo
~decoder = FoaDecoderKernel.newUHJ    // kernel decoders should be freed after use!!
                                    // free below...

// inspect
~encoder.kind
~encoder.numChannels
~encoder.dirChannels

~decoder.kind
~decoder.numChannels
~decoder.dirChannels.raddeg

(
{
    var sig;// audio signal
    var angle, azim;            // angle and azimuth control


    // display encoder and decoder
    "Ambisonic encoding via % encoder".format(~encoder.kind).postln;
    "Ambisonic decoding via % decoder".format(~decoder.kind).postln;

    // angle ---> top         = push to plane wave
    //            bottom        = omni-directional
    angle = MouseY.kr(pi/2, 0);

    // azimuth -> hard left     = back
    //          centre     = centre
    //          hard right     = back
    azim = MouseX.kr(pi, -pi);


    // ------------------------------------------------------------
    // test sig
	sig = WhiteNoise.ar;             // mono pink noise


    // ------------------------------------------------------------
    // encode
    sig = FoaEncode.ar(sig, ~encoder);

    // ------------------------------------------------------------
    // transform
    sig = FoaTransform.ar(sig, 'push', angle, azim);


    // ------------------------------------------------------------
    // decode (to stereo)
    FoaDecode.ar(sig, ~decoder);

}.scope;
)



FoaPanB.ar(in, azimuth: 0, elevation: 0, mul: 1, add: 0);

// + FoaProximity.ar(in, distance: 1, mul: 1, add: 0)

// or FoaEncode.ar(in, FoaEncoderMatrix.newDirection(theta: 0, phi: 0), mul: 1, add: 0) + FoaDecoderMatrix.newStereo;

FoaEncode.ar(SinOsc.ar(100 + ((i+1)*10), 0.0, 1.0/(i+1)), FoaEncoderMatrix.newDirection(theta: rrand(pi, -pi), phi: rrand(pi/2, -pi/2)), mul: 1, add: 0)*0.5;

(
{
	var decoder, n, cluster;
	decoder = FoaDecoderMatrix.newStereo;
	n = 20;
	cluster = Mix.fill(n, { | i |
		var sin, angle, azim;
		sin = FoaEncode.ar(SinOsc.ar(MouseX.kr(10, 1000) + ((i+1)*1000.rand), 0.0, 1.0/n), FoaEncoderMatrix.newOmni, mul: 1, add: 0)*0.5;
		angle = MouseY.kr(pi/2, 0); // pi/2, 0
		azim = MouseX.kr(pi, -pi); // pi, -pi
		sin = FoaTransform.ar(sin, 'push', angle, azim);
		sin = FoaDecode.ar(sin, decoder);
	});
}.play;
)

// cannot modulate directions so next try to use .newOmni encoder with FoaTransform.ar(sig, 'push', angle, azim);

~encoder = FoaEncoderMatrix.newDirection(theta: 0, phi: 0);
~decoder = FoaDecoderMatrix.newStereo;