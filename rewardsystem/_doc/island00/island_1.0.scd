//ISLAND_0

/*
explanation of filenames saved:
10501.save :
10 - group of musical files (cannot start with 01 due to reading issues)
01 - index
05 - number of notes (if TempoClock loop is used than rest of the notes is silent)
*/

~islandTask = Array.fill(10,{0});			// tasks for 10 islands
~presentIslet = 0; //start form beggining
~usedTasks = Array.fill(10,{nil});	// tasks rewCalcTask and rewTask


(
~islandTask[0] =


	Task({

		// quitUsedTasks is to stop runnig loops (~rewCalcTask and ~rewTasks)
		var quitUsedTasks = {

		x.stop; //stop rewardTasks and whatever is happening in prev islet

		~usedTasks.size.do{ |i|
				 if (~usedTasks[i].isNil,
				 {"~usedTasks is nil".postln;},
				 {~usedTasks[i].stop; ~usedTasks[i] = nil;};
				 );
				 };
				 };

		case	{~presentIslet == 0}
			{"Island_0.0".postln;
			//quitUsedTasks.value;
			"islet00music1.0.scd".loadRelative;

			}
		{~presentIslet == 1}
			{"Island_0.1".postln;
			// here instead .stoping them I should start a Function that sees the running once and stoppes them
			quitUsedTasks.value;
		1.wait;
			"islet01music1.0.scd".loadRelative;}
		{~presentIslet == 2}
			{"Island_0.2".postln;
			quitUsedTasks.value;
				1.wait;
			"islet02music1.0.scd".loadRelative;}
		{~presentIslet == 3}
			{"Island_0.3".postln;
			quitUsedTasks.value;
				1.wait;
			"islet03music1.0.scd".loadRelative;}
		{~presentIslet == 4}
			{"Island_0.4".postln;
			quitUsedTasks.value;
				1.wait;
			"islet04music1.0.scd".loadRelative;}
		{~presentIslet == 5}
			{"Island_0.4".postln;
			quitUsedTasks.value;
			"islet04music1.0.scd".loadRelative;}
		{~presentIslet == 6}
			{"Island_0.4".postln;
			quitUsedTasks.value;
				1.wait;
			"islet04music1.0.scd".loadRelative;}
		{~presentIslet == 7}
			{"Island_0.4".postln;
			quitUsedTasks.value;
				1.wait;
			"islet04music1.0.scd".loadRelative;}
		{~presentIslet == 8}
			{"Island_0.4".postln;
			quitUsedTasks.value;
				1.wait;
			"islet04music1.0.scd".loadRelative;}
		{~presentIslet == 9}
			{"Island_0.4".postln;
			quitUsedTasks.value;
				1.wait;
			"islet04music1.0.scd".loadRelative;}

		{~presentIslet == 99}
			{"quit Island".postln;
			quitUsedTasks.value;
			"islet99music1.0.scd".loadRelative;
			t.stop;

			}
		});



);



