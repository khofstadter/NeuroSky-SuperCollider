// REWARD CALCULATION TASK (~rewCalcTask) & REWARD TASKS (~rewTask)
// TODO why is tm Array not integer?

~rewardPoints = Array.fill2D(2, 4,{0});
~attention=0;
~meditation=0;

(
/* REWARD CALCULATION TASK (~rewCalcTask)

1) MOVE (move function)
- is triggered when movement to another islet is needed (can be done manually too);
- is done when ~rewardPoints are reached;
- ~rewardPoints use timer (task) for update;

2) TIMER (timer task)
Consists of 6 timers, which when triggerd increment or amend '~rewardPoints':

tm [0,0,0,0,0,0]:
0:[ATT above TH in sec (restarts when ATT goes below TH),
1: MED above TH in sec (restarts when MED goes below TH),
2: ATT TTH loop (restarts when TTH reached),
3: MED TTH loop (restarts when TTH reached),
4: ATT OVERALL TIME above TH (only restarts when next islet is reached),
5: MED OVERALL TIME above TH (only restarts when next islet is reached)]

further explanation:
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

toMoveVal when equals ~rewardPoints:
- increments moveStep which will move system to next islet


//to make :
//~rewCalcTask.value(aTimeThVal,mTimeThVal,toMoveVal).start;

*/
~rewCalcTask = { arg aTimeThVal=10, mTimeThVal=10, toMoveVal=Array.fill2D(2, 4,{0});
    var attNewVal=0, medNewVal=0, attSwitch=false, medSwitch=false, moveStep=0;
    var timer, tmPost, timerAtt0, timerMed0, timerAtt1, timerMed1, timerAtt2, timerMed2;
    var tm = Array.fill(6,{0});
    var maxA = 0, maxM = 0; //do I still need this?
    var toMoveTrueArrayCheck = Array.fill2D(2, 4, {false});
    var toMoveTrueArray = Array.fill2D(2, 4, {true});
    var victoryDone = 0;

    //function to move to a new islet (stage)
    //case is used so we have to option to manually move up/down
    var stopTimer = {
        //stop timer and reset ~rewardPoints
        timerAtt0.stop;
        timerMed0.stop;
        timerAtt1.stop;
        timerMed1.stop;
        timerAtt2.stop;
        timerMed2.stop;
        ~rewardPoints = Array.fill2D(2, 4,{0});
        tmPost.stop;
    };

    ~rewardPoints = Array.fill2D(2, 4,{0});
    "start rewardTask".postln;
    Task({

        // timer
        timer = { |index|
            Task({
                //			var min, secs, allsecs;
                inf.do({ arg i;
                    //			min = (i/60).asInteger;
                    //			secs = (i % 60);
                    //			allsecs = i;
                    tm[index] = i.asInteger;
                    1.wait;
                });
            });
        };


        // tm postln once
        tmPost =
        Task({

            inf.do({
                ("tm:"+tm).postln;
                ("                         ~rewardPoints [att],[med] : "+~rewardPoints).postln;
                ("                         toMoveVal [att],[med]	   : " + toMoveVal).postln;
                1.wait;
            });
        });


        //tmPost.start; // posts the tm (array with 6 timers made below)

        //reward Timers (arguments are index numbers)
        // tm: [0,0,0,0,0,0]
        // :
        // [att max, med max, att threshold, med threshold, att overall, med overall]

        // max time above threshold
        // attention
        // reward0A
        timerAtt0 = timer.value(0).start;
        // meditation
        // reward0M
        timerMed0 = timer.value(1).start;

        // threshold	circle
        // attention
        // reward2A
        timerAtt1 = timer.value(2).start;
        // meditation
        // reward2M
        timerMed1 = timer.value(3).start;

        // overall time above threshold
        // attention
        // reward3A
        timerAtt2 = timer.value(4).start;
        // meditation
        // reward3M
        timerMed2 = timer.value(5).start;


        inf.do({
            attNewVal=~attention;
            medNewVal=~meditation;

            // to move from practice islet to island 0

            if ( ~manualMove == 1, {stopTimer.value; ~manualMove = nil};);

            //[0][0] = Attention triggers above or beneath TH(0 down, 1 up)
            //[0][1] = Attention above TH the 'x'th time

            // Attention max
            if	(attNewVal > ~aThVal, {
                if	(attSwitch == true, {
                    // "attention above threshold".postln;
                    timerAtt0.start;
                    timerAtt1.start;
                    timerAtt2.resume; //why resume why not start

                    ~rewardPoints[0][0] = 1;
                    ("
~rewardPoints[0][0] :"+1+"( ATT above TH )").postln;
                    ~rewardPoints[0][1] = (~rewardPoints[0][1])+1;
                    ("
~rewardPoints[0][1] :" + ~rewardPoints[0][1] + "( ATT above TH so many times)").postln;
                    attSwitch = false;
                });
            },
            {
                if	(attSwitch !== true, {
                    // "attention under threshold".postln;
                    timerAtt0.pause;
                    timerAtt1.pause;
                    timerAtt2.pause;
                    ~rewardPoints[0][3] = tm[0];
                    ("
~rewardPoints[0][3] :" + tm[0] + "( ATT max sustain time )").postln;
                    ~rewardPoints[0][0] = 0;
                    ("
~rewardPoints[0][0] :"+0+"( ATT beneath TH )").postln;
                    attSwitch = true});
            });

            //[1][0] = Meditation triggers above or beneath TH(0 down, 1 up)
            //[1][1] = Meditation above TH the 'x'th time

            // Meditation max

            if	(medNewVal > ~mThVal, {
                if	(medSwitch == true, {
                    // "meditation above threshold".postln;
                    timerMed0.start;
                    timerMed1.start;
                    timerMed2.resume;
                    //bang when going above threshold
                    ~rewardPoints[1][0] = 1;
                    ("
~rewardPoints[1][0] :"+1+"( MED above TH )").postln;
                    ~rewardPoints[1][1] = (~rewardPoints[1][1])+1;
                    ("
~rewardPoints[1][1] :" + ~rewardPoints[1][1] + "( MED above TH so many times)").postln;
                    medSwitch = false});
            },
            {
                if	(medSwitch !== true, {
                    // "meditation under threshold".postln;
                    timerMed0.pause;
                    timerMed1.pause;
                    timerMed2.pause;
                    ~rewardPoints[1][3] = tm[1];
                    ("
~rewardPoints[1][3] :" + tm[0] + "( MED max sustain time )").postln;
                    ~rewardPoints[1][0] = 0;
                    ("
~rewardPoints[1][0] :"+0+"( MED beneath TH )").postln;
                    medSwitch = true});
            });

            //[0][2] = Attention above TTH the Xth time

            if	(tm[2] >= aTimeThVal, {
                tm[2] = 0;
                timerAtt1.reset;
                ~rewardPoints[0][2] = (~rewardPoints[0][2])+1;
                ("
~rewardPoints[0][2] :"+~rewardPoints[0][2] + "( ATT reached TTH that many times)").postln;

                1.wait; //to make sure the other Task catches change
            });

            //[1][2] = Meditation above TTH the Xth time

            if	(tm[3] >= mTimeThVal, {
                tm[3] = 0;
                timerMed1.reset;
                ~rewardPoints[1][2] = (~rewardPoints[1][2])+1;
                ("
~rewardPoints[1][2] :"+~rewardPoints[1][2] + "( MED reached TTH that many times)").postln;

                1.wait; //to make sure the other Task catches change
            });

            //check whether ~rewardPoints have met the requirement
            //whether it is to move to the next islet

            1.do{ toMoveTrueArrayCheck = ~rewardPoints >= toMoveVal};

            //if this true, the challenge is achieved, ~rewardPoints have met the requirements
            //it's time to move on to the next islet

            if	(toMoveTrueArrayCheck == toMoveTrueArray, {
                if(~autoMove == 1, {
                    "TODO: add victory sound".postln;
                    stopTimer.value; //stopTimer
                    i[~presentIslet][1].reset.play;
                });
                if(victoryDone == 0,{
                    victoryDone = 1;
                    "TODO: add victory sound".postln;
                    t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(9).play});
                })
            });

            Task({ ~rewardPointsBox[0].valueAction = ~rewardPoints[0][1];}).start(AppClock);
            Task({ ~rewardPointsBox[1].valueAction = ~rewardPoints[0][2];}).start(AppClock);
            Task({ ~rewardPointsBox[2].valueAction = ~rewardPoints[0][3];}).start(AppClock);
            Task({ ~rewardPointsBox[3].valueAction = ~rewardPoints[1][1];}).start(AppClock);
            Task({ ~rewardPointsBox[4].valueAction = ~rewardPoints[1][2];}).start(AppClock);
            Task({ ~rewardPointsBox[5].valueAction = ~rewardPoints[1][3];}).start(AppClock);

            Task({ ~tthKnob[0].valueAction = tm[2]/~aTimeThVal;}).start(AppClock);
            Task({ ~tthKnob[1].valueAction = tm[3]/~mTimeThVal;}).start(AppClock);


            0.2.wait;
        });
    });

});









(
/*
REWARD TASKS (~rewTask)
that when '~rewardPoints array' changes trigger sounds or certain musical behaviours

|track, idx0, idx1, style, fromBeat, loadFile0, loadFile1, loadFile2, loadFile3, loadFile4| - if only one file is needed then you don't have to add loadFile2, ...

track : on which track/instrument shall it be played

idx0 & idx1 : with these two coordinates you can define
a Task in a 2D array called ~rewardPoints (in rewards.rtf);
~rewardPoints [0][0-3] - to make attention ~rewardPoints Tasks
~rewardPoints [1][0-3] - to make meditation ~rewardPoints Tasks
[0][0] = Attention triggers above or beneath (0 down, 1 up)
[1][0] = Meditation triggers above or beneath (0 down, 1 up)
[0][1] = Attention above the Xth time
[1][1] = Meditation above the Xth time
[0][2] = Attention above time-threshold the Xth time
[1][2] = Meditation above time-threshold the Xth time
[0][3] = Attention Max
[1][3] = Meditation Max

~rewardPoints explained:

~rewardPoints[0][0] :	switches it between 0 and 1, is it above or below TH
~rewardPoints[0][1] :	increments with every step above TH
~rewardPoints[0][2] :	increments when timer reaches TTH
~rewardPoints[0][3] :	integer that shows the elapesed time above TH

same for Meditation max :
~rewardPoints[1][0] :	switches it between 0 and 1

IN POSTWINDOW this is represented horizontaly:

~rewardPoints [att],[med] :  [ [ 0, 1, 50, 375 ], [ 0, 0, 50, 557 ] ]
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




//example for rewTask
//~rewTask.value(4,0,0,0,0, 200, 201).start;

*/


~rewTask = { |track, idx0, idx1, style, fromBeat, loadFile0, loadFile1, loadFile2, loadFile3, loadFile4|
    //fromBeat is an array [0,0,0,0,0] to start all from 0
    //fromBeat is only used when sheduling ~schedElasticOnce
    var newVal = 0, oldVal=0;
    var usedTask = Array.fill(10,{0}); //common name for Tasks within

    Task({

        // (0)	Above or Below TH

        if	(idx1 == 0,
            {
                inf.do({

                    newVal = ~rewardPoints[idx0][idx1];
                    if (newVal !== oldVal, {
                        if (newVal == 1, {
                            ("rewPoint index:"+idx0+idx1+"ABOVE").postln;
                            ~loadFile.value(track, loadFile0); //value: track, filename

                            "above".postln;
                            ("track:"+track).postln;
                            ("fromBeat:"+fromBeat).postln;

                            case	{style == 0}
                            //file is loaded above, nothing else to do
                            {"style 0 - load file to played with ~sched".postln;}
                            {style == 1}
                            {"style 1 - play elastic once next beat".postln;
                                t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                            {style == 2}
                            {"style 2 - play elastic once next bar + fromBeat".postln;
                                t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}

                        },

                        {("rewPoint index:"+idx0+idx1+"BENEATH").postln;

                            ~loadFile.value(track, loadFile1); //value: track, filename

                            "beneath".postln;
                            ("track:"+track).postln;

                            ("fromBeat:"+fromBeat).postln;

                            case	{style == 0}
                            //file is loaded above, nothing else to do
                            {"style 0 - load file to played with ~sched".postln;}
                            {style == 1}
                            {"style 1 - play elastic once next beat".postln;
                                t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                            {style == 2}
                            {"style 2 - play elastic once next bar + fromBeat".postln;
                                t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}

                        });
                    };);
                    oldVal = newVal;
                    0.2.wait;
                });
            }; //case 0 end
        ); //end if



        // (1) Above TH (5 steps %5)
        // every time the signal goes above TH it will trigger the selected syle below:

        if	(idx1 == 1,


            {inf.do({

                newVal = (~rewardPoints[idx0][idx1]) % 5;
                if (newVal !== oldVal, {
                    "A ENTERED ABOVE THE THRESHOLD the ...".postln;
                    case {newVal == 0}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile0); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal == 1}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile1); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal == 2}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile2); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal == 3}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile3); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal == 4}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile4); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }
                };);

                oldVal = newVal;

                0.2.wait;
            });
            }; //case 1 end
        ); //end if


        // (2) Above TTH (5 steps %5)
        // style below is triggered with signal is above TTH

        if	(idx1 == 2,
            {inf.do({

                newVal = (~rewardPoints[idx0][idx1]) % 5;
                if (newVal !== oldVal, {
                    "A STAYED ABOVE THRESHOLD for X Period ...".postln;
                    case {newVal == 0}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile0); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal == 1}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile1); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}				}

                    {newVal == 2}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile2); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}

                    }

                    {newVal == 3}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile3); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal == 4}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile4); //value: track, filename

                        case	{style == 0}
                        {"style 0 - play elastic once next beat".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next bar + fromBeat".postln;}
                        {style == 2}
                        {"style 2 - load file to played with ~sched".postln;}

                    }
                };);

                oldVal = newVal;

                0.2.wait;
            });
            }; //case 1 end
        ); //end if

        // (3) MAXIMUM REACHES THRESHOLDS (5)

        if	(idx1 == 3,
            {inf.do({

                newVal = (~rewardPoints[idx0][idx1]);
                if (newVal !== oldVal, {
                    "MAXIMUM ...".postln;
                    case {newVal > 100}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile4); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal > 50}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile3); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}

                    }

                    {newVal > 30}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile2); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                    {newVal > 20}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile1); //value: track, filename

                        case	{style == 0}
                        {"style 0 - play elastic once next beat".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next bar + fromBeat".postln;}
                        {style == 2}
                        {"style 2 - load file to played with ~sched".postln;}
                    }

                    {newVal > 10}

                    {("rewPoint index:"+idx0+idx1+newVal+"TIME").postln;
                        ~loadFile.value(track, loadFile0); //value: track, filename

                        case	{style == 0}
                        //file is loaded above, nothing else to do
                        {"style 0 - load file to played with ~sched".postln;}
                        {style == 1}
                        {"style 1 - play elastic once next beat".postln;
                            t.schedAbs(t.beats.ceil, {~schedElasticOnce.value(track).play})}
                        {style == 2}
                        {"style 2 - play elastic once next bar + fromBeat".postln;
                            t.schedAbs(t.nextBar+fromBeat, {~schedElasticOnce.value(track).play})}
                    }

                };);

                oldVal = newVal;

                0.2.wait;
            });
            }; //case 1 end
        ); //end if

    });
};
);