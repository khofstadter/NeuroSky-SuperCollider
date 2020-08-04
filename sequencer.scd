// SEQUENCER WITH GUI
(
Server.killAll;
s.options.memSize=2.pow(20); // for mome memory allocation
s.options.numOutputBusChannels=2;
s.options.numInputBusChannels=0;
s.reboot;s.meter;
s.latency=0.05;
~beat=32; //4-256;
~size=8; //nb. of instruments/tracks
~pathway=thisProcess.nowExecutingPath.dirname;
~pathname=(~pathway++"/sequencer/load-save/").asString; //where saved files are kept;
(~pathway++"/sequencer/streams-midi.scd").load;
(~pathway++"/sequencer/generate.scd").load;
(~pathway++"/sequencer/load-save.scd").load;
s.waitForBoot {
	(~pathway++"/sequencer/synths.scd").load;
	(~pathway++"/sequencer/tempoClock.scd").load;
	(~pathway++"/sequencer/seq-gui.scd").load;
	2.wait;
	~main=Synth(\main,[],~grp,\addAfter);
};
);

// midi needs to be off when sustain of note finishes.
// MIDI
MIDIClient.init;
~midi=MIDIOut.newByName("IAC Driver", "Bus 1");
~midi=MIDIOut.newByName("FireWire 410", "FireWire 410");
TempoClock
~midi.noteOn(0, 60, 127);
~midi.noteOn(1, 60, 60);
~midi.noteOn(0, 77, 100);
~midi.noteOn(1, 99, );
~midi.allNotesOff(1);

p[0].size;