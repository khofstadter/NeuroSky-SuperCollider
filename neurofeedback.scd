(
Server.killAll;
s.options.memSize= 2.pow(20); // for mome memory allocation
s.options.numOutputBusChannels= 2;
s.options.numInputBusChannels= 0;
s.reboot;s.meter;
s.latency= 0.05;
s.waitForBoot {
	~pathway= thisProcess.nowExecutingPath.dirname;
	~pathname= (~pathway++"/sequencer/load-save/").asString;
	(~pathway++"/sequencer/streams-midi.scd").load;
	(~pathway++"/sequencer/generate.scd").load;
	(~pathway++"/sequencer/load-save.scd").load;
	(~pathway++"/rewardsystem/ns-parser.scd".asString).load;
	(~pathway++"/rewardsystem/levels.scd".asString).load;
	(~pathway++"/rewardsystem/island01/i-load.scd".asString).load;
	(~pathway++"/rewardsystem/rewards.scd".asString).load;
	(~pathway++"/sequencer/synths.scd").load;
	(~pathway++"/sequencer/tempoClock.scd").load;
	2.wait;
	(
		~main= Synth(\main, [], ~grp, \addAfter);
		~compressor= Synth(\compressor);
		~autoMove=0;
		(~pathway++"/rewardsystem/gui.scd".asString).load;
		i[0][0].reset.play;
	);
};
);