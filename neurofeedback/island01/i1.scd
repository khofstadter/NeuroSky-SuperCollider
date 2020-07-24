i[1][0]=Routine {
	~makeTempoClock.value(1,16);
	~presentIslet=1;
	("islet:"++~presentIslet).postln;

	//NF thresholds
	~aThVal=70;
	~mThVal=70;
	~aTimeThVal=10;
	~mTimeThVal=10;
	~toMoveVal=[[0,4,0,10],[0,4,0,10]];

	//
	~usedTasks[0]=~rewCalcTask.value(
		~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	//tracks scheduled with tempoClock
	~onOff=0 ! 16; //turn all off
	m=(0.0 ! 10); //master volume in SynthDefs

	//track 0
	~synth[0]=\laserbeam;
	m[0]=0.03;
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
	m[2]=0.6;
	~loadFile.value(track:2,filename:220); //value: track, filename

	//track 3
	~synth[3]=\nice1;
	m[3]=0.2;
	~loadFile.value(track:3,filename:220); //value: track, filename

	//track 4
	~synth[4]=\windX;
	m[4]=0.05;
	~schedElasticLoopPlay[2]=~schedElasticLoop.value(track:4).play;
	~loadFile.value(track:4,filename:0);
	~usedTasks[3]=~rewTask.value(
		track:4,idx0:0,idx1:1,
		style:0,fromBeat:0,loadFile0:0,loadFile1:221,loadFile2:222,
		loadFile3:223,loadFile4:224).start;

	//track 5
	~synth[5]=\FM4;
	m[5]=0.2;
	~schedElasticLoopPlay[3]=~schedElasticLoop.value(track:5).play;
	~loadFile.value(track:5,filename:0);
	~usedTasks[5]=~rewTask.value(
		track:5,idx0:1,idx1:1,
		style:0,fromBeat:0,loadFile0:0,loadFile1:225,loadFile2:226,
		loadFile3:227,loadFile4:228).start;

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
	//4.wait;//safety delay
	t.stop;
	~schedElasticLoopPlay[0].stop;
	~schedElasticLoopPlay[1].stop;
	~schedElasticLoopPlay[2].stop;
	~schedElasticLoopPlay[3].stop;
	i[~selectIslet][0].reset.play; //enter a new islet (here specified)
};