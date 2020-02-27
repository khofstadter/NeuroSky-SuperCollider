~is[0][0] = {

~presentIslet = 0;
"Enter sea".postln;
"keep sliders on 0".postln; //TODO
~makeTempoClock.value(1,16);
"play some music (demo)".postln; //TODO

};


~is[0][1] = {

"enable eSenses".postln; //TODO
t.sched(0, { "arriving to shore of next islet sound".postln }); //TODO
t.schedAbs(t.nextBar, {"play shore melody".postln}); //TODO
t.sched(5, {
	t.stop;
		~is[1][0].value; //enter a new islet;
});

};