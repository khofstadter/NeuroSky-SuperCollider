i[3][0] = Routine {

	~makeTempoClock.value(1,32);
	~tempo = [0.7,10!~beat];

	~presentIslet = 3;
	"presentIslet 3 - this ONe".postln;

	~aThVal = 75;
	~mThVal = 75;
	~aTimeThVal = 10;
	~mTimeThVal = 10;

	~toMoveVal = [ [ 0, 5, 2, 0 ], [ 0, 2, 2, 0 ] ];

	// ON/OFF
	// ~playTask for ~sched : synths scheduled with tempoClock (t)
	~onOff = 0 ! 16; //all off

	// tracks used with ~sched

	~onOff[2] = 0;
	~onOff[3] = 1;
	~onOff[6] = 1;


	// SYNTHS for Sched Loop and Elastic Loops
	~synth[0] = \simpleFM;
	~synth[1] = \test;
	~synth[2] = \saw;
	~synth[3] = \sine;
	~synth[4] = \sample;
	~trackSample[4] = Buffer.readChannel(s, ~pathname ++ "_sample/Kick 07.aif");
	~synth[5] = \sample;
		~trackSample[5] = Buffer.readChannel(s, ~pathname ++ "_sample/hihat17.wav");
	~synth[6] = \sample;
		~trackSample[6] = Buffer.readChannel(s, ~pathname ++ "_sample/BL_Snare07.wav");



	// VOLUME
	// Adjust tracks volume individuly (arg master in synths)
	m = (0.0 ! 10); //m: master volume in SynthDefs
	m[0] = 0.15;
	m[1] = 0.5;
	m[2] = 0.6;
	m[3] = 0.5;
	m[4] = 0.7;
	m[5] = 0.6;
	m[6] = 0.2;

	// LOAD PATTERN
	~loadFile.value(0, 400); //value: track, filename
	~loadFile.value(1, 410); //value: track, filename
	~loadFile.value(2, 420); //value: track, filename
//	~loadFile.value(3, 430); //value: track, filename
	~loadFile.value(4, 440); //value: track, filename
	~loadFile.value(5, 450); //value: track, filename
	~loadFile.value(6, 461); //value: track, filename

	t.schedAbs(~beat*2, {	~onOff[0] = 1;~onOff[1] = 1;});
	t.schedAbs(~beat*3, {	~onOff[4] = 1;~onOff[5] = 1;});

	1.wait;
	"enable eSenses".postln;//TODO

	//track, idx0, idx1, style, fromBeat, loadFile0, loadFile1, loadFile2, loadFile3, loadFile4| - if only one file is needed the you don't have to add loadFile1, loadFile2, ...

	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;
	//load a new sound on track 4 when att goes above TH
	~usedTasks[1] = ~rewTask.value(0,0,0,0,0,401,400).start;
	~usedTasks[2] = ~rewTask.value(1,1,0,0,0,411,410).start;
	~usedTasks[3] = ~rewTask.value(2,0,0,0,0,421,420).start;
	~usedTasks[4] = ~rewTask.value(3,0,1,0,0,1,430,431,432,433).start;
	~usedTasks[5] = ~rewTask.value(4,0,0,0,0,441,440).start;

	~usedTasks[6] = ~rewTask.value(5,0,0,0,0,450,451).start;
	~usedTasks[7] = ~rewTask.value(6,1,0,0,0,461,460).start;

	1.wait;

	~guiTask.start(AppClock);



};


i[3][1] = Routine {

	"Finish islet 3".postln;
	"move sliders back to 0".postln; //TODO
	"victory sound".postln; //TODO
	// kill rewCalc and rewTasks:
	~quitUsedTasks.value;
	// stop TempoClock and move to next location(islet)
	4.wait;
	t.stop;
	// ~schedElasticLoopPlay[0].stop;
	// ~schedElasticLoopPlay[1].stop;
	~onOff = 0 ! 16; //all off
	i[0][0].reset.play; //enter a new islet (here specified)

};