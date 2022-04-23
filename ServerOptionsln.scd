s.quit;
s.options.numPrivateAudioBusChannels = 1024;
s.options.memSize = 8192 * 16;
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 16;
s.boot;
s.reboot;
"input:" + s.options.numInputBusChannels.postln;
"output:" + s.options.numOutputBusChannels.postln;