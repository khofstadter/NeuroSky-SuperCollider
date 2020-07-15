~tempo = [0.5,5!~beat];

//tempoClock Function;
~makeTempoClock = { |tempo, beats|
	t = TempoClock(tempo, beats);//create a TempoClock with no queue
	t.schedAbs(t.nextBar, {t.beatsPerBar_(~beat)});
	t.play({arg x;
		[c = (x.round)%beats];//make counter;
		~playTask.value.play;//'play' ~playTask on every beat;
		t.tempo_(~tempo[0]*(~tempo[1][c]));//change tempo
		1
	});

};