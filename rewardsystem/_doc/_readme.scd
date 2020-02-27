/*	INFO FOR REWARD CALCULATION TASK (~rewCalcTask) :

WHAT DOES ~rewCalcTask DO? :

	aThVal and mThVal when above Val do these:
	- starts all timers ( tm [0,0,0,0,0,0] )
	- triggers ~rewardPoints[0][0]
	- triggers ~rewardPoints[1][0]
	- increments ~rewardPoints[0][1]
	- increments ~rewardPoints[1][1]

	aTimeThVal and mTimeThVal when above TTH do these:
	- increments ~rewardPoints[0][2]
	- increments ~rewardPoints[1][2]

	toMoveVal when equals rewardPoints:
	- increments moveStep which will move system to next islet

*/


//to make :
~rewCalcTask.value(aThVal,mThVal,aTimeThVal,mTimeThVal,toMoveVal).start;


/*	INFO FOR REWARD TASKS (~rewTask):
		|track, idx0, idx1, style, fromBeat, loadFile0, loadFile1, loadFile2, loadFile3, loadFile4| - if only one file is needed then you don't have to add loadFile1, loadFile2, ...

		track : on which track/instrument shall it be played

		idx0 & idx1 : with the two coordinates you can define
		a Task in a 2D array called ~rewardPoints (in rewards.rtf);
		~rewardPoints [0][0-3] - to make attention rewardPoints Tasks
		~rewardPoints [1][0-3] - to make meditation rewardPoints Tasks
		[0][0] = Attention triggers above or beneath (0 down, 1 up)
		[1][0] = Meditation triggers above or beneath (0 down, 1 up)
		[0][1] = Attention above the Xth time
		[1][1] = Meditation above the Xth time
	 	[0][2] = Attention above time-threshold the Xth time
	 	[1][2] = Meditation above time-threshold the Xth time
//		[0][3] = Attention Max
//	 	[1][3] = Meditation Max

	 	REWARDPOINTS explained:

rewardPoints[0][0] :	switches it between 0 and 1, is it above or below TH
rewardPoints[0][1] :	increments with every step above TH
rewardPoints[0][2] :	increments when timer reaches TTH
rewardPoints[0][3] :	integer that shows the elapesed time above TH

same for Meditation max :
rewardPoints[1][0] :	switches it between 0 and 1

IN POSTWINDOW this is represented horizontaly:

                         rewardPoints [att],[med] :  [ [ 0, 1, 50, 375 ], [ 0, 0, 50, 557 ] ]
                         toMoveVal [att],[med]	   :  [ [ 0, 5, 1, 0 ], [ 0, 0, 0, 0 ] ]
tm: [ 375, 557, 1, 6, 556, 557 ]

...

	 	style : variaties of what shall be done when triggered
	 	//file is loaded above, nothing else to do
	 	{"style 0 - load file to played with ~sched".postln;}

		{style == 1}
		{"style 1 - play elastic once next beat".postln;
		t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}

		{style == 2}
		{"style 2 - play elastic once next bar + fromBeat".postln;
		t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}

	 	fromBeat can be an array as well if more loadFiles are used [0,8,0,4,1];

		loadFile : which saved file shall be played if sig above
		loadFileBeneath : which saved f. shall be played if sig beneath

		|track, idx0, idx1, style, fromBeat, loadFile0, loadFile1, loadFile2, loadFile3, loadFile4| - if only one file is needed the you don't have to add loadFile1, loadFile2, ...


*/

//example for rewTask
~rewTask.value(4,0,0,0,0, 200, 201).start;
