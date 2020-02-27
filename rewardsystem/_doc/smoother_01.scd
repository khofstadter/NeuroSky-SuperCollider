~eeg0 = [ 176.1, 37.7, 6.8, 4.4, 9.3, 7.4, 3, 4.2, 82.6, 48 ];
~eeg1 = [ 280.2, 46.9, 16.4, 9.1, 8.1, 9.8, 3.4, 4.2, 88.6, 44.2 ];
~smoothesteegPower = 0 ! 10;

~diff = ~eeg1[0] - ~eeg0[0];

case	{~diff == 0} {
	"stayed".postln;

			}

		{~diff > 0}	{
"increases".postln;
	~diff.do(~smoothesteegPower[0]=~eeg[0]+1);
		}

		{~diff < 0}	{
"decreases".postln;


};



~smoothesteegPower[0]=~eeg0[0]+1;

r = {m.do{ |i|
	x = i + 1;
	t.wait;
	x.postln
	}
};

r.value;