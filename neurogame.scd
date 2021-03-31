(
Server.killAll;
s.options.memSize= 2.pow(20); // for mome memory allocation
s.options.numOutputBusChannels= 2;
s.options.numInputBusChannels= 0;
s.reboot;s.meter;
s.latency= 0.05;
s.waitForBoot {
	~beat=32;
	~pathway= thisProcess.nowExecutingPath.dirname;
	~pathname= (~pathway++"/sequencer/load-save/").asString;
	(~pathway++"/sequencer/streams-midi.scd").load;
	(~pathway++"/sequencer/generate.scd").load;
	(~pathway++"/sequencer/load-save.scd").load;
	(~pathway++"/neurogame/ns-parser.scd".asString).load;
	(~pathway++"/neurogame/levels.scd".asString).load;
	(~pathway++"/neurogame/island01/i-load.scd".asString).load;
	(~pathway++"/neurogame/rewards.scd".asString).load;
	(~pathway++"/sequencer/synths.scd").load;
	(~pathway++"/sequencer/tempoClock.scd").load;
	2.wait;
	(
		~compressor= Synth(\compressor, addAction: \addToTail);
		~main= Synth(\main, addAction: \addToTail);
		~autoMove=0;
		(~pathway++"/neurogame/gui.scd".asString).load;
		i[1][0].reset.play;
	);
};
);


SerialPort.listDevices;