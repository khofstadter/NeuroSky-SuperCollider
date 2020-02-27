// ISLET03

// MESSAGES
// to be used by ~rewCalcTask and OSC communication (sendOsc)
~aThVal = 80; //attention threshold value
~mThVal = 80; //meditation threshold value
~aTimeThVal = 10; //for how many sec the signal shall be above a threshold
~mTimeThVal = 10; //for how many sec the signal shall be above a threshold

// needed rewardPoints to move to next islet :
~toMoveVal = [ [ 0, 3, 1, 0 ], [ 0, 3, 4, 0 ] ];

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
// keep the old once for a while
// ~synth[0] = \laserbeam;
// ~synth[1] = \sine;
// ~synth[2] = \windpad;
// ~synth[3] = \newFM3;
~synth[4] = \sine;
~synth[5] = \FM2;
~synth[6] = \sine;
~synth[7] = \sine;

// VOLUME
// Adjust tracks volume individuly (arg master in synths)
m = (0.0 ! 10); //m: master volume in SynthDefs
m[0] = 0.5;
m[1] = 0.5;
m[2] = 0.5;
m[3] = 0.5;
m[4] = 0.0;
m[5] = 0.5;
m[6] = 0.5;
m[7] = 0.0;
m[8] = 0.0;
m[9] = 0.0;

// LOAD PATTERN
~loadFile.value(0, 5300); //value: track, filename
~loadFile.value(1, 5310); //value: track, filename
~loadFile.value(2, 5320); //value: track, filename
~loadFile.value(3, 5330); //value: track, filename


// REWARD TASKS
// '~rewCalcTask' and '~rewCalcTask' are declare to '~usedTasks' so they can be stopped and reevaluated again in each islet
x = Task({
	//change tempo
	var temp = 9;
	t.tempo_(temp);
	//stop ElasticLoops
	//none started


	//scheduling tracks to be opened
	t.schedAbs(t.nextBar, {~onOff[1] = 1;});
	t.schedAbs(t.nextBar+(~beat*2), {~onOff[0] = 1; ~synth[0] = \laserbeam;});
	t.schedAbs(t.nextBar+(~beat*3), {~onOff[2] = 1; ~synth[1] = \sine; t.tempo_(8);});
	t.schedAbs(t.nextBar+(~beat*3+(~beat/2)), {~onOff[3] = 1; ~synth[2] = \windpad; t.tempo_(7);});
	t.schedAbs(t.nextBar+(~beat*3), {t.tempo_(6);});
	t.schedAbs(t.nextBar+(~beat*3), {t.tempo_(5);});



	15.wait;
	//start new reward calulation task and reward tasks
	~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;
	//schedule 5350/51 with ~schedElasticOnce on track 5 when att goes above/below TH
	~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 5350,5351).start;
	//schedule 5360/61 with ~schedElasticOnce on track 6 when med goes above/below TH
	~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 5360,5361).start;
	//load& rotates new sounds on track 0 when att goes above TH
	~usedTasks[3] = ~rewTask.value(0,0,1,0,0, 5300,5301,5302,5303,5304).start;
	//load a new sound on track 0 when med goes above TH
	//~usedTasks[3] = ~rewTask.value(0,1,1,0,0, 5300,5301,5302, 5303,5304).start;
	//load a new sound on track 0 when med reaches TTH
	//at the moment it is a loop, after the last sound the first one gets played again
	//~usedTasks[3] = ~rewTask.value(0,1,2,0,0, 5300,5301,5302, 5303,5304).start;
	//load a new sound on track 2 when att goes above TH
	~usedTasks[4] = ~rewTask.value(2,0,0,0,0, 5321,5320).start;
	~usedTasks[5] = ~rewTask.value(1,0,0,0,0, 5312,5311).start;


	//messages to OSC or post window
	"enter islet[0][3]".postln;
	~message = "enter islet[0][3]";
	5.wait;
	~message = "Task : 1) raise attention level 3 times above threshold, 2) keep it above threshold for 10 seconds at least once; 3) ... as well as 4) raise meditation level 3 times above threshold and keep it 4 times above TH for 10 seconds";

	//move other balls
	~toPro[15] = 100; //other balls' speed


});

x.play;