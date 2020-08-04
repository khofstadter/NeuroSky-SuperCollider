i[2][0]=Routine {
	~makeTempoClock.value(1,32);
	~tempo=[0.7,10!~beat]; //0.7*10=7bps, no swing;
	~presentIslet=2;
	("islet:"++~presentIslet).postln;

	//NF thresholds
	~aThVal=70;
	~mThVal=70;
	~aTimeThVal=10;
	~mTimeThVal=10;
	~toMoveVal=[[0,5,4,10],[0,5,4,10]];

	~usedTasks[0]=~rewCalcTask.value(
		~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	//tracks scheduled with tempoClock
	~onOff=0 ! 16; //turn all off
	m=(0.0 ! 10); //master volume in SynthDefs

	//track 0
	t.schedAbs(~beat*2,{~onOff[0]=1;});//delayed
~synth[0]=\FM0;
	m[0]=0.04;
	~loadFile.value(track:0,filename:400);

	//track 1
	t.schedAbs(~beat*2,{~onOff[1]=1;});//delayed
	~synth[1]=\bells2;
	m[1]=0.17;
	~loadFile.value(track:1,filename:410);
	~usedTasks[1]=~rewTask.value(
		track:1,idx0:1,idx1:0,
		style:0,fromBeat:0,loadFile0:411,loadFile1:410).start;

	//track 2
	t.schedAbs(~beat*4,{~onOff[2]=1;});//delayed
	~synth[2]=\FM1;
	m[2]=0.03;
	~loadFile.value(track:2,filename:420);
		~usedTasks[2]=~rewTask.value(
	track:2,idx0:1,idx1:0,
		style:0,fromBeat:0,loadFile0:421,loadFile1:420).start;

	//track 3
	t.schedAbs(~beat*4,{~onOff[3]=1;});
	~synth[3]=\sine;
	m[3]=0.07;
	~loadFile.value(track:3,filename:430);
	~usedTasks[3]=~rewTask.value(
		track:3,idx0:0,idx1:1,
		style:0,fromBeat:0,loadFile0:0,loadFile1:430,loadFile2:431,
		loadFile3:432,loadFile4:433).start;

	//track 4
	t.schedAbs(~beat*3,{~onOff[4]=1});
	~synth[4]=\sample;
	~trackSample[4]=Buffer.readChannel(
		s,~pathname++"-samples/Kick 07.aif");
	m[4]=0.15;
	~loadFile.value(track:4,filename:440);
	~usedTasks[4]=~rewTask.value(
		track:4,idx0:1,idx1:0,
		style:0,fromBeat:0,loadFile0:441,loadFile1:440).start;

	//track 5
	t.schedAbs(~beat*4,{~onOff[5]=1});
	~synth[5]=\sample;
	~trackSample[5]=Buffer.readChannel(
		s,~pathname++"-samples/hihat17.wav");
	m[5]=0.1;
	~loadFile.value(track:5,filename:452);
	~usedTasks[5]=~rewTask.value(
		track:5,idx0:1,idx1:0,
		style:0,fromBeat:0,loadFile0:453,loadFile1:452).start;

	//track 6
	t.schedAbs(~beat*5,{~onOff[6]=1});
	~synth[6]=\sample;
	~trackSample[6]=Buffer.readChannel(
		s,~pathname++"-samples/BL_Snare07.wav");
	m[6]=0.05;
	~loadFile.value(track:6,filename:461);
	~usedTasks[6]=~rewTask.value(
		track:6,idx0:1,idx1:0,
		style:0,fromBeat:0,loadFile0:461,loadFile1:460).start;


	//track 9 (victory sound)
	//scheduled in reward.scd
	~synth[9]= \sine;
	m[9]= 0.1;
	~loadFile.value(track:9,filename:440); //value: track, filename

	//TODO: enable eSenses

	1.wait;
	~guiTask.start(AppClock);
};

i[2][1]=Routine {
	("exit islet:"++~presentIslet).postln;
	//TODO: disable eSenses
	//TODO: move sliders back to 0".postln
	~quitUsedTasks.value;//remove rewCalc & rewTasks
	//4.wait;//safety delay
	t.stop;
	i[~selectIslet][0].reset.play; //selected islet
};