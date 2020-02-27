i[3][0] = Routine {

	~makeTempoClock.value(3,16);

	~presentIslet = 3;
	"presentIslet 3".postln;

	~aThVal = 75;
	~mThVal = 75;
	~aTimeThVal = 10;
	~mTimeThVal = 10;

	~toMoveVal = [ [ 0, 5, 2, 0 ], [ 0, 2, 2, 0 ] ];

	// ON/OFF
	// ~playTask for ~sched : synths scheduled with tempoClock (t)
	~onOff = 0 ! 16; //all off

	// tracks used with ~sched
	~onOff[0] = 0;
	~onOff[1] = 0;
	~onOff[2] = 1; //open for ~usedTasks[3] is above TH
	~onOff[3] = 1; //open for ~usedTasks[4] is above TH
	~onOff[4] = 0; //open for ~usedTasks[5] is above TH

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
	~synth[2] = \windX;
	~synth[3] = \simpleFM;
	~synth[4] = \simpleFM;
	~synth[5] = \FM1;
	~synth[6] = \FM2;
	~synth[7] = \windX;
	~synth[8] = \nice1;


	// VOLUME
	// Adjust tracks volume individuly (arg master in synths)
	m = (0.0 ! 10); //m: master volume in SynthDefs
	m[0] = 0.5;
	m[1] = 0.5;
	m[2] = 0.20;
	m[3] = 0.4;
	m[4] = 0.3;
	m[5] = 0.1;
	m[6] = 0.2;
	m[7] = 0.2;
	m[8] = 0.2;


	// LOAD PATTERN
	~loadFile.value(0, 201); //value: track, filename
	~loadFile.value(1, 200); //value: track, filename


	//INTRO:
	~loadFile.value(7, 202); //value: track, filename
	~loadFile.value(8, 202); //value: track, filename

	~schedElasticOnce.value(7).play;
	~schedElasticOnce.value(8).play;


	1.wait;
	"enable eSenses".postln;//TODO

	1.wait;
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 303, 1).start;
	~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 301, 1).start;

	1.wait;
	~guiTask.start(AppClock);

	1.wait;
	~onOff[0] = 1;
	~onOff[1] = 1;

	//load a new sound on track 2 when att goes above TH
	~usedTasks[3] = ~rewTask.value(2,0,0,0,0, 5,1).start;
	//load a new sound on track 3 and 4 when med goes above TH
	~usedTasks[4] = ~rewTask.value(3,1,0,0,0, 205,1).start;

};


i[3][1] = Routine {

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
	~onOff = 0 ! 16; //all off
	i[0][0].reset.play; //enter a new islet (here specified)

};