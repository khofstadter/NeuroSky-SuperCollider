i[0][0] = Routine {

	~presentIslet = 0;
	"Enter sea".postln;
	//"keep sliders on 0".postln; //TODO
	~makeTempoClock.value(1,16);
	"play some music (demo)".postln; //TODO

};


i[0][1] = Routine {
	t.sched(0, {"play finish melody".postln}); //TODO
	t.sched(5, {
		t.stop;
		i[1][0].reset.play; //enter a new islet;
	});

};

