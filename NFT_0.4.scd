(
s.options.memSize= 65536;
s.options.sampleRate = 44100;
s.latency = 0.05;
s.waitForBoot {
~beat = 32; //4-256;
~size = 12; //nb. of instruments/tracks
~pathway = thisProcess.nowExecutingPath.dirname;
//~pathname = "../..Focus-loops/compulsive-music-wave01/"; //where saved files are kept;
~pathname = (~pathway++"/../../Focus-loops/test/").asString; //where saved files are kept;

//(~pathway++"/sequencer/streams_midi_1.3.scd").load;
(~pathway++"/sequencer/streams_midi_1.7.scd").load;
(~pathway++"/sequencer/generate_p0.6.scd").load;
(~pathway++"/sequencer/load_save0.4.scd").load;
(~pathway++"/rewardsystem/ns_parser_1.05.scd".asString).load;
(~pathway++"/rewardsystem/levels04.scd".asString).load;
(~pathway++"/rewardsystem/island01/i_load.scd".asString).load;
(~pathway++"/rewardsystem/rewards0.58.scd".asString).load;

(~pathway++"/sequencer/synths0.91.scd").load;
(~pathway++"/sequencer/tempoClock02.scd").load;
(~pathway++"/rewardsystem/gui0.8.scd".asString).load;
};
);
~main= Synth(\main, [], ~grp, \addAfter);
i[0][0].reset.play;



t.stop;
i[3][0].reset.play; //enter a new islet (here specified)