// SEQUENCER WITH GUI
// -----------------------------------------------------
(
~beat = 32; //4-256;
~size = 8; //nb. of instruments/tracks
~pathway = thisProcess.nowExecutingPath.dirname;
// ~pathname = (~pathway++"/sequencer/bars/psy2/").asString; //where saved files are kept;
~pathname = "/Users/tedor/Dropbox/PhD/Focus/Focus-loops/compulsive-music-wave03/"; //where saved files are kept;
//~pathname = (~pathway++"/sequencer/bars/").asString; //where saved files are kept;

//(~pathway++"/sequencer/streams_midi_1.3.scd").load;
(~pathway++"/sequencer/streams_midi_1.8.scd").load;
(~pathway++"/sequencer/generate_p0.6.scd").load;
(~pathway++"/sequencer/load_save0.4.scd").load;

// s.options.memSize = 1048576; //?
s.options.memSize= 65536;
s.options.sampleRate = 96000;
s.latency = 0.05;
s.waitForBoot {
	(~pathway++"/sequencer/synths0.91.scd").load;
	(~pathway++"/sequencer/tempoClock03.scd").load;
	(~pathway++"/sequencer/seq_gui2.2.scd").load;
	~main= Synth(\main, [], ~grp, \addAfter);

};
);


t.tempo_(~tempo[0]*(~tempo[1][c])); //change tempo








// -----------------------------------------------------
s.boot;
p[0];
p[1];

~tempo;


// midi needs to be off when sustain of note finishes.
// MIDI
MIDIClient.init;
~midi = MIDIOut.newByName("IAC Driver", "Bus 1");
~midi = MIDIOut.newByName("FireWire 410", "FireWire 410");
TempoClock
~midi.noteOn(0, 60, 127);
~midi.noteOn(1, 60, 60);
~midi.noteOn(0, 77, 100);
~midi.noteOn(1, 99, );
~midi.allNotesOff(1);