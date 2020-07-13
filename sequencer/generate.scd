//to be used for pitch, amp, sustain, and duration
//as scales are used ~data[0] is not used later in Function ~write
~data = [(0..120),((0..10)/10),(0.01..5),((0..10)/10)];

~scales = 0 ! 22;
//biYu
~scales[0]=[24,27,31,34,36,39,43,46,48,51,55,58,60,63,67,70,72,75,79,82,84,87,91,94,96,99,103,106,108,111,115,118];
//blues
~scales[1]=[41,42,43,46,48,51,53,54,55,58,60,63,65,66,67,70,72,75,77,78,79,82,84,87,89,90,91,94,96,99,101,102];
// bluesDiminished
~scales[2]=[48,49,51,52,54,55,56,58,60,61,63,64,66,67,68,70,72,73,75,76,78,79,80,82,84,85,87,88,90,91,92,94];
//dorian
~scales[3]=[25,27,30,32,34,37,39,42,44,46,49,51,54,56,58,61,63,66,68,70,73,75,78,80,82,85,87,90,92,94,97,99];
//fullMinor
~scales[4]=[51,53,55,56,57,58,59,60,62,63,65,67,68,69,70,71,72,74,75,77,79,80,81,82,83,84,86,87,89,91,92,93];
//harmonicMajor
~scales[5]=[44,47,48,50,52,53,55,56,59,60,62,64,65,67,68,71,72,74,76,77,79,80,83,84,86,88,89,91,92,95,96,98];
//hawaiian
~scales[6]=[39,43,45,47,48,50,51,55,57,59,60,62,63,67,69,71,72,74,75,79,81,83,84,86,87,91,93,95,96,98,99,103];
//ionianSharp5
~scales[7]=[45,47,48,50,52,53,56,57,59,60,62,64,65,68,69,71,72,74,76,77,80,81,83,84,86,88,89,92,93,95,96,98];
//jazzMinor
~scales[8]=[45,47,48,50,51,53,55,57,59,60,62,63,65,67,69,71,72,74,75,77,79,81,83,84,86,87,89,91,93,95,96,98];
//lydian
~scales[9]=[45,47,48,50,52,54,55,57,59,60,62,64,66,67,69,71,72,74,76,78,79,81,83,84,86,88,90,91,93,95,96,98];
//major
~scales[10]=[43,45,48,50,51,52,54,55,57,60,62,63,64,66,67,69,72,74,75,76,78,79,81,84,86,87,88,90,91,93,96,98];
//mixolydian
~scales[11]=[45,46,48,50,52,53,55,57,58,60,62,64,65,67,69,70,72,74,76,77,79,81,82,84,86,88,89,91,93,94,96,98];
//oriental
~scales[12]=[45,46,48,49,52,53,54,57,58,60,61,64,65,66,69,70,72,73,76,77,78,81,82,84,85,88,89,90,93,94,96,97];
//superLocrian
~scales[13]=[44,46,48,49,51,52,54,56,58,60,61,63,64,66,68,70,72,73,75,76,78,80,82,84,85,87,88,90,92,94,96,97];
//verdiEnigmaticAscending[14]
~scales[14]=[46,47,48,49,52,54,56,58,59,60,61,64,66,68,70,71,72,73,76,78,80,82,83,84,85,88,90,92,94,95,96,97];
//zirafkend
~scales[15]=[48,50,51,53,55,56,57,59,60,62,63,65,67,68,69,71,72,74,75,77,79,80,81,83,84,86,87,89,91,92,93,95];
//major pentatonic
~scales[16]=[36,38,40,43,45,48,50,52,55,57,60,62,64,67,69,72,74,76,79,81,84,86, 88, 91, 93, 96];
//minor pentatonic
~scales[17]=[36,39,40,43,46,48,51,53,55,58,60,63,64,67,70,72,75,76,79,82,84,87, 88, 94, 93, 96];
//mixolydian
~scales[18]=[36,38,40,41,43,45,46,48, 50, 52, 53, 55, 57, 58,60, 62, 64, 65, 67, 69, 70,72, 74, 76, 77, 79, 81, 82,84, 86, 88, 89, 91, 93, 94,96 ];
//mixolydian
~scales[19]=[72,74,76,79,81,84,86,88,91,93,96];
~scales[20]=[72,74,76,79,81,84];
~scales[21]=[72,75,79,82,84,87,91,94,96];

