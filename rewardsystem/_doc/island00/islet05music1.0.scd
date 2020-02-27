

// ISLET02 - practice mode;



// MESSAGES
// to be used by ~rewCalcTask and OSC communication (sendOsc)





~aThVal = 90; //attention threshold value
~mThVal = 80; //meditation threshold value
~aTimeThVal = 10; //for how many sec the signal shall be above a threshold
~mTimeThVal = 10; //for how many sec the signal shall be above a threshold


// needed rewardPoints to move to next islet :
~toMoveVal = [ [ 0, 5, 1, 0 ], [ 0, 0, 0, 0 ] ];
~message = "Hello";

// ON/OFF
// ~playTask for ~sched : synths scheduled with tempoClock (t)



~onOff = 0 ! 16; //all off

// tracks used with ~sched
~onOff[0] = 1;
~onOff[1] = 1;
~onOff[2] = 1;
~onOff[3] = 1;
~onOff[4] = 1;

// tracks used with elastic schedules
// tracks HAVE TO BE 0 otherwise the pattern will be played with ~shed (tempo Clock) as well.

~onOff[5] = 0;
~onOff[6] = 0;
~onOff[7] = 0;
~onOff[8] = 0;
~onOff[9] = 0;





// SYNTHS
// Select synthesizers to generate sounds with
~synth[0] = \windpad;
~synth[1] = \bells2;
~synth[2] = \simpleFM;
~synth[3] = \bells2;
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
m[4] = 0.5;
m[5] = 0.5;
m[6] = 0.5;
m[7] = 0.5;
m[8] = 0.5;
m[9] = 0.5;





// LOAD PATTERN


~loadFile.value(0, 100); //value: track, filename
~loadFile.value(1, 200); //value: track, filename
~loadFile.value(2, 300); //value: track, filename
~loadFile.value(3, 400); //value: track, filename



// REWARD TASKS
// '~rewCalcTask' and '~rewCalcTask' are declare to '~usedTasks' so they can be stopped and reevaluated again in each islet
x = Task({
		"enter islet[0][2]".postln;
		~message = "enter islet[0][2] - practise mode";
		2.wait;
		~message = "Task : ...";

		~usedTasks[0] = ~rewCalcTask.value(~aThVal,~mThVal,~aTimeThVal,~mTimeThVal,~toMoveVal).start;

		~usedTasks[1] = ~rewTask.value(5,0,0,1,0, 501,502).start;
		~usedTasks[2] = ~rewTask.value(6,1,0,1,0, 501, 502).start;
//		~rewTask.value(6,0,2,2,0, 600, 601, 602, 603, 604).start;
//		~rewTask.value(7,1,2,1,0, 200, 201, 202, 203, 204).start;
//		~rewTask.value(7,1,2,1,0, 200, 201, 202, 203, 204).start;
});

x.play;