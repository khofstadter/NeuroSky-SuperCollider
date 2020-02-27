// tempoClock Function;
~makeTempoClock = { |tempo, beats|
	t = TempoClock(tempo, beats); // create a TempoClock with no queue
	t.play({arg x;
		[c=(x.round)%beats]; // make counter;
		~playTask.value.play; // 'play' ~playTask on every beat;
		1
	});

};