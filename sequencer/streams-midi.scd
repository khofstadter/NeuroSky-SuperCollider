/*
TODO
- why is there a delay in PlayTask?
- when sending MIDI out, send also velocity (in taskFunction);
- why is variable called ~midiOrVal? It should be simpler;
- what is and: { }, and why is || better?
- why cannot I use = in an if clause, why only ||?
*/

//pattern for all tracks with pitch, amp, envelope and duration
~beat = 32; //4-256
~size = 12; //nb. of instruments/tracks
p = Array.fill3D(~size, ~beat, 4, 0);
~memL = [p.deepCopy,p.deepCopy,p.deepCopy,p.deepCopy];
~memory = Array.fill2D(~beat, 4, 0); //global memory;
~trackSample = (0 ! ~size);
~onOff = 0 ! ~size; //track is engadged or not
~onOffElastic = 0 ! ~size; //track for elastic pattern engadged or not
~eBeat = 0 ! ~size; //on which beat ~schedElasticOnce[track] shall be played
m = (0.0 ! ~size); //m: master volume in SynthDefs (instrument/track volume)
~m2 = (0.0 ! 4); //m: master volume in SynthDefs to be used with ~constantSynths
~synth = \sine ! ~size; //this var is to be used to select synths for tracks
~synth2 = \sine ! 4; //this var is used to select synths for constantSynths (no envelope)
~constantSynth = nil ! 4; //var to make constantSynths (no envelope)
~schedElasticLoopPlay = 0 ! ~size; //
~midiOrVal = 0 ! ~size;

(
~midiOutFunction = ({ arg track = 0;
	Task({
		1.do({
			// "play".postln;
			~midi.allNotesOff(track); //send noteOff
			0.05.wait; // some external MIDI device needs some time
			~midi.noteOn(track, p[track][c][0]); //send noteOn;
		});
	});

});
);



// sheduling with with tempoClock (t)
~sched = { |track|
	if(
		(p[track][c][0] == nil) || (p[track][c][0] == 0) || (p[track][c][1] == nil) || (p[track][c][1] == 0) || (p[track][c][2] == nil) || (p[track][c][2] == 0),

		{
			// (track+"track_pause as pit/amp/sus is nil").postln;
		},


		{
			if( ~midiOrVal[track] != 0,

				// not 0 - midiNoteOn sent to channels;

				{
					"midi out".postln;
					~midiOutFunction.value(track).play; //plays default;
				},

				// synth made in SuperCollider
				{
					Synth( ~synth[track],
						[
							// for synthesis
							\freq, p[track][c][0],
							\amp, p[track][c][1],
							\sustain, p[track][c][2],
							\master, m[track],
							\out, ~out,

							// for samples
							\buf, ~trackSample[track]
					], ~grp0);
				},
			);


		};
	);
};

//~playTask is used to make ~sched for each note in each track
(
//~delay = 0.0;
~playTask = {
	Routine{

		// for Elastic Loops;
		if(c==(~beat-4), //schedule them 4 beats before nextBar to make sure they are in the game for the next loop
			{
				~size.do{ |i|
					if	( ~onOffElastic[i] !== 0,
						{( "if c is 0 open on track: "+ i).postln;
							t.schedAbs(t.nextBar+~eBeat[i], {~schedElasticOnce.value(i).play}).postln;
							t.queue;
				};);};
		};);


		// for normal loops;
		s.bind{

			~size.do{ |i|
				if	( ~onOff[i] !== 0,
					{ ~sched.value(i);});
				// ~delay.wait;
	};};};

};
);

//Elastic Clock
//Schedule Once
~schedElasticOnce = { |track|
	var stream = p[track];
	Routine{
		~beat.do{|i|

			if( (stream[i%~beat][0] == nil) || (stream[i%~beat][0] == 0) || (stream[i%~beat][1] == nil) || (stream[i%~beat][1] == 0) || (stream[i%~beat][2] == nil) || (stream[i%~beat][2] == 0),


				{

					// still need to wait
					// secure duration as if it is nil or 0 the scheduler freezes
					if(stream[i%~beat][3] != nil and: {stream[i%~beat][3] != 0 },

						{stream[i%~beat][3].wait},

						{0.01.wait;
							//"dur in nil or 0".postln;
						}
					);
					//"step with no sound".postln;
				},
				{
					Synth( ~synth[track],
						[ \freq, stream[i][0],
							\amp, stream[i][1],
							\sustain, stream[i][2],
							\master, m[track],
							\out, ~out,
							// for samples
							\buf, ~trackSample[track]
					], ~grp0);

					if(stream[i%~beat][3] != nil and: {stream[i%~beat][3] != 0 },
						{stream[i%~beat][3].wait},

						{0.01.wait;
							//"dur in nil or 0".postln;
						}
					);
			};);
		};
	};
};


