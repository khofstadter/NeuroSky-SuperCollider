i[2][0] = Routine {
	~makeTempoClock.value(1,16);
	~presentIslet = 2;
	"presentIslet 2".postln;

	//nf thresholds
	~aThVal = 50;
	~mThVal = 50;
	~aTimeThVal = 10;
	~mTimeThVal = 10;
	~toMoveVal = [ [ 0, 4, 0, 0 ], [ 0, 2, 0, 0 ] ];

	// tracks on/off
	// ~playTask for ~sched: synths scheduled with tempoClock (t)
	~onOff = 0 ! 16; //turn all off

	// SYNTHS for Sched Loop and Elastic Loops and ElasticOnce
	~synth[0] = \sine;
	~synth[1] = \FM3;
	~synth[2] = \simpleFM;
	~synth[3] = \nice1;

	//VOLUME
	//Adjust tracks volume individuly (arg master in synths)
	m = (0.0 ! 10); //m: master volume in SynthDefs
	m[0] = 0.1;
	m[1] = 0.1;
	m[2] = 0.4;
	m[3] = 0.5;

	//LOAD BARS
	~loadFile.value(2, 220); //value: track, filename
	~loadFile.value(3, 220); //value: track, filename (MELODY eloop)
	~schedElasticLoopPlay[0] = ~schedElasticLoop.value(2).play;
	~schedElasticLoopPlay[1] = ~schedElasticLoop.value(3).play;

	//TODO: enable eSenses

	1.wait;
	~usedTasks[0] = ~rewCalcTask.value(~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	~usedTasks[1] = ~rewTask.value(0,0,0,1,0, 200, 1).start;
	~usedTasks[2] = ~rewTask.value(1,1,0,1,0, 210, 1).start;

	1.wait;
	~guiTask.start(AppClock);
};


i[2][1] = Routine {
	"Finish islet 2".postln;
	"move sliders back to 0".postln; //TODO
	"victory sound".postln; //TODO
	//TODO: disable eSenses
	// kill rewCalc and rewTasks:
	~quitUsedTasks.value;
	// stop TempoClock and move to next location(islet)
	4.wait;
	t.stop;
	~schedElasticLoopPlay[0].stop;
	~schedElasticLoopPlay[1].stop;
	i[~selectIslet][0].reset.play; //enter a new islet (here specified)
};