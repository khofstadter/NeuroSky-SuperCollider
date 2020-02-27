// NFT
// -----------------------------------------------------
(
~beat = 32; //4-256;
~size = 10; //nb. of instruments/tracks (10)
~pathway = thisProcess.nowExecutingPath.dirname;
~pathname = (~pathway++"/sequencer/bars/").asString; //where saved files are kept;

(~pathway++"/rewardsystem/gui0.8.scd".asString).load;

(~pathway++"/sequencer/streams_midi_1.3.scd").load;
(~pathway++"/sequencer/load_save0.4.scd").load;
(~pathway++"/sequencer/tempoClock01.scd").load;

(~pathway++"/rewardsystem/ns_parser_1.05.scd".asString).load;
(~pathway++"/rewardsystem/levels04.scd".asString).load;
(~pathway++"/rewardsystem/island01/i_load.scd".asString).load;
(~pathway++"/rewardsystem/rewards0.58.scd".asString).load;

s.options.memSize = 1048576;
s.options.sampleRate = 44100;
s.latency = 0.01;
s.waitForBoot {
	(~pathway++"/sequencer/synths0.8.scd").load;
	i[0][0].reset.play;
};
);

SerialPort.devices;


