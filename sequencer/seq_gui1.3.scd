var guiTask;
var window = Window.new("seq", Rect(0, 0, 1155, 515)).front;
var spectrum = Window("Spectrum", Rect(1155, 0, 280, 200)); // width should be 511
var fSw = FreqScopeView(spectrum, spectrum.view.bounds);
var composite = CompositeView(window, Rect(0, 0, 1155, 500));
var guihelp;
var tempoButton; //only one needed, therefore not in guiTask
var compressorButton; //only one needed, therefore not in guiTask

//memories are used to save and load patters on the fly
~memory = Array.fill2D(4, 4, {Array.fill2D(4, ~beat, {0})});
~memoryGlobal = Array.fill2D(4, ~beat, {0});

// control Specs
~pitchSpec = # [36, 107, \lin, 1, 0].asSpec;
~ampSpec = #[0, 1, \lin, 0.01].asSpec;
~susSpec = #[0, 5, \lin, 0.01].asSpec;
~edurSpec = #[0.01, 2, \lin, 0.01].asSpec;

window.front;
spectrum.front;
fSw.active_(true); // turn it on the first time;
spectrum.onClose_({ fSw.kill }); // you must have this


//guiTask is the Function used to make all contol GUI for each track
guiTask = { |track, pos0, pos1|
	var synthChoice = 0 ! 2;
	var onOffButton = 0 ! 2;
	var randomWriteButton;
	var randomFill = 0; // used in slider[2], 0 gives you many notes, 0< less
	var volumeControl = 0 ! 2;
	var slider = 0 ! 3;
	var synthNb;
	var multiSlider = Array.fill(4, {0 ! ~beat});
	var schedElasticOnceButton;
	var schedElasticLoopButton;
	var schedElasticBeatNbBox;
	var constantSynthFreqNbBox;
	var constantSynthFreq;
	var saveFileBox, loadFileBox;
	var saveButtonGlobal, loadButtonGlobal;
	var saveButton = Array.fill(4, {0});
	var loadButton = Array.fill(4, {0});
	var constantSynthVol;
	var midiOr;

	// for Patterns from String
	// this string replacer part is from a R.Hoadley code
	var pPattern;
	var pPatArray;
	var pPatStrF = {|str|
		str = str.replace("   ", " ");
		str = str.replace("  ", " ");
		str = str.replace(" ", ", ");
		str = format("[%]", str).interpret;
	};

	var pPatArray2 = 0 ! ~beat;
	var pPatStrF2 = {|str|
		str = str.replace(" ", "");
		str = str.replace("[", "");
		str = str.replace("]", "");
		str = str.replace(",", " ");
		str.postln;
	};


	var mSActionFill = {
	//it is not a valueAction as ~write already fills p [array for patterns]
		Task({
			//fill pPattern QTextView
			pPatArray2 = Array.fill(~beat, {|i|
					if( p[track][i][0] != nil,
					{ (p[track][i][0])},
					{ 0 }
					);
				});

			("pPatArray2:" + pPatArray2;).postln;
			pPatArray2 = pPatStrF2.value(pPatArray2.asString);
			("this : " + pPatArray2).postln;
			pPattern.setString (pPatArray2.asString, 0, 32);


					multiSlider[0].value = Array.fill(~beat, {|i|
					if( p[track][i][0] != nil,
					{ (p[track][i][0]).linlin(36, 107, 0.0, 1.0)},
					{ 0 }
					);
				});


				multiSlider[1].value = Array.fill(~beat, {|i|
					if( p[track][i][1] != nil,
					{ p[track][i][1].linlin(0.0, 1.0, 0.0, 1) },
					{ 0 }
					);
				});

				multiSlider[2].value = Array.fill(~beat, {|i|
					if( p[track][i][2] != nil,
					{ (p[track][i][2]).linlin(0.0, 5, 0.0, 1.0) },
					{ 0 }
					);
				});

				multiSlider[3].value = Array.fill(~beat, {|i|
					if( p[track][i][3] != nil,
					{ (p[track][i][3]).linlin(0.0, 2, 0.0, 1.0) },
					{ 0 }
					);
				});
				}).play(AppClock);

};

var fillPfromGlobalMemory = { |track|
	//it is not a valueAction as ~write already fills p [array for patterns]
		Task({
			~beat.do{|i|
				p[track][i][0] = if(~memoryGlobal[0][i] == 0,

					{nil},
					{(~memoryGlobal[0][i]).linlin(0.0, 1.0, 36, 107).round(0.1) });


				p[track][i][1] = if(~memoryGlobal[1][i] == 0,

					{nil},
					{(~memoryGlobal[1][i]).linlin(0.0, 1.0, 0.0, 1.0).round(0.1) });



				p[track][i][2] = (~memoryGlobal[2][i]).linlin(0.0, 1.0, 0.0, 5).round(0.01);
				p[track][i][3] = (~memoryGlobal[3][i]).linlin(0.0, 1.0, 0.01, 2).round(0.01);
			};
		});
};

	Task ({
			if	(track == 0,
		{
			tempoButton = Button(composite, Rect(930,0,50,20))
					.states_([
						["start", Color.white, Color.black],
						["stop", Color.black, Color.red],])
					.action_({ arg butt;

						case 	{butt.value == 0} {"stop".postln;
								t.stop;

								}

								{butt.value == 1} {"play".postln;
								"start Tempo (t)" .postln;
								t = TempoClock(5);

								t.schedAbs(t.nextBar, {t.beatsPerBar_(~beat)});
								t.play({arg beat; ( ~counter=(beat.round)%~beat);
								~playTask.value.play; 1});
																};
									});


				//tempoSpeed = Knob.new(c, Rect(885,25,25,25))
//				.value_(0.074)
//				//save from tempoClock reaching 0, server crash
//				.action_({ |v|
//
//
//						if ( v.value < 0.01, {v.value = 0.01}, {});
//						tempoSpeed = ~tempoSpec.map(v.value.round(0.01));
//						tempoSpeed.postln;
//						q = Array.fill(~beat, {tempoSpeed});
//							});
//
//



//				tempoMultiSlider = GUI.multiSliderView.new(c, Rect(955,0,150,50));
//				tempoMultiSlider.value_(0.2313 ! ~beat)
//				.thumbSize_(tempoMultiSlider.bounds.width / q.size - 5)
//				.gap_(5)
//				.action_({ |view|
//					view.value.do({ |x, i|
//						if ( x < 0.01, {x = 0.01}, {});
//						q[i] = ~tempoSpec.map(x.round(0.01))});
//						});

// compressor button
			compressorButton = Button(composite, Rect(990,0,120,20))
								.states_([
									["compressor off", Color.white, Color.black],
									["compressor on", Color.black, Color.red
],])
								.action_({ arg butt;
									case 	{butt.value == 0} {"compressor off".postln;
										~comp.free;
											}
											{butt.value == 1} {"compressor on".postln;
										~comp = Synth(\compressor, addAction: \addToTail);
											}});
		}); // end if;


// synthChoice
	synthChoice[1] = EZPopUpMenu.new(composite, Rect(pos0+27, pos1, 110, 20),
	track,
	[
		\sine ->		{~synth[track] = \sine},
		\synht1 ->		{~synth[track] = \synht1},
		\windpad ->	{~synth[track] = \windpad},
		\saw ->		{~synth[track] = \saw},
		\bells ->		{~synth[track] = \bells},
		\simpleFM ->	{~synth[track] = \simpleFM},
		\FM1 ->		{~synth[track] = \FM1},
		\FM2 ->		{~synth[track] = \FM2},
		\FM3 ->		{~synth[track] = \FM3},
		\FM4 ->		{~synth[track] = \FM4},
		\bells2 ->		{~synth[track] = \bells2},
		\nice1 ->		{~synth[track] = \nice1},
		\nice2 ->		{~synth[track] = \nice2},
		\nice3 ->		{~synth[track] = \nice3},
		\ring1 ->		{~synth[track] = \ring1},
		\newFM1 ->		{~synth[track] = \newFM1},
		\newFM2 ->		{~synth[track] = \newFM2},
		\newFM3 ->		{~synth[track] = \newFM3},
		\newFM4 ->		{~synth[track] = \newFM4},
		\laserbeam ->		{~synth[track] = \laserbeam},
		\moogbasstone ->		{~synth[track] = \moogbasstone},
		\moogbasstone2 ->		{~synth[track] = \moogbasstone2},
		\mrostinato ->		{~synth[track] = \mrostinato},
		\plastickystrings ->		{~synth[track] = \plastickystrings},
		\bassfoundationandhighend ->		{~synth[track] = \bassfoundationandhighend},
				\windX ->	{~synth[track] = \windX},


	],
	initVal: 0,
	initAction: true,
	labelWidth: 30,
	labelHeight: 20,
	layout: \horz,
	gap: 2@2
	);



//engage Loop with TempoClock in ~playTask (file: streams)
	onOffButton[1] = Button(composite, Rect(pos0+10,pos1+2,35,17))
				.states_([
			["off", Color.white, Color.black],
			["on", Color.black, Color.red(0.7)]])
				.action_({ arg butt;
					case 	{butt.value == 0} {("stop "+track);
										~onOff[track] = 0;
										}
							{butt.value == 1} {("play "+track);
									~onOff[track] = 1;
										};
		});

//volumeControl
	volumeControl[1] = Knob.new(composite, Rect(pos0+143,pos1,25,25))
				.action_({ |v|
					m[track] = v.value;
							});

// ELASTIC LOOP'S CONTROL
// schedule elastic Once
	schedElasticOnceButton = Button(composite, Rect(pos0+10,pos1+33,13,13))
				.states_([
					["e", Color.white, Color.black]])
				.action_({ arg butt;
					// ("play once"+track).postln;
					~schedElasticOnce.value(track).play;
							});
// Elastic Loop 1
// play and pause of elastic loop
	schedElasticLoopButton = Button(composite, Rect(pos0+30,pos1+30,80,17))
				.states_([
					["eLoop1 Off", Color.white, Color.black(0.7)],["eLoop1 On", Color.black, Color.red]
					])
				.action_({ arg butt;
					case 	{butt.value == 0} {("stop ~schedElasticLoop on track "+track).postln;
									~schedElasticLoopPlay[track].stop;
									}
							{butt.value == 1} {("play ~schedElasticLoop on track "+track).postln;
									~schedElasticLoopPlay[track] = ~schedElasticLoop.value(track).play;
									};
		});

// change ~eBeat for ~schedElasticOnce (on which beat (tempoClock) shall the pattern be played
	schedElasticBeatNbBox = NumberBox(composite, Rect(pos0+10,pos1+50,23,19))
		.value_(0)
		.clipLo_(0)
		.clipHi_(~beat-1)
		.action_({ arg numb;
			~eBeat[track] = schedElasticBeatNbBox.value;
			~eBeat[track].postln;
							});

// Elastic Loop 2
// play and pause of elasticOnce that is scheduled with TempoClock (in ~playTask)
	schedElasticLoopButton = Button(composite, Rect(pos0+35,pos1+50,80,17))
				.states_([
					["eLoop2 Off", Color.white, Color.black(0.7)],["eLoop2 On", Color.black, Color.red]
					])
				.action_({ arg butt;
					case 	{butt.value == 0} {("stop ~schedElasticLoop2 on track "+track).postln;
									~onOffElastic[track] = 0;
									}
							{butt.value == 1} {("play ~schedElasticLoop2 on track "+track).postln;
									~onOffElastic[track] = 1;
									};
		});

// loadFileBox for all 10 tracks
	loadFileBox = TextField(composite, Rect(pos0+170, pos1+25, 50, 20))
	.string_("load")
	.action_({arg field; field.value.postln;
				~loadFile.value(track, field.value); //value: track, filename
				//put in a function and filter nil's out (linlin doesn't understand nil) ???
			if	(track <= 3,
			{
			mSActionFill.value;
			},
			{
				"no multislider".postln;
				}
			;);
		});


//midiOr
midiOr = EZPopUpMenu.new(composite, Rect(pos0+80, pos1+30, 80, 20),
	track,
	[
				\out ->		{~midiOrVal[track] = 0},
				\midi ->		{~midiOrVal[track] = 1},
	],
	initVal: 0,
	initAction: true,
	labelWidth: 30,
	labelHeight: 20,
	layout: \horz,
	gap: 2@2
	);


//contols for track 0,1,2,3 we need multisliders
if	(track <= 3,
	{

// randomize patterns in the chosen scale
	randomWriteButton = Button(composite, Rect(pos0+223, pos1, 10, 10))
				.states_([
					["r", Color.white, Color.black]])
				.action_({ arg butt;
					~write.value(track, randomFill, ~scaleNb);
					mSActionFill.value;
							});

// slider for the amount of notes to be randomized for ~write.value(track, 10, ~scaleNb);
	slider[2] = Slider(composite, Rect(pos0+223, pos1+15, 10, 45))
                .action_({
					randomFill = (slider[2].value*20).round;
                });

//save and load buttons
	saveButton[0] = Button(composite, Rect(pos0+171,pos1+50,10,10))
		.states_([["s", Color.black, Color.red],])
		.action_({
		~memory[track][0][0] = multiSlider[0].value;
		~memory[track][0][1] = multiSlider[1].value;
		~memory[track][0][2] = multiSlider[2].value;
		~memory[track][0][3] = multiSlider[3].value;
		"done".postln;
		});

	loadButton[0] = Button(composite, Rect(pos0+171,pos1+60,10,10))
		.states_([["l", Color.white]])
		.action_({
		multiSlider[0].valueAction = ~memory[track][0][0];
		multiSlider[1].valueAction = ~memory[track][0][1];
		multiSlider[2].valueAction = ~memory[track][0][2];
		multiSlider[3].valueAction = ~memory[track][0][3];
		"done".postln;
			});

	saveButton[1] = Button(composite, Rect(pos0+181,pos1+50,10,10))
		.states_([["s", Color.black, Color.red],])
		.action_({
		~memory[track][1][0] = multiSlider[0].value;
		~memory[track][1][1] = multiSlider[1].value;
		~memory[track][1][2] = multiSlider[2].value;
		~memory[track][1][3] = multiSlider[3].value;
		"done".postln;
		});

	loadButton[1] = Button(composite, Rect(pos0+181,pos1+60,10,10))
		.states_([["l", Color.white]])
		.action_({
		multiSlider[0].valueAction = ~memory[track][1][0];
		multiSlider[1].valueAction = ~memory[track][1][1];
		multiSlider[2].valueAction = ~memory[track][1][2];
		multiSlider[3].valueAction = ~memory[track][1][3];
		"done".postln;
			});

	saveButton[2] = Button(composite, Rect(pos0+191,pos1+50,10,10))
		.states_([["s", Color.black, Color.red],])
		.action_({
		~memory[track][2][0] = multiSlider[0].value;
		~memory[track][2][1] = multiSlider[1].value;
		~memory[track][2][2] = multiSlider[2].value;
		~memory[track][2][3] = multiSlider[3].value;
		"done".postln;
		});

	loadButton[2] = Button(composite, Rect(pos0+191,pos1+60,10,10))
		.states_([["l", Color.white]])
		.action_({
		multiSlider[0].valueAction = ~memory[track][2][0];
		multiSlider[1].valueAction = ~memory[track][2][1];
		multiSlider[2].valueAction = ~memory[track][2][2];
		multiSlider[3].valueAction = ~memory[track][2][3];
		"done".postln;
			});



	saveButtonGlobal = Button(composite, Rect(pos0+206,pos1+50,10,10))
		.states_([["s", Color.green, Color.blue],])
		.action_({ arg butt;
		("save global on track"+track).postln;
		~memoryGlobal[0] = multiSlider[0].value;
		~memoryGlobal[1] = multiSlider[1].value;
		~memoryGlobal[2] = multiSlider[2].value;
		~memoryGlobal[3] = multiSlider[3].value;
		});

	loadButtonGlobal = Button(composite, Rect(pos0+206,pos1+60,10,10))
		.states_([["l", Color.white]])
		.action_({ arg butt;
		("load global on track"+track).postln;
		multiSlider[0].valueAction = ~memoryGlobal[0].copy;
		multiSlider[1].valueAction = ~memoryGlobal[1].copy;
		multiSlider[2].valueAction = ~memoryGlobal[2].copy;
		multiSlider[3].valueAction = ~memoryGlobal[3].copy;
			"done".postln;
			});

// saveFileBox only for 4 tracks
	saveFileBox = TextField(composite, Rect(pos0+170, pos1, 50, 20))
	.string_("save")
	.action_({arg field; field.value.postln;
				~saveFile.value(track, field.value); //value: track, filename
					AppClock.sched(2.0, {saveFileBox.value = "save";});


				});


//multisliders

	multiSlider[0] = MultiSliderView(composite, Rect(pos0+10, pos1+80, 230, 60));
	multiSlider[0].value_(0 ! ~beat)
	.thumbSize_(multiSlider[0].bounds.width / ~beat-1)
	.colors_(Color.black, Color.blue(0.7,0.2))
	.isFilled_(true)
	.action_({ |view|
		view.value.do({ |x, i| p[track][i][0] = ~pitchSpec.map(x.round(0.01));
		// change p array as if nil > synth is not made
			if (x==0,
				{ p[track][i][0] = nil},
			//false
			{p[track][i][0] = x.linlin(0, 1, 36, 107, nil).round;}
						);
			});
	});

	multiSlider[1] = MultiSliderView(composite, Rect(pos0+10, pos1+170, 230, 50));
	multiSlider[1].value_(0 ! ~beat)
	.thumbSize_(multiSlider[1].bounds.width / ~beat-1)
	.colors_(Color.black, Color.red(0.7,0.2))
	.isFilled_(true)
	.action_({ |view|
		view.value.do({ |x, i|
			if (x==0,
			//true
			{ p[track][i][1] = nil},
			//false
			{p[track][i][1] = ~ampSpec.map(x.round(0.01))};
				); //end if
			});
				});

	multiSlider[2] = MultiSliderView(composite, Rect(pos0+10, pos1+240, 230, 50));
	multiSlider[2].value_(0 ! ~beat)
	.thumbSize_(multiSlider[2].bounds.width / ~beat-1)
	.colors_(Color.black, Color.green(0.7,0.2))
	.isFilled_(true)
	.action_({ |view|
		view.value.do({ |x, i| p[track][i][2] = ~susSpec.map(x.round(0.01)) });
				});

	multiSlider[3] = MultiSliderView(composite, Rect(pos0+10, pos1+300, 230, 100));
	multiSlider[3].value_(0 ! ~beat)
	.thumbSize_(multiSlider[3].bounds.width / ~beat-1)
	.colors_(Color.black, Color.white(0.3,0.1))
	.action_({ |view|
		view.value.do({ |x, i|
		//	if ( x < 0.01, {x = 0.01}, {}); //do wait loop crash if all 0
			p[track][i][3] = ~edurSpec.map(x.round(0.01)) });
				});

//strings
	pPattern = QTextView.new(composite, Rect(pos0+10, pos1+140, 230, 20))
	.font_(Font("Helvetica", 7))
	.keyDownAction = {|view,char,modifiers,unicode,keycode,array|

	if ((unicode==32), {
						pPatArray = pPatStrF.value(pPattern.string);
						pPatArray.postln;
						u = pPatArray.linlin(36,107,0.0,1.0).round(0.01);
						// this array has limited extension, it cannot be longer than ~beat
						multiSlider[0].valueAction = u.extend(~beat, 0);
											});
			};

//constantSynth control


// synthChoice
	synthChoice[0] = EZPopUpMenu.new(composite, Rect(pos0, pos1+400, 100, 20),
	track,
	[

		\sine ->		{~synth2[track] = \constantsine},
		\synht1 ->		{~synth2[track] = \constantsynht1},
		\windpad ->	{~synth2[track] = \constantwindpad},
		\saw ->		{~synth2[track] = \constantsaw},
		\bells ->		{~synth2[track] = \constantbells},
		\simpleFM ->	{~synth2[track] = \constantsimpleFM},



	],
	initVal: 0,
	initAction: true,
	labelWidth: 30,
	labelHeight: 20,
	layout: \horz,
	gap: 2@2
	);


//volumeControl
	volumeControl[0] = Knob.new(composite, Rect(pos0+105,pos1+400,25,25))
                .action_({ |v|
                    ~m2[track] = v.value;

				if (~constantSynth[track] != nil,


						{~constantSynth[track].set(\master, v.value);})


                });

// make constantSynth [on] and  free it[off]
	onOffButton[0] = Button(composite, Rect(pos0+135,pos1+400,35,17))
                .states_([
					["on", Color.black, Color.red(0.7)],
                    ["off", Color.white, Color.black],])
                .action_({ arg butt;
                    case 	{butt.value == 0} {("stop "+track).postln;
                        // a Task to check whether the synth is still alive are or not
                        Task {if (~constantSynth[track].isPlaying !== true,
                            {"~constantSynth is playing > free".postln;
                                ~constantSynth[track].free;
                                ~constantSynth[track] = nil; },

                            )
                        }.start;

										}

					{butt.value == 1} {("play "+track);



				~constantSynth[track] =
						Synth( ~synth2[track], [ \freq, constantSynthFreq,
					\amp, 0.5,
					\master,~m2[track],
					\out, ~out,
					\change0, slider[0].value,
							\change1, slider[1].value,
						]);



				};
				});

// change ~eBeat for ~schedElasticOnce (on which beat (tempoClock) shall the pattern be played
	constantSynthFreqNbBox = NumberBox(composite, Rect(pos0+175,pos1+400,35,17))
		.value_(0)
		.clipLo_(1)
		.clipHi_(107)
		.action_({ arg numb;
			constantSynthFreq = constantSynthFreqNbBox.value;
			constantSynthFreq.postln;
			~constantSynth[track].set(\freq, constantSynthFreqNbBox.value;);
							});



slider[0] = Slider(composite, Rect(pos0+5, pos1+430, 100, 20))
                .action_({

				~constantSynth[track].set(\change0, slider[0].value;);
                });

slider[1] = Slider(composite, Rect(pos0+110, pos1+430, 100, 20))
                .action_({
				~constantSynth[track].set(\change1, slider[1].value);
                });


},
// if track is > 3 (track 4,5,6,7,8,9)
// less additional GUI control
{
	/*saveButtonGlobal = Button(composite, Rect(pos0+170,pos1+50,10,10))
		.states_([["s", Color.black, Color.red],])
		.action_({ arg butt;
		("save global on track"+track).postln;
		~memoryGlobal[0] = multiSlider[0].value;
		~memoryGlobal[1] = multiSlider[1].value;
		~memoryGlobal[2] = multiSlider[2].value;
		~memoryGlobal[3] = multiSlider[3].value;
		});*/

	loadButtonGlobal = Button(composite, Rect(pos0+170,pos1+60,10,10))
		.states_([["l", Color.white]])
		.action_({ arg butt;
		("load global on track"+track);
			fillPfromGlobalMemory.value(track).start;
			"done".postln;
			});
};
		); //end if less than 4



});
};


guiTask.value(0, 0, 0).start(AppClock); //track 0
guiTask.value(1, 230, 0).start(AppClock); //track 1
guiTask.value(2, 460, 0).start(AppClock); //track 2
guiTask.value(3, 690, 0).start(AppClock); //track 3
guiTask.value(4, 930, 80).start(AppClock); //track 4
guiTask.value(5, 930, 150).start(AppClock); //track 5
guiTask.value(6, 930, 220).start(AppClock); //track 6
guiTask.value(7, 930, 290).start(AppClock); //track 7
guiTask.value(8, 930, 360).start(AppClock); //track 8
guiTask.value(9, 930, 430).start(AppClock); //track 9