// Schedule Loop
//~schedElasticLoopPlay[0] = ~schedElasticLoop.value(0).play;
//~schedElasticLoopPlay[0].stop;
~schedElasticLoop = {|track|
	var stream = p[track];
	Routine{
		inf.do{|i|

			if( (stream[i%~beat][0] == nil) || (stream[i%~beat][0] == 0) || (stream[i%~beat][1] == nil) || (stream[i%~beat][1] == 0) || (stream[i%~beat][2] == nil) || (stream[i%~beat][2] == 0),

				{
					// still need to wait
					// secure duration as if it is nil or 0 the scheduler freezes
					if(stream[i%~beat][3] != nil and: {stream[i%~beat][3] != 0 },

						{stream[i%~beat][3].wait},

						{0.01.wait;
							//"dur in nil or 0".postln;
						}
					);
					//"step with no sound".postln;
				},
				{
					Synth( ~synth[track],
						[ \freq, stream[i%~beat][0],
							\amp, stream[i%~beat][1],
							\sustain, stream[i%~beat][2],
							\master, m[track],
							\out, ~out,

							// for samples
							\buf, ~trackSample[track]
					], ~grp0);
					if(stream[i%~beat][3] != nil and: {stream[i%~beat][3] != 0 },

						{stream[i%~beat][3].wait},

						{0.01.wait;
							//"dur in nil or 0".postln;
						}
					);
				};
			);

		};
	};
};

~fadeConstantSynts = {
	arg track,vol,time=0.3,freqmidi,medOrAtt0,medOrAtt1;
	var fade = {
		arg a, b, time;
		var d = (b - a).abs; //absolute difference
		var e = time/100; //one step
		var f = d/100; //step size
		var g = a;
		if (a==0,
			{"fade in".postln;
				Task({100.do({
					g=g+f; ~constantSynth[track].set(\amp,g); e.wait;});}
				).start;
			},
			{"fade out".postln;
				Task({100.do({
					g=g-f; ~constantSynth[track].set(\amp,g); e.wait;});}
				).start;
	})};

	var changing = Task({
		var newVal0 = 0;
		var oldVal0 = 0;
		var newVal1 = 0;
		var oldVal1 = 0;

		inf.do({
			if(medOrAtt0==0,{newVal0 = ~meditation/100},{
				newVal0 = ~attention/100});
			if(medOrAtt1==0, {newVal1  = ~meditation/100},{
				newVal1 =  ~attention/100});
			if (newVal0 !== oldVal0,
				{
					~constantSynth[track].set(\change0, newVal0;);
					newVal0.postln});
			if (newVal1 !== oldVal1,
				{~constantSynth[track].set(\change1, newVal1)});
			oldVal0 = newVal0;
			oldVal1 = newVal1;
			0.01.wait;
		});
	});

	Task {
		// a : from
		// b : to
		// c : time
		("run fadePads on track : " + track).postln;

		if (~constantSynth[track].isPlaying == true,

			// free
			{"~constantSynth is playing > free".postln;
				fade.value(vol,0,time);
				x.stop; //changing Task
				time.wait;
				~constantSynth[track].free;
				~constantSynth[track] = nil; },
			// make synth
			{
				"make a synth".postln;
				~constantSynth[track] =
				Synth( ~synth2[track], [ \freq, freqmidi,
					\amp, 0.0,
					\master, ~m2[track],
					\change0, 0;
					\change1, 0;
					\out, ~out,
				]).register;

				0.3.wait; //maybe no need, just makes sure the above Synth is ready
				fade.value(0,vol,time);
				x = changing.start;
			};
	);};//end of Task
};//end of ~fadePads