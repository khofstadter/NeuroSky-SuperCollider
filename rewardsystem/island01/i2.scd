i[2][0] = Routine {

	~makeTempoClock.value(1,16);

	~presentIslet = 2;
	"presentIslet 2".postln;

	~aThVal = 80;
	~mThVal = 80;
	~aTimeThVal = 10;
	~mTimeThVal = 10;

	~toMoveVal = [ [ 0, 4, 0, 0 ], [ 0, 2, 0, 0 ] ];

	// ON/OFF
	// ~playTask for ~sched : synths scheduled with tempoClock (t)
	~onOff = 0 ! 16; //all off

	// tracks used with ~sched
	~onOff[0] = 0;
	~onOff[1] = 0;
	~onOff[2] = 0;
	~onOff[3] = 0;
	~onOff[4] = 0;

	// tracks used with elastic schedules
	// tracks HAVE TO BE 0 otherwise the pattern will be played with ~shed (tempo Clock) as well.

	~onOff[5] = 0;
	~onOff[6] = 0;
	~onOff[7] = 0;
	~onOff[8] = 0;
	~onOff[9] = 0;

	// SYNTHS for Sched Loop and Elastic Loops
	~synth[0] = \simpleFM;
	~synth[1] = \nice1;
	~synth[5] = \FM1;
	~synth[6] = \FM2;

	// VOLUME
	// Adjust tracks volume individuly (arg master in synths)
	m = (0.0 ! 10); //m: master volume in SynthDefs
	m[0] = 0.5;
	m[1] = 0.5;
	m[5] = 0.1;
	m[6] = 0.2;




	// SYNTHS Constant
	~m2 = (0.0 ! 4); //m: master volume in SynthDefs
	~m2[0] = 0.5;
	~m2[1] = 0.5;
	~synth2[0] = \constantsynht1;
	~synth2[1] = \constantsaw;

	// LOAD PATTERN

	~loadFile.value(0, 200); //value: track, filename
	~loadFile.value(1, 200); //value: track, filename (MELODY eloop)
	~schedElasticLoopPlay[0] = ~schedElasticLoop.value(0).play;
	~schedElasticLoopPlay[1] = ~schedElasticLoop.value(1).play;

	1.wait;
	"enable eSenses".postln;//TODO

	1.wait;
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 303, 1).start;
	~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 301, 1).start;

	1.wait;
	~guiTask.start(AppClock);

};


i[2][1] = Routine {

	"Finish islet 1".postln;
	"move sliders back to 0".postln; //TODO
	"victory sound".postln; //TODO
	// kill rewCalc and rewTasks:
	~quitUsedTasks.value;
	// stop TempoClock and move to next location(islet)
	4.wait;
	t.stop;
	~schedElasticLoopPlay[0].stop;
	~schedElasticLoopPlay[1].stop;
	i[3][0].reset.play; //enter a new islet (here specified)

};