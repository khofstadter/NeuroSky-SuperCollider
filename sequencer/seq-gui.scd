var window=Window.new("focus-sequencer", Rect(1440-950,900-680,1000,700)).front;//(1440 x 900);
var composite=CompositeView(window, Rect(0,0,1010,800));

// control Specs for GUI
var pitchGUISpec=#[0,120,\lin,1,0].asSpec;
var ampGUISpec=#[0,1,\lin,0.01].asSpec;
var susGUISpec=#[0,10,\lin,0.01].asSpec;
var edurGUISpec=#[0.01,2,\lin,0.01].asSpec;
var tempoGUISpec=#[0,10,\lin,0.01].asSpec;

// var guiTask;
var guiHeader;
var guiTracks1;
var guiTracks2;

window.front;


// ## HEADER
guiHeader={|pos0, pos1|
	var tcText;
	var tcLoopButton;
	var tempoSpeed;
	var tempoMultiSlider;
	var compressorButton;
	var scaleChoice;

	tcText=StaticText(composite, Rect(pos0+60,pos1+5,100,20))
	.string_("tempoClock");

	tcLoopButton=Button(composite, Rect(150,5,30,20))
	.states_([
		["off", Color.white, Color.black],
		["on", Color.white, Color.red],])
	.action_({ arg butt;
		case {butt.value == 0} {"stop".postln; t.stop;}

		{butt.value == 1} {"play".postln;
			"start Tempo (t)" .postln;
			~makeTempoClock.value(5,~beat);
		};
	});

	tempoSpeed=Slider(composite, Rect(50,30,10,70))
	.value_(0.5)
	.action_({ |v|
		if ( v.value < 0.01, {v.value=0.01}, {});
		~tempo[0]=v.value.round(0.01);
	});

	tempoMultiSlider=GUI.multiSliderView.new(composite, Rect(60,30,230,70));
	tempoMultiSlider.value_(0.5 ! ~beat)
	.thumbSize_(tempoMultiSlider.bounds.width / ~beat-2)
	.colors_(Color.black,Color.yellow(0.9))
	.action_({ |view|
		view.value.do({ |x, i|
			if ( x < 0.01, {x=0.01}, {});
			~tempo[1][i]=tempoGUISpec.map(x.round(0.01))});
	});

	scaleChoice=EZPopUpMenu.new(composite,
		Rect(300, 30, 200, 20),
		"scale",

		[\biYu ->		{~scaleNb=0},
			\blues ->		{~scaleNb=1},
			\bluesDiminished ->	{~scaleNb=2},
			\dorian ->		{~scaleNb=3},
			\fullMinor ->	{~scaleNb=4},
			\harmonicMajor ->		{~scaleNb=5},
			\hawaiian ->		{~scaleNb=6},
			\ionianSharp5 ->		{~scaleNb=7},
			\jazzMinor ->		{~scaleNb=8},
			\lydian ->		{~scaleNb=9},
			\major ->		{~scaleNb=10},
			\mixolydian ->		{~scaleNb=11},
			\oriental ->		{~scaleNb=12},
			\superLocrian ->		{~scaleNb=13},
			\verdiEnigmaticAscending ->		{~scaleNb=14},
			\zirafkend ->		{~scaleNb=15},
			\majorPentatonic ->		{~scaleNb=16},
			\minorPentatonic ->		{~scaleNb=17},
			\noidea ->		{~scaleNb=18},
			\major2oct ->		{~scaleNb=19},
			\major1oct ->		{~scaleNb=20},
			\biYu ->		{~scaleNb=21},

		],
		initVal: 5,
		initAction: true,
		labelWidth: 45,
		labelHeight: 20,
		layout: \horz,
		gap: 2@2
	);

	compressorButton=Button(composite, Rect(360,60,80,20))
	.states_([
		["compressor", Color.white, Color.black],
		["compressor", Color.black, Color.red
	],])
	.action_({ arg butt;
		case
		{butt.value == 0} {~comp.free;}
		{butt.value == 1} {~comp=Synth(\compressor, addAction: \addToTail);}
	});

};

