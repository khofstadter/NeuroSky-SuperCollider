i[3][0]=Routine {
	~makeTempoClock.value(1,32);
	~tempo=[0.7,10!~beat];
	~presentIslet=3;
	("islet:"++~presentIslet).postln;

	//NF thresholds
	~aThVal=75;
	~mThVal=75;
	~aTimeThVal=10;
	~mTimeThVal=10;
	~toMoveVal=[[0,5,2,0],[0,2,2,0]];

	//tracks scheduled with tempoClock
	~onOff=0 ! 16; //turn all off
	m=(0.0 ! 10); //master volume in SynthDefs

	//t0
	t.schedAbs(~beat*2, {~onOff[0]=1;});
	~synth[0]=\simpleFM;
	m[0]=0.15;
	~loadFile.value(0, 400);

	//t01
	t.schedAbs(~beat*2, {~onOff[1]=1;});
	~synth[1]=\simpleFM;
	m[1]=0.2;
	~loadFile.value(1, 410);

	//t02
	~onOff[2]=1;
	~synth[2]=\saw;
	m[2]=0.1;
	~loadFile.value(2, 420);

	//t03
	~onOff[3]=1;
	~synth[3]=\FM3;
	m[3]=0.15;
	~loadFile.value(3, 430);

	//t04
	t.schedAbs(~beat*3,{~onOff[4]=1});
	~synth[4]=\sample;
	~trackSample[4]=Buffer.readChannel(
		s,~pathname++"-samples/Kick 07.aif");
	m[4]=0.4;
	~loadFile.value(4, 440);

	//t05
	t.schedAbs(~beat*3, {~onOff[5]=1});
	~synth[5]=\sample;
	~trackSample[5]=Buffer.readChannel(
		s,~pathname++"-samples/hihat17.wav");
	m[5]=0.4;
	~loadFile.value(5, 450);

	//t06
	~onOff[6]=1;
	~synth[6]=\sample;
	~trackSample[6]=Buffer.readChannel(
		s,~pathname++"-samples/BL_Snare07.wav");
	m[6]=0.1;
	~loadFile.value(6, 461);

	//TODO: enable eSenses
	~usedTasks[0]=~rewCalcTask.value(
		~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	//track, idx0, idx1, style, fromBeat, loadFile0, loadFile1, loadFile2, loadFile3, loadFile4| - if only one file is needed then you don't have to add loadFile1, loadFile2, ...

	~usedTasks[1]=~rewTask.value(0,1,0,0,0,401,400).start;
	~usedTasks[2]=~rewTask.value(1,1,0,0,0,411,410).start;
	~usedTasks[3]=~rewTask.value(2,1,0,0,0,421,420).start;
	~usedTasks[4]=~rewTask.value(3,0,1,0,0,1,430,431,432,433).start;
	~usedTasks[5]=~rewTask.value(4,1,0,0,0,441,440).start;
	~usedTasks[6]=~rewTask.value(5,1,0,0,0,450,451).start;
	~usedTasks[7]=~rewTask.value(6,1,0,0,0,461,460).start;
	1.wait;
	~guiTask.start(AppClock);
};

i[3][1]=Routine {
	("exit islet:"++~presentIslet).postln;
	//TODO: trigger victory sound
	//TODO: disable eSenses
	//TODO: move sliders back to 0".postln
	~quitUsedTasks.value;//remove rewCalc & rewTasks
	4.wait;//safety delay
	t.stop;
	i[~selectIslet][0].reset.play; //selected islet
};