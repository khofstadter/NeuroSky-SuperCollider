~is[2][0] = {

	~presentIslet = 2;
	"enter islet 2".postln;
	~makeTempoClock.value(5,16);
	"initialise thresholds, tracks, synths".postln;

	~aThVal = 75; //attention threshold value
	~mThVal = 80; //meditation threshold value
	~aTimeThVal = 10; //for how many sec the signal shall be above a threshold
	~mTimeThVal = 10; //for how many sec the signal shall be above a threshold

	// needed rewardPoints to move to next islet :
	~toMoveVal = [ [ 0, 3, 1, 0 ], [ 0, 0, 2, 0 ] ];

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


	//schedule elasticloops
	//they are not effected by EEG
	t.schedAbs(t.nextBar+~beat, {

		~schedElasticLoopPlay[0] = ~schedElasticLoop.value(0).play;
		~schedElasticLoopPlay[1] = ~schedElasticLoop.value(1).play;

	});


	//start new reward calulation task and reward tasks
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 303, 1).start;
	~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 301, 1).start;


	~guiTask.start(AppClock);

};

// ---------------------------------------------------------------------------------------------

~is[2][1] = {

	"Finish islet 2".postln;
	"hallo".postln;
	"move sliders back to 0".postln; //TODO
	t.sched(0, { "victory sound".postln }); //TODO
	// kill rewCalc and rewTasks:
	t.sched(1, { ~quitUsedTasks.value; });
	// fade out ConstantSynts:
	// stop TempoClock and move to next location(islet)
	t.sched(5, {
		t.stop;
		~is[3,1]; //enter a new islet (here specified)
});


};