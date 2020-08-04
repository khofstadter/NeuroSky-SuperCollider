
fakeSignal= {
	var bus= Bus.control;
	~drunk= 0;
	SynthDef(\randomWalk, {|bus, freq= 1, cur= 3|
		Out.kr(bus, LFNoise2.kr(freq).lincurve(-1, 1, 0, 100, cur));
	}).add;
	s.sync;
	Synth(\randomWalk, [\bus, bus, \cur, 3, \freq, 0.4]);

	Routine.run({
		inf.do{
			~drunk= bus.getSynchronous;
			~drunk.postln;
			{~mySlider.value= ~drunk/100}.defer;
			0.03.wait;
		};
	});
};
