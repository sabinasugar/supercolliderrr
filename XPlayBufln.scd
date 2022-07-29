{ NTube.ar(XPlayBuf.ar(2, b, MouseY.kr(0.5, 2.0), 1.0, LFNoise2.kr(0.05).range(0.0, BufDur.ir(b)), LFNoise1.kr(0.2).range(0.0, 0.5).poll, 1, 0.5, 4) * 0.5, `[0.97,1.0,1.0,1.0,1.0,0.97],`[0.5,MouseY.kr(-1.0,1.0),0.2,-0.4],`([0.01,0.02,0.01,0.005,0.05]*MouseX.kr(0.001,1.0,'exponential'))) }.play;

b = Buffer.read(s, "/Users/ivainkalashnik/Music/SuperCollider Recordings/SC_220625_211442.aiff");

