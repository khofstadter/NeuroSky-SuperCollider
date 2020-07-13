~memory = Array.fill2D(~beat, 4, 0); //global memory;

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

//~loadFile.value(0, 44);

// (
// // copy from one instrument to another;
// ~copy = { |track |
// 	~memory = p[track].deepCopy;
// };
//
// ~paste = { |track |
// 	p[track] = ~memory.deepCopy;
// };
// )