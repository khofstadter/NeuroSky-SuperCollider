// ISLET02

// MESSAGES
// to be used by ~rewCalcTask and OSC communication (sendOsc)
~aThVal = 75; //attention threshold value
~mThVal = 80; //meditation threshold value
~aTimeThVal = 10; //for how many sec the signal shall be above a threshold
~mTimeThVal = 10; //for how many sec the signal shall be above a threshold

// needed rewardPoints to move to next islet :
~toMoveVal = [ [ 0, 3, 1, 0 ], [ 0, 0, 2, 0 ] ];

// ON/OFF
// ~playTask for ~sched : synths scheduled with tempoClock (t)
~onOff = 0 ! 16; //all off

// tracks used with ~sched
~onOff[0] = 0;
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
~synth[1] = \windpad;
~synth[2] = \saw;
~synth[3] = \sine;
~synth[4] = \bells2;
~synth[5] = \bells2;
~synth[6] = \simpleFM;
~synth[7] = \bells2;

// VOLUME
// Adjust tracks volume individuly (arg master in synths)
m = (0.0 ! 10); //m: master volume in SynthDefs
m[0] = 0.5;
m[1] = 0.5;
m[2] = 0.5;
m[3] = 0.5;
m[4] = 0.2;
m[5] = 0.5;
m[6] = 0.5;
m[7] = 0.5;
m[8] = 0.5;
m[9] = 0.5;

// LOAD PATTERN
~loadFile.value(0, 1000); //value: track, filename
~loadFile.value(1, 1010); //value: track, filename
~loadFile.value(2, 1020); //value: track, filename
~loadFile.value(3, 1030); //value: track, filename


// REWARD TASKS
// '~rewCalcTask' and '~rewCalcTask' are declare to '~usedTasks' so they can be stopped and reevaluated again in each islet
x = Task({

	var temp = 10;
	t.tempo_(temp);


	//fade out
	~fadeConstantSynts.value(0, 8, 0.1, 3, 120).start; //fade out from last islet
	//stop ElasticLoops
	~schedElasticLoopPlay[2].stop;
	~schedElasticLoopPlay[3].stop;


	//start new melody
	//scheduling tracks to be opened
	t.schedAbs(t.nextBar, {~onOff[1] = 1;});
	t.schedAbs(t.nextBar+(~beat*2), {~onOff[0] = 1;});
	t.schedAbs(t.nextBar+(~beat*3), {~onOff[2] = 1;});
	t.schedAbs(t.nextBar+(~beat*3+(~beat/2)), {~onOff[3] = 1;});


	//start new reward calulation task and reward tasks
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

	//load a new sound on track 0 when att goes above TH
	~usedTasks[1] = ~rewTask.value(0,0,0,0,0, 1900,1901).start;


	//messages to OSC or post window
	"enter islet[0][2]".postln;
	~message = "enter islet[0][2]";
	5.wait;
	~message = "Task : 1) raise attention level 3 times above threshold, 2) keep it above threshold for 10 seconds; 3) ... as well as 4) keep meditation level above threshold twice for at least 10 seconds.";

	//move other balls
	~toPro[15] = 100; //other balls' speed

});

x.play;