// ISLET00 - practice mode;

// MESSAGES
// to be used by ~rewCalcTask and OSC communication (sendOsc)
~aThVal = 80; //attention threshold value
~mThVal = 80; //meditation threshold value
~aTimeThVal = 10; //for how many sec the signal shall be above a threshold
~mTimeThVal = 10; //for how many sec the signal shall be above a threshold

// needed rewardPoints to move to next islet :
~toMoveVal = [ [ 99, 99, 99, 99 ], [ 99, 99, 99, 99 ] ];

// ON/OFF
// ~playTask for ~sched : synths scheduled with tempoClock (t)
~onOff = 0 ! 16; //all off

// tracks used with ~sched
~onOff[0] = 1;
~onOff[1] = 0;
~onOff[2] = 0;
~onOff[3] = 0;
~onOff[4] = 0;

// tracks used with elastic schedules
// tracks HAVE TO BE 0 otherwise the pattern will be played with ~shed (tempo Clock) as well.

~onOff[5] = 0;
~onOff[6] = 0;
~onOff[7] = 0;
~onOff[8] = 0;
~onOff[9] = 0;

// SYNTHS
// Select synthesizers to generate sounds with
~synth[0] = \simpleFM;
~synth[1] = \nice1;
~synth[2] = \windpad;
~synth[3] = \bells2;
~synth[4] = \simpleFM;
~synth[5] = \simpleFM;
~synth[6] = \FM3;
~synth[7] = \bells2;


// VOLUME
// Adjust tracks volume individuly (arg master in synths)
m = (0.0 ! 10); //m: master volume in SynthDefs
m[0] = 0.5;
m[1] = 0.5;
m[2] = 0.5;
m[3] = 0.5;
m[4] = 0.5;
m[5] = 0.4;
m[6] = 0.4;
m[7] = 0.5;
m[8] = 0.5;
m[9] = 0.5;

// LOAD PATTERN

~loadFile.value(0, 10); //value: track, filename
//~loadFile.value(1, 200); //value: track, filename
//~loadFile.value(2, 300); //value: track, filename
//~loadFile.value(3, 400); //value: track, filename

// REWARD TASKS
// '~rewCalcTask' and '~rewCalcTask' are declare to '~usedTasks' so they can be stopped and reevaluated again in each islet
x = Task({

	var temp = 5;
	t.tempo_(temp);

	//arg: track, synthList[nb], volume to Fade in or from, time;
	//~fadeConstantSynts.value(0, 2, 0.05, 5).start;

	//~rewCalcTask
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	//~rewTasks
	//|track, idx0, idx1, style, fromBeat, loadFile0, loadFile1, loadFile2, loadFile3, loadFile4|
	~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 50, 51).start;
	~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 60, 61).start;
	//		~rewTask.value(6,0,2,2,0, 600, 601, 602, 603, 604).start;
	//		~rewTask.value(7,1,2,1,0, 200, 201, 202, 203, 204).start;
	//		~rewTask.value(7,1,2,1,0, 200, 201, 202, 203, 204).start;


	// messages to OSC and postwindow
	"enter islet[0][0]".postln;
	~message = "enter islet[0][0] - practice mode";
	5.wait;
	~message = "Task : practise raising attention and meditation levels.";
	10.wait;
	~message = "_the coloured ball represents attention - the larger the radious the more attention is generated ~ beta waves ~                           _the hollow ball represents meditation - the larger the radious the more relaxed the mind  ~ alpha waves ~";
	10.wait;
	~message = "with higher attention you can enlarge the size of the coloured ball and make it move slower";
		10.wait;
	~message = "with higher meditation you can enlarge the size of the hollow ball and make it move slower ";
	5.wait;

});

x.play;
