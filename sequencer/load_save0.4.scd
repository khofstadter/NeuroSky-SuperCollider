

(


~saveFile = { |track, filename|
	//var space = [(0 ! 16)]++[[0]];  //make space with beatSizer
	var space = (0 ! 4) ! ~beat;


	("save" + track + "track").postln;

	~beat.do{ |i|



	space[i] = p[track][i]};

	space.writeArchive((~pathname ++ filename.asString).standardizePath);


};
);

//~saveFile.value(0, 122);

(


~loadFile = { |track, filename|
	var space = (0 ! 4) ! ~beat;
	space = Object.readArchive((~pathname ++ filename.asString).standardizePath);



	~beat.do{ |i|



	p[track][i] = space[i];};



};
);

//~loadFile.value(0, 12345);