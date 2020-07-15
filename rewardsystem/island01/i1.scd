i[1][0]=Routine {
	~makeTempoClock.value(1,16);
	~presentIslet=1;
	("islet:"++~presentIslet).postln;

	//NF thresholds
	~aThVal=80;
	~mThVal=80;
	~aTimeThVal=10;
	~mTimeThVal=10;
	~toMoveVal=[[0,4,0,0],[0,2,0,0]];

	//
	~usedTasks[0]=~rewCalcTask.value(
		~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	//tracks scheduled with tempoClock
	~onOff=0 ! 16; //turn all off
	m=(0.0 ! 10); //master volume in SynthDefs

	//track 0
	~synth[0]=\laserbeam;
	m[0]=0.05;
	~schedElasticLoopPlay[0]=~schedElasticLoop.value(track:2).play;
	~usedTasks[1]=~rewTask.value(
		track:0,idx0:0,idx1:0,
		style:1,fromBeat:0,
		loadFile0:200,loadFile1:0).start;

	//track 1
	~synth[1]=\FM2;
	m[1]=0.2;
	~schedElasticLoopPlay[1]=~schedElasticLoop.value(track:3).play;
	~usedTasks[2]=~rewTask.value(
		track:1,idx0:1,idx1:0,
		style:1,fromBeat:0,
		loadFile0:210,loadFile1:0).start;

	//track 2
	~synth[2]=\FM0;
	m[2]=0.18;
	~loadFile.value(track:2,filename:220); //value: track, filename

	//track 4
	~synth[3]=\nice1;
	m[3]=0.2;
	~loadFile.value(track:3,filename:220); //value: track, filename

	//track 9 (victory sound)
	//scheduled in reward.scd
	~synth[9]= \sine;
	 m[9]= 0.1;
	~loadFile.value(track:9,filename:440); //value: track, filename

	//TODO: enable eSenses

	1.wait;
	~guiTask.start(AppClock);
};

i[1][1]=Routine {
	("exit islet:"++~presentIslet).postln;
	//TODO: disable eSenses
	//TODO: move sliders back to 0".postln
	~quitUsedTasks.value;//remove rewCalc & rewTasks
	4.wait;//safety delay
	t.stop;
	~schedElasticLoopPlay[0].stop;
	~schedElasticLoopPlay[1].stop;
	i[~selectIslet][0].reset.play; //enter a new islet (here specified)
};