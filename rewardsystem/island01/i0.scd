i[0][0]=Routine {
	~makeTempoClock.value(1,16);
	~presentIslet=0;
	("islet:"++~presentIslet).postln;

	//NF thresholds
	~aThVal=70;
	~mThVal=70;
	~aTimeThVal=10;
	~mTimeThVal=10;
	~toMoveVal=[[0,3,2,30],[0,3,2,30]];

	//
~usedTasks[0]=~rewCalcTask.value(~aTimeThVal,~mTimeThVal,~toMoveVal).start;


	//tracks scheduled with tempoClock
	~onOff=0 ! 16; //turn all off
	m=(0.0 ! 10); //master volume in SynthDefs

	//track 0
	~synth[0]=\nice1;
	m[0]=0.08;
	~usedTasks[1]=~rewTask.value(
		track:0,idx0:1,idx1:0,
		style:1,fromBeat:0,
		loadFile0:1,loadFile1:0).start;

	//track 1
	~synth[1]=\FM0;
	m[1]=0.2;
	~usedTasks[2]=~rewTask.value(
		track:1,idx0:0,idx1:0,
		style:1,fromBeat:0,
		loadFile0:2,loadFile1:0).start;

	//constantSynth track 0
	~synth2[0]=\constantSaw2;
	~m2[0]=1;

	~fadeConstantSynts.value(track:0,vol:1,time:3,
		freqmidi:27,medOrAtt0:0,medOrAtt1:0).start;

	//constantSynth track 1
	~synth2[1]=\constantSaw1;
	~m2[1]=0.9;
	~fadeConstantSynts.value(track:1,vol:1,time:3,
		freqmidi:75,medOrAtt0:1,medOrAtt1:0).start;

	//track 9 (victory sound)
	//scheduled in reward.scd
	~synth[9]=\sine;
	 m[9]=0.1;
	~loadFile.value(track:9,filename:440); //value: track, filename

	//TODO: enable eSenses

	1.wait;

	~guiTask.start(AppClock);
};

i[0][1]=Routine {
	("exit islet:"++~presentIslet).postln;
	//TODO: disable eSenses
	//TODO: move sliders back to 0".postln
	~quitUsedTasks.value;//remove rewCalc & rewTasks
	~fadeConstantSynts.value(track:0,vol:1,time:1).start;//fade out
	~fadeConstantSynts.value(track:1,vol:1,time:1).start;//fade out
	4.wait;//safety delay
	t.stop;
	i[~selectIslet][0].reset.play; //enter a new islet (here specified)
};