// ----------
// 0-3 TRACKS
// ----------

guiTracks1={|track, pos0, pos1|
	var trackNb;
	var tcLoopButton;
	var synthChoice;
	var randomWriteButton;
	var randomWriteButton2;
	var randomFill=0;
	var randomSlider;
	var volumeControl;
	var outList;
	var synthNb;
	var sampleDrag;
	var multiSlider=Array.fill(4, {0 ! ~beat});
	var schedElasticOnceButton;
	var schedElasticLoopButton;
	var schedElasticBeatNbBox;
	var saveFileBox, loadFileBox;
	var saveButtonGlobal, loadButtonGlobal;
	var saveButton=Array.fill(4, {0});
	var loadButton=Array.fill(4, {0});
	var rotateL;
	var rotateR;
	var pitchUpButton;
	var pitchDownButton;
	var monoToneFreqNbBx;

	// for Patterns from String
	// this string replacer part is from a R.Hoadley
	var pPattern;
	var pPatArray;
	var pPatStrF={|str|
		str=str.replace("   ", " ");
		str=str.replace("  ", " ");
		str=str.replace(" ", ", ");
		str=format("[%]", str).interpret;
	};

	var pPatArray2=0 ! ~beat;
	var pPatStrF2={|str|
		str=str.replace(" ", "");
		str=str.replace("[", "");
		str=str.replace("]", "");
		str=str.replace(",", " ");
		str.postln;
	};

	var mSActionFill={
		//it is not a valueAction as ~write already fills p [array for patterns]
		Task({
			//fill pPattern QTextView
			pPatArray2=Array.fill(~beat, {|i|
				if( p[track][i][0] != nil,
					{ (p[track][i][0])},
					{ 0 }
				);
			});

			//("pPatArray2:" + pPatArray2;).postln;
			pPatArray2=pPatStrF2.value(pPatArray2.asString);
			//("this : " + pPatArray2).postln;
			pPattern.setString (pPatArray2.asString, 0, 32);

			multiSlider[0].value=Array.fill(~beat, {|i|
				if( p[track][i][0] != nil,
					{ (p[track][i][0]).linlin(0, 120, 0.0, 1.0)},
					{ 0 }
				);
			});

			multiSlider[1].value=Array.fill(~beat, {|i|
				if( p[track][i][1] != nil,
					{ p[track][i][1].linlin(0.0, 1.0, 0.0, 1) },
					{ 0 }
				);
			});

			multiSlider[2].value=Array.fill(~beat, {|i|
				if( p[track][i][2] != nil,
					{ (p[track][i][2]).linlin(0.0, 10, 0.0, 1.0) },
					{ 0 }
				);
			});

			multiSlider[3].value=Array.fill(~beat, {|i|
				if( p[track][i][3] != nil,
					{ (p[track][i][3]).linlin(0.0, 2, 0.0, 1.0) },
					{ 0 }
				);
			});
		}).play(AppClock);

	};

	/*	var fillPfromGlobalMemory={ |track|
	//it is not a valueAction as ~write already fills p [array for patterns]
	Task({
	~beat.do{|i|
	p[track][i][0]=if(saveLoadGlobal[0][i] == 0,

	{nil},
	{(saveLoadGlobal[0][i]).linlin(0.0, 1.0, 0, 120).round(0.1) });


	p[track][i][1]=if(saveLoadGlobal[1][i] == 0,

	{nil},
	{(saveLoadGlobal[1][i]).linlin(0.0, 1.0, 0.0, 1.0).round(0.1) });

	p[track][i][2]=(saveLoadGlobal[2][i]).linlin(0.0, 1.0, 0.0, 10).round(0.01);
	p[track][i][3]=(saveLoadGlobal[3][i]).linlin(0.0, 1.0, 0.01, 2).round(0.01);
	};
	});
	};*/

	trackNb=StaticText(composite, Rect(pos0+5,pos1+2,50,20))
	.string_(track);

	// ELASTIC LOOP'S CONTROL
	// schedule elastic Once
	schedElasticOnceButton=Button(composite, Rect(pos0+20,pos1+5,13,13))
	.states_([
		["e", Color.white, Color.black]])
	.action_({ arg butt;
		// ("play once"+track).postln;
		~schedElasticOnce.value(track).play;
	});

	// eLoop
	// play and pause of elastic loop
	schedElasticLoopButton=Button(composite, Rect(pos0+35,pos1+2,45,20))
	.states_([
		["eLoop", Color.white, Color.black(0.7)],["eLoop", Color.black, Color.red]
	])
	.action_({ arg butt;
		case 	{butt.value == 0} {("stop ~schedElasticLoop on track "+track).postln;
			~schedElasticLoopPlay[track].stop;
		}
		{butt.value == 1} {("play ~schedElasticLoop on track "+track).postln;
			~schedElasticLoopPlay[track]=~schedElasticLoop.value(track).play;
		};
	});

	// change ~eBeat for ~schedElasticOnce (on which beat (tempoClock) shall the pattern be played
	schedElasticBeatNbBox=NumberBox(composite, Rect(pos0+85,pos1+2,23,20))
	.value_(0)
	.clipLo_(0)
	.clipHi_(~beat-1)
	.action_({ arg numb;
		~eBeat[track]=schedElasticBeatNbBox.value;
		~eBeat[track].postln;
	});

	// tc-eLoop
	// play and pause of elasticOnce that is scheduled with TempoClock (in ~playTask)
	schedElasticLoopButton=Button(composite, Rect(pos0+110,pos1+2,63,20))
	.states_([
		["tc-eLoop", Color.white, Color.black(0.7)],["tc-eLoop", Color.white, Color.red]
	])
	.action_({ arg butt;
		case 	{butt.value == 0} {("stop ~schedElasticLoop2 on track "+track).postln;
			~onOffElastic[track]=0;
		}
		{butt.value == 1} {("play ~schedElasticLoop2 on track "+track).postln;
			~onOffElastic[track]=1;
		};
	});

	//engage Loop with TempoClock in ~playTask (file: streams)
	tcLoopButton=Button(composite, Rect(pos0+185,pos1+2,50,20))
	.states_([
		["tcLoop", Color.white, Color.black],
		["tcLoop", Color.white, Color.red]])
	.action_({ arg butt;
		case 	{butt.value == 0} {("stop "+track);
			~onOff[track]=0;
		}
		{butt.value == 1} {("play "+track);
			~onOff[track]=1;
		};
	});


	synthChoice=EZPopUpMenu.new(composite, Rect(pos0+10, pos1+25, 155, 20),
		nil,
		[
			\sine ->		{~synth[track]=\sine},
			\saw ->		{~synth[track]=\saw},
			\windpad ->	{~synth[track]=\windpad},
			\saw2 ->		{~synth[track]=\saw2},
			\bells ->		{~synth[track]=\bells},
			\FM0 ->	{~synth[track]=\FM0},
			\FM1 ->		{~synth[track]=\FM1},
			\FM2 ->		{~synth[track]=\FM2},
			\FM3 ->		{~synth[track]=\FM3},
			\FM4 ->		{~synth[track]=\FM4},
			\bells2 ->		{~synth[track]=\bells2},
			\nice1 ->		{~synth[track]=\nice1},
			\nice2 ->		{~synth[track]=\nice2},
			\newFM1 ->		{~synth[track]=\newFM1},
			\newFM2 ->		{~synth[track]=\newFM2},
			\newFM3 ->		{~synth[track]=\newFM3},
			\newFM4 ->		{~synth[track]=\newFM4},
			\laserbeam ->		{~synth[track]=\laserbeam},
			\windX ->	{~synth[track]=\windX},
			\sample ->	{~synth[track]=\sample},
		],

		initVal: 6,
		//initAction: true,
		labelWidth: 30,
		labelHeight: 20,
		layout: \horz,
		gap: 2@2
	);

	volumeControl=Slider(composite, Rect(pos0,pos1+25,9,70))
	.action_({ |v|
		m[track]=v.value;
	});

	outList=EZPopUpMenu.new(composite, Rect(pos0+170, pos1+25, 65, 20),
		nil,
		[
			\stereo ->		{~midiOrVal[track]=0},
			\midi ->		{~midiOrVal[track]=1},
		],
		initVal: 0,
		initAction: true,
		labelWidth: 30,
		labelHeight: 20,
		layout: \horz,
		gap: 2@2
	);

	sampleDrag=DragSink(composite, Rect(pos0+10, pos1+48, 155, 15)).align_(\centre)
	.string_( "Sample drop" )
	//.canReceiveDragHandler_({ z.value.notEmpty })
	.action_({
		z=View.currentDrag.postln;
		~trackSample[track]=Buffer.readChannel(s, z);
	});

	saveButton[0]=Button(composite, Rect(pos0+10,pos1+67,10,10))
	.states_([["-", Color.black, Color.gray],])
	.action_({
		~memL[0][track]=p[track].deepCopy;
		p[track]=~memL[0][track].deepCopy;
	});

	loadButton[0]=Button(composite, Rect(pos0+10,pos1+80,10,13))
	.states_([["|", Color.white]])
	.action_({
		p[track]=~memL[0][track].deepCopy;
		if (track < 4, {mSActionFill.value});
	});

	saveButton[1]=Button(composite, Rect(pos0+20,pos1+67,10,10))
	.states_([["-", Color.black, Color.grey],])
	.action_({
		~memL[1][track]=p[track].deepCopy;
	});

	loadButton[1]=Button(composite, Rect(pos0+20,pos1+80,10,13))
	.states_([["|", Color.white]])
	.action_({
		p[track]=~memL[1][track].deepCopy;
		if (track < 4, {mSActionFill.value});
	});

	saveButton[2]=Button(composite, Rect(pos0+30,pos1+67,10,10))
	.states_([["-", Color.black, Color.grey],])
	.action_({
		~memL[2][track]=p[track].deepCopy;
	});

	loadButton[2]=Button(composite, Rect(pos0+30,pos1+80,10,13))
	.states_([["|", Color.white]])
	.action_({
		p[track]=~memL[2][track].deepCopy;
		if (track < 4, {mSActionFill.value});
	});

	saveButtonGlobal=Button(composite, Rect(pos0+40,pos1+67,10,10))
	.states_([["-", Color.black, Color.green],])
	.action_({ arg butt;
		~memory=p[track].deepCopy;
	});

	loadButtonGlobal=Button(composite, Rect(pos0+40,pos1+80,10,13))
	.states_([["|", Color.green, Color.black]])
	.action_({ arg butt;
		p[track]=~memory.deepCopy;
		if (track < 4, {mSActionFill.value});
	});

	saveFileBox=TextField(composite, Rect(pos0+55, pos1+65, 110, 15))
	.string_("save")
	.action_({arg field; field.value.postln;
		~saveFile.value(track, field.value); //value: track, filename
		AppClock.sched(2.0, {saveFileBox.value="save";});
	});

	loadFileBox=TextField(composite, Rect(pos0+55, pos1+80, 110, 15))
	.string_("load")
	.action_({arg field; field.value.postln;
		~loadFile.value(track, field.value); //value: track, filename
		if(track < 4, {mSActionFill.value});
	});

	// randomize patterns in the chosen scale
	randomWriteButton=Button(composite, Rect(pos0+195, pos1+48, 15, 15))
	.states_([
		["R", Color.white, Color.black]])
	.action_({ arg butt;
		~write2.value(track, randomFill, ~scaleNb);
		if(track < 4, {mSActionFill.value});
	});

	// randomize patterns in the chosen scale (without wait/Tempo)
	randomWriteButton2=Button(composite, Rect(pos0+210, pos1+48, 15, 15))
	.states_([
		["R", Color.yellow(0.9), Color.black]])
	.action_({ arg butt;
		~write.value(track, randomFill, ~scaleNb);
		if(track < 4, {mSActionFill.value});
	});

	monoToneFreqNbBx=NumberBox(composite, Rect(pos0+190,pos1+80,15,15))
	.value_(0)
	.clipLo_(1)
	.clipHi_(107)
	.action_({
		~writeMonotone.value(track,monoToneFreqNbBx.value);
		if(track < 4, {mSActionFill.value});
	});

	// slider for the amount of notes to be randomized for ~write.value(track, 10, ~scaleNb);
	randomSlider=Slider(composite, Rect(pos0+185,pos1+65,50,10))
	.action_({
		randomFill=(randomSlider.value*20).round;
	});

	rotateL=Button(composite, Rect(pos0+210,pos1+80,10,13))
	.states_([["<", Color.white]])
	.action_({
		p[track]=p[track].rotate(-1);
		if(track < 4, {mSActionFill.value});
	});

	rotateR=Button(composite, Rect(pos0+225,pos1+80,10,13))
	.states_([["<", Color.white]])
	.action_({
		p[track]=p[track].rotate(1);
		if(track < 4, {mSActionFill.value});
	});


	// TRACK 0-3

	if(track < 4, {

		//multisliders
		multiSlider[0]=MultiSliderView(composite, Rect(pos0+10, pos1+100, 230, 60));
		multiSlider[0].value_(0 ! ~beat)
		.thumbSize_(multiSlider[0].bounds.width / ~beat-2)
		.colors_(Color.black, Color.blue(0.7,0.2))
		.isFilled_(true)
		.action_({ |view|
			view.value.do({ |x, i| p[track][i][0]=pitchGUISpec.map(x.round(0.01));
				// change p array as if nil > synth is not made
				if (x==0,
					{ p[track][i][0]=nil},
					//false
					{p[track][i][0]=x.linlin(0.0, 1.0, 0, 120, nil);}
				);
			});
		});

		pitchUpButton=Button(composite, Rect(pos0,pos1+120,10,13))
		.states_([["^", Color.black]])
		.action_({
			~pitchUp.value(track);
			mSActionFill.value;
		});

		pitchDownButton=Button(composite, Rect(pos0,pos1+135,10,13))
		.states_([["v", Color.black]])
		.action_({
			~pitchDown.value(track);
			mSActionFill.value;
		});

		multiSlider[1]=MultiSliderView(composite, Rect(pos0+10, pos1+185, 230, 50));
		multiSlider[1].value_(0 ! ~beat)
		.thumbSize_(multiSlider[1].bounds.width / ~beat-2)
		.colors_(Color.black, Color.red(0.7,0.2))
		.isFilled_(true)
		.action_({ |view|
			view.value.do({ |x, i|
				if (x==0,
					//true
					{ p[track][i][1]=nil},
					//false
					{p[track][i][1]=ampGUISpec.map(x.round(0.01))};
				); //end if
			});
		});

		//strings for pitch
		pPattern=QTextView.new(composite, Rect(pos0+10, pos1+160, 230, 20))
		.font_(Font("Helvetica", 7))
		.keyDownAction={|view,char,modifiers,unicode,keycode,array|

			if ((unicode==32), {
				pPatArray=pPatStrF.value(pPattern.string);
				//pPatArray.postln;
				~beat.do({|i| p[track][i][0]=pPatArray[i]});

				multiSlider[0].value=Array.fill(~beat, {|i|
					if( p[track][i][0] != nil,
						{ (p[track][i][0]).linlin(0, 120, 0.0, 1.0)},
						{ 0 }
					);
				});
			});
		};

		multiSlider[2]=MultiSliderView(composite, Rect(pos0+10, pos1+255, 230, 50));
		multiSlider[2].value_(0 ! ~beat)
		.thumbSize_(multiSlider[2].bounds.width / ~beat-2)
		.colors_(Color.black, Color.green(0.7,0.2))
		.isFilled_(true)
		.action_({ |view|
			view.value.do({ |x, i| p[track][i][2]=susGUISpec.map(x.round(0.01)) });
		});

		multiSlider[3]=MultiSliderView(composite, Rect(pos0+10, pos1+315, 230, 50));
		multiSlider[3].value_(0 ! ~beat)
		.thumbSize_(multiSlider[3].bounds.width / ~beat-2)
		.colors_(Color.black, Color.yellow(0.9))
		.action_({ |view|
			view.value.do({ |x, i|
				//	if ( x < 0.01, {x=0.01}, {}); //do wait loop crash if all 0
				p[track][i][3]=edurGUISpec.map(x.round(0.01)) });
		});
	},
	);
};

