// ISLET01

// MESSAGES
// to be used by ~rewCalcTask and OSC communication (sendOsc)
~aThVal = 80; //attention threshold value
~mThVal = 80; //meditation threshold value
~aTimeThVal = 5; //for how many sec the signal shall be above a threshold
~mTimeThVal = 5; //for how many sec the signal shall be above a threshold

// needed rewardPoints to move to next islet :
~toMoveVal = [ [ 0, 5, 1, 0 ], [ 0, 2, 0, 0 ] ];

// ON/OFF
// ~playTask for ~sched : synths scheduled with tempoClock (t)
~onOff = 0 ! 16; //all off

// tracks used with ~sched
~onOff[0] = 0;
~onOff[1] = 1;
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
~synth[0] = \nice1;
~synth[1] = \simpleFM;
~synth[2] = \windpad;
~synth[3] = \moogbasstone;
~synth[4] = \ring1;
~synth[5] = \newFM2;
~synth[6] = \nice1;
~synth[7] = \newFM2;


// VOLUME
// Adjust tracks volume individuly (arg master in synths)
m = (0 ! 10); //m: master volume in SynthDefs
m[0] = 0.5;
m[1] = 0.5;
m[2] = 0.3;
m[3] = 0.3;
m[4] = 0.5;
m[5] = 0.4;
m[6] = 0.5;
m[7] = 0.5;
m[8] = 0.5;
m[9] = 0.5;

~m2 = (0.5 ! 4); //m: master volume in SynthDefs to be used with ~constantSynths

// LOAD PATTERN

~loadFile.value(0, 5200); //value: track, filename
~loadFile.value(1, 5210); //value: track, filename
~loadFile.value(2, 5220); //value: track, filename
~loadFile.value(3, 5230); //value: track, filename



// REWARD TASKS
// '~rewCalcTask' and '~rewCalcTask' are declare to '~usedTasks' so they can be stopped and reevaluated again in each islet
x = Task({

	var temp = 5;
	t.tempo_(temp);

	//scheduling tracks to be opened
	t.schedAbs(t.nextBar, {~onOff[0] = 1;});
	t.schedAbs(t.nextBar+(~beat*2), {~schedElasticLoopPlay[2] = ~schedElasticLoop.value(2).play;});
	t.schedAbs(t.nextBar+(~beat*3), {~schedElasticLoopPlay[3] = ~schedElasticLoop.value(3).play;});


	//CONSTANT SOUNDING SYNTHS:
	//arg: track, synthList[nb], volume to Fade in or from, time, freq;
	~fadeConstantSynts.value(0, 8, 0.1, 3, 120).start; //fade out;
	//to fade out use the same
	//~fadeConstantSynts.value(0, 2, 0.05, 3).start; //fade out; don't need freq

	//start new reward calulation task and reward tasks
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 5250,5251).start;
	~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 5260,5061).start;
	//		~rewTask.value(6,0,2,2,0, 600, 601, 602, 603, 604).start;
	//		~rewTask.value(7,1,2,1,0, 200, 201, 202, 203, 204).start;
	//		~rewTask.value(7,1,2,1,0, 200, 201, 202, 203, 204).start;

	//messages to OSC or post window

	"enter islet[0][1]".postln;
	~message = "enter islet[0][1]";
	5.wait;
	~message = "Task : 1) raise attention level 5 times and 2) meditation level twice above threshold ... as well as 3) keep attention level above threshold once for at least 5 seconds.";

	//move other balls
	~toPro[15] = 70; //other balls speed
});

x.play;






