var neuroskyButton;
var practiceModeButton;
var startIslandButton;

w = GUI.window.new("pSig", Rect(1000, 800, 455, 250)).front;

~toMoveBox = 0 ! 6;
~rewardPointsBox = 0 ! 6;
~tthKnob = 0 ! 2;

// SMOOTH VALUE TASKS
~smoothValues = Task({
	//to change sliders
	inf.do({
		~slider0.valueAction_(~sigQ);
		~slider1.valueAction_(~attSmooth/100);
		~slider2.valueAction_(~medSmooth/100);
		~eegPowermultiS.valueAction_(~smootheegPower/50);
		0.01.wait;
	});
});

//sliders
(

StaticText(w, Rect(55, 10, 200, 20)).string_("NeuroSky Serial");
neuroskyButton = Button(w, Rect(20, 10, 30, 20))
.states_([
	["On", Color.white, Color.black],
	["Off", Color.black, Color.red],])
.action_({ arg butt;

	case 	{butt.value == 1} {
		"Neurosky Connection On".postln;
		~neuroSkyConnect.start;
		~smoothValues.start(AppClock);


	}
	{butt.value == 0} {
		"Neurosky Connection Off".postln;

		~neuroSkyConnect.start;
		~smoothValues.stop(AppClock);

		/*~parser.stop;
		SerialPort.closeAll;
		~smoothAttention.stop;
		~smoothMeditation.stop;*/
		//~sendOsc.stop(AppClock);
	};
});


practiceModeButton = Button(w, Rect(290,10,130,20))
.states_([
	["start practice", Color.white, Color.black],
	["enter first islet", Color.white, Color.red],
	["stop", Color.red, Color.white]])
.action_({ arg butt;
	butt.value.postln;
	case 	{butt.value == 0} {
		t.stop;
		~onOff = 0 ! 16; //all off


	}



	{butt.value == 1} {
		i[0][1].reset.play;



	}

	{butt.value == 2} {
		~manualMove = 1;
		i[1][1].reset.play;



	}


});

StaticText(w, Rect(455, 225, 600, 20)).string_("    delta        theta      Lalpha      Halpha      Lbeta       Hbeta     LGamma     MGamma");
~eegPowermultiS = MultiSliderView(w, Rect(455,5,500,220));
	~eegPowermultiS.value_(0 ! 8)
	.thumbSize_(~eegPowermultiS.bounds.width / 8)
	.colors_(Color.black, Color.blue(0.7,0.2))
	.isFilled_(true);


// on:		start IslandTask
// off:	stop IslanTask and reset everything (or pause ?)


//		startIslandButton = Button(w, Rect(320,20,50,20))
//					.states_([
//						["start", Color.white, Color.black],
//						["stop", Color.black, Color.red],])



//					.action_({ arg butt;



//
//						case 	{butt.value == 0} {
//						// a Task to check whether the synth is still alive are or not
//								Task {if (~constantSynth[1].isPlaying !== true,


//									{"~constantSynth is playing > free".postln;
//										~constantSynth[1].free;
//										~constantSynth[1] = nil; }
//								)
//								}.start;
//															}
//								{butt.value == 1} {
//								~constantSynth[1] = Synth(\longpad2,
//								[ \change0, ~meditation, \master, 0.5, \out, 0]);
//								};
//								});


StaticText(w, Rect(20, 210, 170, 20)).string_("EEG signal :OK < > BAD");
~slider0 = Slider(w, Rect(20, 230, 150, 10));

StaticText(w, Rect(20, 80, 150, 20)).string_("Attention level");
~slider1 = Slider(w, Rect(20, 100, 150, 20))
.value_(0)
.action = {
	var x;
	x = 100*~slider1.value;
	~attention = x.asInteger;
	//~constantSynth[0].set(\change0,~attention/100);
	//x.postln;
};

StaticText(w, Rect(20, 150, 150, 20)).string_("Meditation level");
~slider2 = Slider(w, Rect(20, 170, 150, 20))
.value_(0)
.action = {
	var x;
	x = 100*~slider2.value;
	~meditation = x.asInteger;
	//~constantSynth[0].set(\change2,~meditation/100);
	//x.postln;
};

//Attention threshold
StaticText(w, Rect(0, 115, 20, 20)).string_("TH");
~slider3 = Slider(w, Rect(20, 120, 150, 10))
 .focusColor_(Color.red(alpha:0.2))
.background_(Color.blue)
.value_(0);

//Meditation threshold
StaticText(w, Rect(0, 185, 20, 20)).string_("TH");
~slider4 = Slider(w, Rect(20, 190, 150, 10))
 .focusColor_(Color.blue(alpha:0.2))
.background_(Color.red)
.value_(0);

StaticText(w, Rect(220,85,180,20)).string_("to Move:");
StaticText(w, Rect(190,105,180,20)).string_("rewardPoints:");
StaticText(w, Rect(220,155,180,20)).string_("to Move:");
StaticText(w, Rect(190,175,180,20)).string_("rewardPoints:");

StaticText(w, Rect(335,45,180,20)).string_("above");
StaticText(w, Rect(305,65,180,20)).string_("TH");
StaticText(w, Rect(337,65,180,20)).string_("TTH");
StaticText(w, Rect(370,65,180,20)).string_("max");

~toMoveBox[0] = NumberBox(w, Rect(300, 85,30,30))
		.value_(0);
~toMoveBox[1] = NumberBox(w, Rect(335, 85,30,30))
		.value_(0);
~toMoveBox[2] = NumberBox(w, Rect(370, 85,30,30))
		.value_(0);
~toMoveBox[3] = NumberBox(w, Rect(300, 155,30,30))
		.value_(0);
~toMoveBox[4] = NumberBox(w, Rect(335, 155,30,30))
		.value_(0);
~toMoveBox[5] = NumberBox(w, Rect(370, 155,30,30))
		.value_(0);

~rewardPointsBox[0] = NumberBox(w, Rect(300, 115,30,30))
		.value_(0);
~rewardPointsBox[1] = NumberBox(w, Rect(335, 115,30,30))
		.value_(0);
~rewardPointsBox[2] = NumberBox(w, Rect(370, 115,30,30))
		.value_(0);
~rewardPointsBox[3] = NumberBox(w, Rect(300, 185,30,30))
		.value_(0);
~rewardPointsBox[4] = NumberBox(w, Rect(335, 185,30,30))
		.value_(0);
~rewardPointsBox[5] = NumberBox(w, Rect(370, 185,30,30))
		.value_(0);


//Time Threshold Knob
StaticText(w, Rect(172, 75, 30, 20)).string_("TTH");
~tthKnob[0] = Knob(w, Rect(140,65,30,30));
StaticText(w, Rect(172, 145, 30, 20)).string_("TTH");
~tthKnob[1] = Knob(w, Rect(140, 135, 30, 30));

// StaticText(w, Rect(340, 220,100,20)).string_("Present level:");
// ~presentIslandBox = NumberBox(w, Rect(430, 220,20,20))
// .value_(0);


);
