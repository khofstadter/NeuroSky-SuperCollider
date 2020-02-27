// in and out in one function;
i = 0 ! 2 ! 8; //islets [islet number] [inout];

~presentIslet = 0;

~usedTasks = Array.fill(10,{nil});	// tasks rewCalcTask and rewTask

~guiTask = Task({

	~slider3.valueAction = ~aThVal/100;
	~slider4.valueAction = ~mThVal/100;
	~slider3.valueAction = ~aThVal/100;
	~slider4.valueAction = ~mThVal/100;
	~toMoveBox[0].valueAction = ~toMoveVal[0][1];
	~toMoveBox[1].valueAction = ~toMoveVal[0][2];
	~toMoveBox[2].valueAction = ~toMoveVal[0][3];
	~toMoveBox[3].valueAction = ~toMoveVal[1][1];
	~toMoveBox[4].valueAction = ~toMoveVal[1][2];
	~toMoveBox[5].valueAction = ~toMoveVal[1][3];

});

~quitUsedTasks = {

		// x.stop; //stop rewardTasks and whatever is happening in prev islet ???
		// why do you need to stop this?
		// why did you loose control over a constantSynth when x.stop was evaluated?

		~usedTasks.size.do{ |i|

			if (~usedTasks[i].isNil,
				{},
				{~usedTasks[i].stop; ~usedTasks[i] = nil;};
			);
		};
	};

// -------------------------------------------------------
