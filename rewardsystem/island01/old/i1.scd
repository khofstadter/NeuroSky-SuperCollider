~is[1][0] = {

	~presentIslet = 1;

	"Enter islet 1".postln;
	~makeTempoClock.value(5,16);

	"initialise thresholds for NFT".postln;
	~aThVal = 80; //attention threshold value
	~mThVal = 80; //meditation threshold value
	~aTimeThVal = 10; //for how many sec the signal shall be above a threshold
	~mTimeThVal = 10; //for how many sec the signal shall be above a threshold

	// needed rewardPoints to move to next islet :

	~toMoveVal = [ [ 99, 99, 99, 99 ], [ 99, 99, 99, 99 ] ];

	"open/close tracks".postln;


	// ~playTask for ~sched : synths scheduled with tempoClock (t)
	~onOff = 0 ! 16; //all off

	// tracks used with ~sched

	/*~onOff[0] = 0;
	~onOff[1] = 0;
	~onOff[2] = 0;
	~onOff[3] = 0;
	~onOff[4] = 0;*/

	// tracks used with ~schedElasticLoop
	// needs to be 0 otherwise the pattern will be played with ~shed as well;

	~onOff[5] = 0;
	~onOff[6] = 0;
	/*~onOff[7] = 0;
	~onOff[8] = 0;
	~onOff[9] = 0;*/

	"initialise synths used with tracks".postln;
	~synth[5] = \FM1;
	~synth[6] = \FM2;

	"initialise volume".postln;
	// Adjust tracks volume individuly (arg master in synths)
	m = (0.0 ! 10); //m: master volume in SynthDefs
	m[5] = 0.2;
	m[6] = 0.1;

	"initialise synths for used for constantSynths ".postln;
	~synth2[0] = \constantsynht1;
	~synth2[1] = \constantsaw;

	"initialise volume".postln;
	~m2 = (0.0 ! 4); //m: master volume in SynthDefs
	~m2[0] = 0.5;
	~m2[1] = 0.5;

	"start some synths".postln;
	//arg: track, volume to Fade in or from, time;
	~fadeConstantSynts.value(0, 0.9, 3, 80).start; //fade in; (attention map)
	~fadeConstantSynts.value(1, 0.2, 3, 32).start; //fade in; (meditation map)

	"start rewCalc task".postln;
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	"start rewTasks task".postln;
	~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 303, 1).start;
	~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 301, 1).start;

	"adjust GUI".postln;
	~guiTask.start(AppClock);

};

// ---------------------------------------------------------------------------------------------

~is[1][1] = {

	"Finish islet 1".postln;
	"move sliders back to 0".postln; //TODO
	t.sched(0, { "victory sound".postln }); //TODO
	// kill rewCalc and rewTasks:
	t.sched(1, { ~quitUsedTasks.value; });
	// fade out ConstantSynts:
	t.sched(2, {
		~fadeConstantSynts.value(0, 0.40, 6, 80).start; //fade out; (attention)
		~fadeConstantSynts.value(1, 0.20, 6, 32).start; //fade out; (meditation)
	});
	// stop TempoClock and move to next location(islet)
	t.sched(5, {
		t.stop;
		~is[2,0].value; //enter a new islet (here specified)
	});

};