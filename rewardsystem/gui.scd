// # neurofeedback gui
var neuroskyButton;
var selectIsletButton;
var autoMoveButton;
w= GUI.window.new("focus", Rect(1000, 800, 210, 480)).front;
~toMoveBox= 0 ! 6;
~rewardPointsBox= 0 ! 6;
~tthKnob= 0 ! 2;

//smoothing values
~smoothValues= Task({
	//to change sliders
	inf.do({
		~slider0.valueAction_(~sigQ);
		~slider1.valueAction_(~attSmooth/100);
		~slider2.valueAction_(~medSmooth/100);
		0.01.wait;
	});
});

// ## hardware control
~slider0= Slider(w, Rect(20, 33, 150, 10));
StaticText(w, Rect(20, 45, 170, 20)).string_("EEG signal OK < > BAD");

StaticText(w, Rect(53, 10, 200, 20)).string_("NeuroSky Serial");
neuroskyButton= Button(w, Rect(20, 10, 30, 20))
.states_([
	["On", Color.white, Color.black],
	["Off", Color.black, Color.red],])
.action_({ arg butt;
	case 	{butt.value== 1} {
		"Neurosky Connection On".postln;
		~neuroSkyConnect.start;
		~smoothValues.start(AppClock);
	}
	{butt.value== 0} {
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

//select islet
StaticText(w, Rect(20, 70, 200, 20)).string_("Soundscape");
selectIsletButton = PopUpMenu(w, Rect(100, 70, 60, 20));
selectIsletButton.items = ["islet0-abstract", "islet1-ambient", "islet2-EDM"];
selectIsletButton.background_(Color.green(0.7));  // only changes the look of displayed
selectIsletButton.action = { arg menu;
	[menu.value, menu.item].postln;
	~selectIslet= menu.value;
	i[~presentIslet][1].reset.play
};

// ## meditation
~tthKnob[1]= Knob(w, Rect(35, 107, 30, 30));
StaticText(w, Rect(20, 290, 150, 20)).string_("Meditation");
~slider2= Slider(w, Rect(20, 140, 55, 150))
.value_(0)
.action= {
	var x;
	x= 100*~slider2.value;
	~meditation= x.asInteger;
};
~slider4= Slider(w, Rect(75, 140, 10, 150))
.focusColor_(Color.red(alpha:0.2))
.background_(Color.blue)
.action_({~mThVal=~slider4.value*100});
~toMoveBox[3]= NumberBox(w, Rect(22, 350,30,20))
.value_(0)
.background_(Color.grey)
.normalColor_(Color.white)
.align = \center;
~toMoveBox[4]= NumberBox(w, Rect(22, 380,30,20))
.value_(0)
.background_(Color.grey)
.normalColor_(Color.white)
.align = \center;
~toMoveBox[5]= NumberBox(w, Rect(22, 410,30,20))
.value_(0)
.background_(Color.grey)
.normalColor_(Color.white)
.align = \center;
~rewardPointsBox[3]= NumberBox(w, Rect(52, 350,30,20))
.value_(0)
.align = \center;
~rewardPointsBox[4]= NumberBox(w, Rect(52, 380,30,20))
.value_(0)
.align = \center;
~rewardPointsBox[5]= NumberBox(w, Rect(52, 410,30,20))
.value_(0)
.align = \center;

//### attention
~tthKnob[0]= Knob(w, Rect(140,107,30,30));
StaticText(w, Rect(130, 290, 150, 20)).string_("Attention");
~slider1= Slider(w, Rect(130, 140, 55, 150))
.value_(0)
.action= {
	var x;
	x= 100*~slider1.value;
	~attention= x.asInteger;
};
~slider3= Slider(w, Rect(120, 140, 10, 150))
.focusColor_(Color.blue(alpha:0.2))
.background_(Color.red)
.action_({~aThVal=~slider3.value*100});

~toMoveBox[0]= NumberBox(w, Rect(122, 350,30,20))
.value_(0)
.background_(Color.grey)
.normalColor_(Color.white)
.align = \center;
~toMoveBox[1]= NumberBox(w, Rect(122, 380,30,20))
.value_(0)
.background_(Color.grey)
.normalColor_(Color.white)
.align = \center;
~toMoveBox[2]= NumberBox(w, Rect(122, 410,30,20))
.value_(0)
.background_(Color.grey)
.normalColor_(Color.white)
.align = \center;
~rewardPointsBox[0]= NumberBox(w, Rect(152, 350,30,20))
.value_(0)
.align = \center;
~rewardPointsBox[1]= NumberBox(w, Rect(152, 380,30,20))
.value_(0)
.align = \center;
~rewardPointsBox[2]= NumberBox(w, Rect(152, 410,30,20))
.value_(0)
.align = \center;

//## middle (shared text)
StaticText(w, Rect(87, 112, 30, 20)).string_("TTH");
StaticText(w, Rect(93, 150, 20, 20)).string_("TH");
StaticText(w, Rect(20, 327, 60, 20)).string_("Challenge");
StaticText(w, Rect(93, 350, 20, 20)).string_("TH");
StaticText(w, Rect(88, 380, 30, 20)).string_("TTH");
StaticText(w, Rect(89, 410, 30, 20)).string_("max");