guiTracks2={ |track, pos0, pos1|
	var trackNb;
	var constantSynthBut;
	var constantSynthChoice;
	var constantVolumeControl;
	var constantOutList;
	var constantSynthFreq;
	var constantSynthFreqNbBox;
	var constantSynthSlider=0 ! 2;
	var saveButton=Array.fill(4, {0});
	var loadButton=Array.fill(4, {0});

	trackNb=StaticText(composite, Rect(pos0+5,pos1,50,20))
	.string_(track);

	constantSynthBut=Button(composite, Rect(pos0+18,pos1+3,15,15))
	.states_([
		["c", Color.white, Color.black],
		["c", Color.black, Color.red],])

	.action_({ arg butt;

		case
		{butt.value == 0} {
			"stop".postln;
			~constantSynth[track].free; ~constantSynth[track]=nil;
		}

		{butt.value == 1} {
			"play".postln;
			~constantSynth[track] =
			Synth( ~synth2[track], [ \freq, constantSynthFreq,
				\amp, 0.5,
				\master,~m2[track],
				\out, ~out,
				\change0, constantSynthSlider[0].value,
				\change1, constantSynthSlider[1].value,
			]);
		}
	});

	constantSynthChoice=EZPopUpMenu.new(composite, Rect(pos0+35, pos1, 130, 20),
		nil,
		[
			\constantSaw1 ->		{~synth2[track]=\constantSaw1},
			\constantSaw2 ->		{~synth2[track]=\constantSaw2},
		],

		initVal: 0,
		initAction: true,
		labelWidth: 30,
		labelHeight: 20,
		layout: \horz,
		gap: 2@2
	);

	constantVolumeControl=Slider(composite, Rect(pos0,pos1+25,9,40))
	.action_({ |v|
		~m2[track]=v.value;

		if (~constantSynth[track] != nil,
			{~constantSynth[track].set(\master, v.value);}
		)});

	/*   // track number is 8-11 and it probably should be 0-4
	constantOutList=EZPopUpMenu.new(composite, Rect(pos0+170, pos1, 65, 20),
	nil,
	[
	\stereo ->		{},
	\midi ->		{},
	],
	initVal: 0,
	initAction: true,
	labelWidth: 30,
	labelHeight: 20,
	layout: \horz,
	gap: 2@2
	);*/

	// change ~eBeat for ~schedElasticOnce (on which beat (tempoClock) shall the pattern be played
	constantSynthFreqNbBox=NumberBox(composite, Rect(pos0+18,pos1+24,30,15))
	.value_(0)
	.clipLo_(1)
	.clipHi_(107)
	.action_({ arg numb;
		constantSynthFreq=constantSynthFreqNbBox.value;
		constantSynthFreq.postln;
		~constantSynth[track].set(\freq, constantSynthFreqNbBox.value;);
	});

	constantSynthSlider[0]=Slider(composite, Rect(pos0+50,pos1+20,115,10))
	.action_({
		~constantSynth[track].set(\change0, constantSynthSlider[0].value;);
	});

	constantSynthSlider[1]=Slider(composite, Rect(pos0+50, pos1+30, 115, 10))
	.action_({
		~constantSynth[track].set(\change1, constantSynthSlider[1].value);
	});
};

guiHeader.value(0,0);
guiTracks1.value(0,0,110);
guiTracks1.value(1,250,110);
guiTracks1.value(2,500,110);
guiTracks1.value(3,750,110);
guiTracks1.value(4,0,490);
guiTracks1.value(5,250,490);
guiTracks1.value(6,500,490);
guiTracks1.value(7,750,490);
/*guiTracks1.value(8,0,580);
guiTracks1.value(9,250,580);
guiTracks1.value(10,500,580);
guiTracks1.value(11,750,580);*/

guiTracks2.value(0,0,610);
guiTracks2.value(1,250,610);
guiTracks2.value(2,500,610);
guiTracks2.value(3,750,610);
