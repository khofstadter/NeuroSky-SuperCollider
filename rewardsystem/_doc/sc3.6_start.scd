//start
//ACROMIMS
//TH - threshold [integer ]
//TTH - time threshold [sec]
//ATT - attention [aTh - attention threshold]
//MED - mediation [mTh - mediation threshold]

(
"sc3.6_ns_parser_1.01.scd".loadRelative;
"sc3.6_gui0.1.scd".loadRelative;
"/Users/krisztianhofstadter/Dropbox/MA/alltogether00/sc3.6/sequencer/_start_gui_and_reward_0.4.scd".load;
"sc3.6_rewards0.52.scd".loadRelative;
"/island01/island_1.0.scd".loadRelative;
);

~comp = Synth(\compressor, addAction: \addToTail);


//to move between islands;
~manualMove = 1; //move up an islet
~manualMove = 2; //move back an islet
~manualMove = 3; //finish, move to islet 99


~constantSynth;
~constantSynth[0].isRunning;
~constantSynth[0] = Synth(\longpad, [ \change0, ~attention, \master, 0.5, \out, 0]).register;
~constantSynth[0].isPlaying;
~constantSynth[0].set(\master, 0.1);
~constantSynth;


//tempoChange
(
t = TempoClock(5); // create a TempoClock with no queue
t.schedAbs(t.nextBar, {t.beatsPerBar_(~beat)}); //bar will have ~beat nb of beats
t.play({arg beat; ( ~counter=(beat.round)%~beat);
~playTask.value.play; 1});
//1) make counter; 2)play ~playTask on every beat;
);

(
var temp = 5;
t.tempo_(temp);
)


//compressor
~comp = Synth(\compressor, addAction: \addToTail);
~comp.free;

//neurosky control
~smoothAttTask.play;
~smoothMedTask.play;
~sendOsc.play(AppClock);
~sendOsc.stop(AppClock);

~parser.stop;
~sP.close;
SerialPort.closeAll;
~smoothAttention.stop;
~smoothMeditation.stop;


~schedElasticLoopPlay[0] = ~schedElasticLoop.value(0).play;
~schedElasticLoopPlay[0].stop;

x = ~schedElasticOnce.value(7).play;

//random pattern generator
~write.value(0, 1, 0); //values: track; how many empty notes in an array
~write.value(2, 1, 10); //values: track; how many empty notes in an array

