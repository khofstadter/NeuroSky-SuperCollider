i[0][0]= Routine {
	~makeTempoClock.value(1,16);
	~presentIslet= 0;
	"in the sea".postln;

	//nf thresholds
	~aThVal= 70;
	~mThVal= 70;
	~aTimeThVal= 10;
	~mTimeThVal= 10;
	~toMoveVal= [ [ 0, 0, 0, 99 ], [ 0, 0, 0, 0 ] ];

	// tracks on/off
	// ~playTask for ~sched: synths scheduled with tempoClock (t)
	~onOff= 0 ! 16; //turn all off

	// tracks used with ~sched
	~onOff[0]= 0;
	~onOff[1]= 0;

	// tracks used with ~schedElasticLoop
	// needs to be 0 otherwise the pattern will be played with ~shed as well;

	"initialise synths used with tracks".postln;
	~synth[0]= \simpleFM;
	~synth[1]= \simpleFM;

	"initialise volume".postln;
	// Adjust tracks volume individuly (arg master in synths)
	m= (0.0 ! 10); //m: master volume in SynthDefs
	m[0]= 0.2;
	m[1]= 0.1;

	"initialise synths for used for constantSynths ".postln;
	~synth2[0]= \constantsaw;
	~synth2[1]= \constantsynht1;

	"initialise volume".postln;
	~m2= (0.0 ! 4); //m: master volume in SynthDefs
	~m2[0]= 0.5;
	~m2[1]= 0.5;

	"start some synths".postln;
	//arg: track, volume, time, midifreq, medOrAtt, medOrAtt (medOrAtt: 0:med;1:att)
	~fadeConstantSynts.value(0, 0.2, 3, 3, 0, 0).start;//map to meditation
	~fadeConstantSynts.value(1, 0.2, 3, 75, 1, 1).start;//map to attention
	1.wait;

	//TODO: enable eSenses

	~usedTasks[0]= ~rewCalcTask.value(~aTimeThVal,~mTimeThVal,~toMoveVal).start;
	~usedTasks[1]= ~rewTask.value(0,0,0,1,0,100,1).start;
	~usedTasks[2]= ~rewTask.value(1,1,0,1,0,110,1).start;
	1.wait;
	~guiTask.start(AppClock);
};

i[0][1]= Routine {
	~quitUsedTasks.value;//remove rewCalc and rewTasks
	//TODO: disable eSenses
	// fade out ConstantSynts:
//	~fadeConstantSynts.value(0, 0.9, 1, 75).start;
//	~fadeConstantSynts.value(1, 0.5, 1, 2).start;
	1.wait;//safety delay
	t.stop;//stop TempoClock
	i[~selectIslet][0].reset.play; //enter a new islet (here specified)
};