// write staight into instrument track
~write = { |track, gap, scaleNb|
var made = (0 ! 4) ! ~beat;
	~beat.do{ |i|
		var pick;
		pick = ~scales[scaleNb][rrand(0, ~scales[scaleNb].size+gap)]; //
		made[i][0] = pick;
		pick = ~data[1][rrand(0, ~data[1].size+gap)]; //
		made[i][1] = pick;
		pick = ~data[2][rrand(0, ~data[2].size)]; //
		made[i][2] = pick;
		pick = ~data[3][rrand(0, ~data[3].size)]; //
		made[i][3] = pick;
		};
		//made.postln;
		p[track] = made;
};

// write staight into instrument track
~write2 = { |track, gap, scaleNb|
var made = (0 ! 4) ! ~beat;
	~beat.do{ |i|
		var pick;
		pick = ~scales[scaleNb][rrand(0, ~scales[scaleNb].size+gap)]; //
		made[i][0] = pick;
		pick = ~data[1][rrand(0, ~data[1].size)]; //
		made[i][1] = pick;
		pick = ~data[2][rrand(0, ~data[2].size)]; //
		made[i][2] = pick;
		/*pick = ~data[3][rrand(0, ~data[3].size)]; //
		made[i][3] = pick;*/
		};
		//made.postln;
		p[track] = made;
};

// write staight into instrument track
~write3 = { |track|
var made = (0 ! 4) ! ~beat;
	~beat.do{ |i|
		var pick;
		made[i][0] = 60;
		made[i][1] = 0.5;
		made[i][2] = 2;
		};
		//made.postln;
		p[track] = made;
};


// example of its use
//values: track; empty notes (randomness, the higher the nb the more gaps), scale nb
//~write.value(1, 10, 10);

~pitchDown = { |track|
	a = nil ! ~beat; //1 dimensional array for pitch
	b = nil ! ~beat; //1 dimensional array for pitch
	~beat.do{ |i|
		a[i] = p[track][i][0]; //collect pitch from p;
	};
	a.postln;

	~scales[~scaleNb].size.do{ |i|
		~beat.do{ |x|
			if (a[x] == ~scales[~scaleNb][i], {b[x]=~scales[~scaleNb][i-1]}); //-1;
		};
	};
	b.postln;

	~beat.do{ |i|
		p[track][i][0] = b[i];
	};
	p[track].postln;

};

~pitchUp = { |track|
	a = nil ! ~beat; //1 dimensional array for pitch
	b = nil ! ~beat; //1 dimensional array for pitch
	~beat.do{ |i|
		a[i] = p[track][i][0]; //collect pitch from p;
	};
	a.postln;

	~scales[~scaleNb].size.do{ |i|
		~beat.do{ |x|
			if (a[x] == ~scales[~scaleNb][i], {b[x]=~scales[~scaleNb][i+1]}); //-1;
		};
	};
	b.postln;

	~beat.do{ |i|
		p[track][i][0] = b[i];
	};

	p[track].postln;

};

// ~pitchUp.value(0);
// ~pitchDown.value(0);

~writeMonotone = { |track, freq=4|
var made = (0 ! 4) ! ~beat;
var help = [[60,0],[0.7,0],[3,0]];
	~beat.do{ |i|
		var pick;
			pick = help[0][i%freq];
		made[i][0] = pick;
			pick = help[1][i%freq];
		made[i][1] = pick;
				pick = help[2][i%freq];
		made[i][2] = pick;
		};
		//made.postln;
		p[track] = made;
};

//~writeMonotone.value(0,4);


