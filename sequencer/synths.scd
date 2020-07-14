~grp0= Group(s);
~grp1= Group(s);
CmdPeriod.doOnce({~grp0.free; ~grp1.free});


~synthList = [\test, \synht1, \windpad, \saw, \bells, \simpleFM, \FM1, \FM2, \FM3, \FM4, \bells2, \nice1, \nice2, \nice3, \ring1, \newFM1, \newFM2, \newFM3, \newFM4, \laserbeam, \moogbasstone, \moogbasstone2, \mrostinato, \plastickystrings, \bassfoundationandhighend, \windX, \sample, \popsynth, \sine];
~synthList2 = [\constantSynh, \constantSaw];

//~synthList
//test
SynthDef(~synthList[0], { arg freq, amp = 0.5, sustain, gate = 1, master;
	var snd, env, oscfreq, output;
	var lfo;
	oscfreq = {freq.midicps * LFNoise2.kr(Rand(0.01,0.1)).range(0.98, 1.02)}!3;
	lfo = { SinOsc.kr({ 1/Rand(2,52) }!3) };
	env = EnvGen.ar(Env.perc(0.01, sustain, 1, -7), doneAction:2);
	output = LFSaw.ar(oscfreq, mul: lfo.value.range(0,1));
	output = RLPF.ar(output, (env*freq) + 1*freq * lfo.value.range(1/4), lfo.value.range(0.1,1));
	output = Splay.ar(output, lfo.value.range(0,1));
	Out.ar(0, output*env*amp*master/2);
}).add;

// synth1
SynthDef(~synthList[1], {|change0=0, change1=0, out, freq=35, pan=5, amp=0.0, master=0.0, sustain=0.25|
	var snd = RLPF.ar(
		Array.fill(2, { Saw.ar([freq.midicps+rrand(0,3),freq.midicps+rrand(0,3),])}),
		XLine.kr(12000, 100, sustain+0.5), 0.1, 1);
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -7), doneAction:2);
	snd = HPF.ar(snd, 70);
	snd = LPF.ar(snd, 17000);
	snd = Pan2.ar(snd, FSinOsc.kr(sustain));
	Out.ar(out, snd*amp*master/6);
}).add;


// windpad
SynthDef(~synthList[2], { |change0=0, change1=0, out, freq=37, pan, amp=0.0, master=0.0, sustain=0.25|
	var freqs, ringtimes, snd;
	freqs = Control.names([\freqs.midicps]).kr([1, 1, 1, 1]); //?
	ringtimes = Control.names([\ringtimes]).kr([1, 1, 1, 1]);
	snd = DynKlank.ar(`[freqs*change0.linlin(0,1,1,7), nil, ringtimes*change1.linlin(0,1,1,2) ], {ClipNoise.ar(0.003)}.dup, freq);
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -8), doneAction:2);
	snd = Pan2.ar(snd, pan);
	snd = HPF.ar(snd, 50);
	snd = LPF.ar(snd, 5000);
	Out.ar(out, snd*amp*master);
}).add;


// saw
SynthDef(~synthList[3], { |change0=0, change1=0, out, freq=37, pan, amp=0.0, master=0.0, sustain=0.25|
	var snd = VarSaw.ar(freq.midicps*change0.linlin(0,1,1,1.05), 0, LFTri.kr(4,0.5,0.5,0.6));
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -8), doneAction:2);
	snd = Pan2.ar(snd, pan);
	snd = LPF.ar(snd, 16000);
	snd = HPF.ar(snd, 50);
	Out.ar(out, snd*amp*master/2);
}).add;

////bells
SynthDef(~synthList[4], {|change0=0, change1=0, out, freq=37, ringt=0.9, pan, amp=0.0, master=0.0, sustain=0.25|
	var snd = Saw.ar(freq*change0.linlin(0.0,1.0,1,3), mul: 0.05);
	var dynfreqs = [freq.midicps, freq.midicps, freq.midicps];
	var ringtimes = [ringt, ringt, ringt]; //could by changed by eeg
	snd = Klank.ar(`[dynfreqs, nil, ringtimes], snd);
	snd = snd * EnvGen.ar(Env.perc(0.01,sustain, 1, -6), doneAction:2);
	snd = MidEQ.ar(snd, 7000, 0.9, 9);
	snd = HPF.ar(snd, 200);
	snd = LPF.ar(snd, 17000);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd*amp*master/2);
}).add;

//simpleFM
SynthDef(~synthList[5],{|freq,sustain,pan,amp=0,master=0,out|
	var snd = SinOsc.ar(freq.midicps, mul:500);
	snd = SinOsc.ar(snd*sustain/2);
	snd = snd*EnvGen.ar(Env.perc(0.01,sustain,1,-4),doneAction:2);
	snd = Pan2.ar(snd,FSinOsc.kr(0.2));
	snd = LPF.ar(snd,17000);
	Out.ar(out,snd*amp*master);
}).add;

//FM1
SynthDef(~synthList[6], { |change0=0, change1=0, out, freq=440, pan=0.5, amp=0.0, master=0.0, sustain=0.25|
	var snd = Saw.ar(freq.midicps*change0.linlin(0,1,1,1.05));
	snd = SinOsc.kr(freq.midicps*change0.linlin(0,1,1,1.05), mul: snd, add:freq.midicps);
	snd = Saw.ar(snd);
	snd = snd * EnvGen.ar(Env.perc(0.04, sustain, 1, -4), doneAction:2);
	snd = Pan2.ar(snd, FSinOsc.kr(2));
	snd = HPF.ar(snd, 50);
	//	snd = LPF.ar(snd, 14000);
	Out.ar(out, snd*amp*master/2);
}).add;

//FM2
SynthDef(~synthList[7], { |change0=0, change1=0, out, freq=37, pan=2, amp=0.0, master=0.0, sustain=0.25|
	var move = SinOsc.kr(pan);
	var snd = Pulse.kr(freq.midicps*change0.linlin(0,1,1,1.05), mul: freq.midicps*change0.linlin(0,1,1,1.05) * (move * sustain) * freq.midicps*change0.linlin(0,1,1,1.05)/(freq.midicps*change0.linlin(0,1,1,1.05)/move));
	snd = SinOsc.ar(snd);
	snd = snd * EnvGen.ar(Env.perc(0.3, sustain, 1, -4), doneAction:2);
	snd = Pan2.ar(snd, move);
	snd = HPF.ar(snd, 50);
	snd = MidEQ.ar(snd, 100, 1, 3);
	//	snd = MidEQ.ar(snd, 10000, 1, 3); //I DON'T THINK THIS WORKS
	Out.ar(out, snd*amp*master/2);
}).add;

//FM3
SynthDef(~synthList[8], {
	|change0=0, change1=0, out, freq=37, pan=0, amp=0.0, master=0.0, sustain=0.25, harmdur=3|
	var move = SinOsc.kr(SinOsc.kr(sustain)*sustain);
	var snd =
	Blip.ar(freq.midicps*change0.linlin(0,1,1,1.05), Line.kr(sustain/2, sustain,
		dur: sustain * harmdur*amp
	), mul: 667);
	snd = SinOsc.ar(snd);
	snd = snd * EnvGen.ar(Env.perc(0.4, sustain, 1, 1), doneAction:2);
	snd = Pan2.ar(snd, move);
	snd = HPF.ar(snd, 60);
	Out.ar(out, snd*amp*master/2);
}).add;

//FM4
// variables use:
SynthDef(~synthList[9], {
	|change0=0, change1=0, out, freq=37, pan=0, amp=0.0, master=0.0, sustain=0.25, harmdur=2|
	var osc1 = SinOsc.ar(freq.midicps*change0.linlin(0,1,1,1.05),
		phase: XLine.kr(1, 500, 1, sustain), mul: 200);
	var osc2 = LFSaw.ar(freq.midicps*change1.linlin(0,1,1,0.1), mul: 200);
	var osc3 = FSinOsc.ar( freq.midicps*2
	);
	var mod = osc1+osc2;
	var snd = SinOsc.ar(mod, amp);
	snd = ((snd * osc3) * 0.125 + snd); //ring modulation

	snd = snd * EnvGen.ar(Env.perc(0.3, sustain, 1, -4), doneAction:2);
	snd = Pan2.ar(snd, pan);
	snd = HPF.ar(snd, 100);
	Out.ar(out, snd*amp*master);
}).add;


//bells2
SynthDef(~synthList[10], {|change0=0, change1=0, out, freq=37, pan = 0, amp=0.0, master=0.0, sustain=0.25|
	var snd = Pulse.ar(freq.midicps*change0.linlin(0,1,1,1.05), 0.1, 4);
	snd = HPF.ar(snd, 300);
	snd = Limiter.ar(snd);
	snd = snd * EnvGen.ar(Env.perc(0.01,sustain, 1, -8), doneAction:2);
	snd = Pan2.ar(snd, pan);
	snd = HPF.ar(snd, 100);
	snd = GVerb.ar(snd, 5, 2);
	Out.ar(out, snd*amp*master/2);
}).add;

// nice1
SynthDef(~synthList[11], { |change0=0, change1=0, out, freq=37, pan = 5, amp=0.0, master=0.0, sustain=0.25|
	var snd = Mix.new([
		Array.fill(2, {SinOsc.ar(freq.midicps*change0.linlin(0,1,1,1.05), 0)});
	]);
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -4), doneAction:2);
	snd = Pan2.ar(snd, SinOsc.kr(pan));
	snd = HPF.ar(snd, 100);
	Out.ar(out, snd*amp*master/4);
}).add;

// nice2
SynthDef(~synthList[12], { |change0=0, change1=0, out, freq=37, pan = 4, amp=0.0, master=0.0, sustain=0.25|
	var snd = Mix.new( [
		Array.fill(8, {SinOsc.ar(freq.midicps*change0.linlin(0,1,1,1.05) + 8.0.rand, 0) });
	]);
	snd = snd * EnvGen.ar(Env.perc(0.03, sustain, 1, -1), doneAction:2);
	snd = Pan2.ar(snd, FSinOsc.kr(pan));
	snd = MantissaMask.ar(snd, 3);
	snd = HPF.ar(snd, 200);
	snd = LPF.ar(snd, change1.linlin(0,1,400,10000));
	Out.ar(out, snd*amp*master/4);
}).add;

// nice3
SynthDef(~synthList[13], { |change0=0, change1=0, out, freq=37, pan = 4, amp=0.0, master=0.0, sustain=0.25|
	var snd = Mix.new( 	[
		Array.fill(4, {SinOsc.ar(freq.midicps*change0.linlin(0,1,1,1.05) + 4.0.rand, 0) })
		+ SinOsc.ar(freq.midicps*change0.linlin(0,1,1,1.05)/2,0.4,0.1)
		+ SinOsc.ar(LFNoise0.ar(change1.linlin(0,1,50,1000),1),0,1,0.0);
	]);
	snd = snd * EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	snd = Pan2.ar(snd, FSinOsc.kr(pan));
	snd = HPF.ar(snd, 200);
	Out.ar(out, snd*amp*master/4);
}).add;

// ring1
SynthDef(~synthList[14], { |change0=0, change1=0, out, freq=37, pan = 4, amp=0.0, master=0.0, sustain=0.25|
	var snd =
	SinOsc.ar(freq: SinOsc.kr(freq.midicps*change0.linlin(0,1,1,1.05)/4,SinOsc.kr(0.1),SinOsc.kr(freq.midicps*change0.linlin(0,1,1,1.05)/4,SinOsc.kr(0.1),(SinOsc.kr(freq.midicps*change0.linlin(0,1,1,1.05),0,1))),add: freq).midicps,
		phase: 0,
		mul: 1);
	snd = snd * EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	snd = Pan2.ar(snd, FSinOsc.kr(sustain/3));
	snd = HPF.ar(snd, 200);
	snd = LPF.ar(snd, 14000);
	Out.ar(out, snd*amp*master/2);
}).add;

// newFM1
SynthDef(~synthList[15], { |change0=0, change1=0, out, freq=37, carPartial = 0.5, modPartial = 0.5, index = 10, pan = 0, amp=0.0, master=0.0, sustain=0.25|
	var mod, snd;
	// index values usually are between 0 and 24
	// carPartial :: modPartial => car/mod ratio
	mod = SinOsc.ar(
		freq.midicps*change0.linlin(0,1,1,1.05) * modPartial,
		0,
		freq.midicps*change0.linlin(0,1,1,1.05) * index * LFNoise1.kr(sustain.reciprocal).abs * (Saw.kr(change1.linlin(0,1,1,5)))
	);
	snd = SinOsc.ar(
		(freq.midicps * carPartial) + mod);
	snd = snd * EnvGen.ar(Env.perc(0.02, sustain, 1, -4), doneAction:2);
	snd = Pan2.ar(snd, 0);
	snd = HPF.ar(snd, 100);
	Out.ar(out, snd*amp*master/2);
}).add;

// newFM2
SynthDef(~synthList[16], { |change0=0, change1=0, out, freq=50, carPartial = 0.3, modPartial = 0.3, index = 5, pan = 1, amp=0.0, master=0.0, sustain=0.25|
	var mod, snd;
	// index values usually are between 0 and 24
	// carPartial :: modPartial => car/mod ratio
	mod = SinOsc.ar(
		freq.midicps*change0.linlin(0,1,1,1.1) * modPartial,
		0,
		freq.midicps*change1.linlin(0,1,1,1.5) * index * LFNoise1.kr(5.reciprocal).abs * (Saw.kr(change1.linlin(0,1,1,0.5))));
	snd = Mix.new(
		Array.fill(5, { |i|
			SinOsc.ar((freq.midicps  * carPartial+(i/5)) + mod)
			;})
	);
	snd = snd * EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	snd = Pan2.ar(snd, FSinOsc.kr(pan/change1.linlin(0,1,1,0.5)));
	snd = HPF.ar(snd, 60);
	Out.ar(out, snd*amp*master/5);
}).add;

// newFM3
// use for ~constantSynth with attention (0.0 - 1.0)
SynthDef(~synthList[17], { |change0=0, change1=0, out, freq=45, carPartial = 0.5, modPartial = 0.5, index = 1, pan = 0, amp=0.0, master=0.0, sustain=0.25|
	var mod, snd;
	// index values usually are between 0 and 24
	// carPartial :: modPartial => car/mod ratio
	mod = SinOsc.ar(
		freq.midicps*change0.linlin(0,1,1,10) * modPartial * (Saw.kr(amp)/6789),
		0,
		freq.midicps*change1.linlin(0,1,1,0.005) * index * LFNoise1.kr(sustain*2.reciprocal*change1.linlin(0,1,1,1.001)).abs);

	snd = Mix.new(
		Array.fill(5, { |i|
			SinOsc.ar((freq.midicps*change1.linlin(0,1,1,0.85) * (carPartial*change1.linlin(0,1,1,0.25))+(i/2)) + mod*(i))
			;}));
	snd = snd * EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	snd = Pan2.ar(snd, FSinOsc.kr(0.3));
	snd = HPF.ar(snd, 200);
	snd = LPF.ar(snd, 15000);
	Out.ar(out, snd*amp*master/6);
}).add;

// newFM4
// use for ~constantSynth with attention (0.0 - 1.0)
SynthDef(~synthList[18], { |change0=0, change1=0, out, freq=50, carPartial = 0.3, modPartial = 0.45, index = 2, pan = 0.5, amp=0.0, master=0.0, sustain=0.25|
	var mod, snd;
	// index values usually are between 0 and 24
	// carPartial :: modPartial => car/mod ratio
	mod = SinOsc.ar(
		freq.midicps*change0.linlin(0,1,1,1.05) * modPartial,
		0,
		freq.midicps*change0.linlin(0,1,1,1.05) * index * LFNoise1.kr(5.reciprocal).abs * (SinOsc.kr(SinOsc.kr(0.1))) * BrownNoise.kr(1));
	snd = Mix.new(
		Array.fill(2, { |i|
			SinOsc.ar((freq.midicps*change0.linlin(0,1,1,1.05)  * carPartial+(i/2)) + mod)
			;})
	);
	snd = snd * EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);	snd = Pan2.ar(snd, FSinOsc.kr(pan));
	snd = LPF.ar(snd, 13000);
	snd = CombC.ar(snd, 0.1, XLine.kr(0.0001, 0.1, 5),0.2);
	snd = RHPF.ar(snd, 200);
	snd = MidEQ.ar(snd, 2000, 0.1, 5);
	Out.ar(out, snd*amp*master/4);
}).add;

// laserbeam from stealthisosund
SynthDef(~synthList[19], { |change0=0, change1=0, out, freq=440, pan, amp=0.0, attackTime= 0.04, master=0.0, sustain=0.25|
	var freqenv = EnvGen.ar(Env([6,0.5,1,1],[attackTime,0.01,1.0]));
	var osc1 = LFTri.ar(freq.midicps*change0.linlin(0,1,1,1.05)*freqenv);
	var ampenv = EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	var snd = osc1*ampenv;
	snd = Pan2.ar(snd, FSinOsc.kr(0.3));
	Out.ar(out, snd*amp*master/3);
}).add;

// \moogbasstone from stealthisosund
SynthDef(~synthList[20], { |change0=0, change1=1, out, freq=55 pan=0.0 amp=0.0  gate=1 cutoff= 5000 gain=2.0 lagamount = 0.01 master=0.0 sustain=0.25|
	var osc = Mix(VarSaw.ar(freq.midicps*change0.linlin(0,1,1,1.05).lag(lagamount)*[1.0,1.001,2.0],Rand(0.0,1.0)!3,Rand(0.5,0.75)!3,0.33));
	var filterenv = EnvGen.ar(Env.adsr(0.1,0.0,1.0,0.2));
	var filter =  MoogFF.ar(osc,cutoff*(1.0+(0.5*filterenv)),gain);
	var env = EnvGen.ar(Env.perc(0.02, sustain, 1, -2), doneAction:2);
	var snd = Pan2.ar((0.7*filter+(0.5*filter.distort))*env*amp, pan);
	Out.ar(out, snd*amp*master*4);
}).add;

// \moogbasstone2 from stealthisosund
SynthDef(~synthList[21], { |change0=0, change1=0, out freq=55 pan=0.0 amp=0.0  gate=1 attackTime= 0.2 fenvamount=0.5 cutoff= 1000 gain=2.0 master=0.0 sustain=0.25|
	var osc = Mix(Pulse.ar(freq.midicps*change0.linlin(0,1,1,1.05).lag(0.05)*[1.0,1.001,2.0],Rand(0.45,0.5)!3,0.33));
	var filterenv = EnvGen.ar(Env.adsr(attackTime,0.0,1.0,0.2),gate,doneAction:2);
	var filter =  MoogFF.ar(osc,cutoff*(1.0+(fenvamount*filterenv)),gain);
	var env = EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	var snd = Pan2.ar((0.7*filter+(0.3*filter.distort))*env*amp, pan);
	Out.ar(out, snd*amp*master);
}).add;


// \mrostinato from stealthisosund
SynthDef(~synthList[22], {|change0=0, change1=0, out freq=440 pan=0.0 amp=0.0  lforate = 10 lfowidth= 0.5 master=0 sustain =0|
	var lfo = LFTri.kr(lforate,Rand(0,2.0)!3);
	var pulse = Pulse.ar(freq.midicps*change0.linlin(0,1,1,1.05)*[1,1.01,0.5],lfo*lfowidth+0.5);
	var env = EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	var snd = Pan2.ar(Mix(pulse)*env,pan);
	Out.ar(out, snd*amp*master/4);
}).add;

// \plastickystrings from stealthisosund
SynthDef(~synthList[23], {|change0=0, change1=0, out= 0 freq = 440 amp = 0.1 gate=1 lforate = 5900 lfowidth= 0.01 cutoff= 12000 rq=0.5 pan=0.0 master=0 sustain =0|
	var lfo = LFTri.ar(lforate,Rand(0,2.0));
	var saw = Saw.ar(freq.midicps*change0.linlin(0,1,1,1.05)*(1.0+(lfowidth*lfo)),0.5);
	var filter = BHiPass.ar(saw,freq,rq); 	//or using cutoff
	var env = EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	var snd = Pan2.ar(filter*env,pan);
	Out.ar(out, snd*amp*master);
}).add;

// \bassfoundationandhighend from stealthisosund
SynthDef(~synthList[24], {|change0=0, change1=0, out= 0 freq = 60 amp = 0.1 gate=1 cutoff1= 1000 cutoff2= 3000 rq1=0.5 rq2=0.1 drive=2 pan=0.0 master=0 sustain =0|
	var osc, osc2, filterenv, filter, filter2, ab, env, snd;
	osc = Saw.ar(freq.midicps*change0.linlin(0,1,1,1.05));
	osc2 = Mix(Saw.ar(freq.midicps*change0.linlin(0,1,1,1.05)*[0.25,1,1.5],[0.5,0.4,0.1]));
	filterenv = EnvGen.ar(Env.adsr(0.0,0.5,0.2,0.2),gate,doneAction:2);
	filter = RLPF.ar(osc,cutoff1*filterenv+100,rq1);
	filter2 = RLPF.ar(osc,cutoff2*filterenv+100,rq2);
	filter2 = filter2.distort.softclip;

	ab = abs(filter2);
	filter2 = (filter2*(ab + drive)/(filter2 ** 2 + (drive - 1) * ab + 1));

	//remove low end
	filter2 = BLowShelf.ar(filter2,300,1.0,-12);
	//dip at 1600Hz
	filter2 = BPeakEQ.ar(filter2,1600,1.0,-6);

	env = EnvGen.ar(Env.perc(0.02, sustain, 1, 4), doneAction:2);
	snd = Pan2.ar(Mix.new([filter,filter2])*env,pan);
	Out.ar(out, snd*amp*master*0.2);
}).add;


// windX
SynthDef(~synthList[25], { |change0=0, change1=0, out, freq=100, pan, amp=0.0, master=0.0, sustain=0.25|
	var freqs, ringtimes, snd;
	freqs = Control.names([\freqs.midicps]).kr([1, 1, 1, 1]); //?
	ringtimes = Control.names([\ringtimes]).kr([1, 1, 1, 1]);
	snd = DynKlank.ar(`[freqs, nil, ringtimes ], {ClipNoise.ar(0.005)}.dup, freq);
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -8), doneAction:2);
	snd = Pan2.ar(snd, pan);
	snd = HPF.ar(snd, 70);
	snd = Resonz.ar(snd, XLine.kr(freq/2,20000,sustain/20),0.99);
	Out.ar(out, snd*amp*master*4);
}).add;

//Sample
SynthDef(~synthList[26], { |out, freq, buf, amp=0.5, master=0.0, sustain=0.25|
	var snd;
	snd = PlayBuf.ar(2, buf, (freq/60), doneAction: 2); //mono again;
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -8), doneAction:2);
	//	snd = Pan2.ar(snd, 0);
	snd = Splay.ar(snd);
	Out.ar(out, snd*amp*master*2); //with the random button they are quiet;
}).add;

//pop-synth01
SynthDef(~synthList[27], { arg out, freq, pan, amp=0, master=0, sustain=0.25, gate=1, spread=0.5;
	var sig, sig1, sig2, sig3;
	sig1 = LFSaw.ar(freq.midicps * 1 + (0.04 * [1,-1]));
	sig2 = LFSaw.ar(freq.midicps * 0.99 );
	sig3 = LFSaw.ar(freq.midicps * 1 );
	sig = sig1 + sig2 + sig3;
	sig = (sig*50).tanh;
	sig = sig * EnvGen.ar(Env.perc(0.01, sustain, 1, -8), doneAction:2);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig*amp*master*2); //with the random button they are quiet;
}).add;

// sine
SynthDef(~synthList[28], {|change0=0, change1=1, out, freq=37, panfreq=1, amp=0.0, master=0.0, sustain=0.25|
	var move = SinOsc.kr(panfreq*change1.linlin(0,1,10,1));
	var snd = SinOsc.ar(freq.midicps*change0.linlin(0,1,1,2));
	snd = snd * EnvGen.ar(Env.perc(0.01, sustain, 1, -8), doneAction:2);
	snd = LPF.ar(snd, 15000);
	snd = Pan2.ar(snd, move);
	Out.ar(out, snd*amp*master/2);
}).add;


//________________________________________________________________________________________________
//________________________________________________________________________________________________
//________________________________________________________________________________________________

//~synthList2

// constansynth1
SynthDef(~synthList2[0],{|freq=35,amp=0,master=0,out,change0=0,change1=0|
var snd = RLPF.ar(
		Array.fill(4,{
			Saw.ar([
				freq.midicps,
				freq.midicps+1,
				freq.midicps+2,
				freq.midicps+3
		])}),
		change0.linlin(0,1,100,150));
	snd = HPF.ar(snd, 70);
	snd = LPF.ar(snd, 16000);
	snd = Pan2.ar(snd, SinOsc.kr(change1.linlin(0,1,0.3,0.01)));
	snd = FreeVerb.ar(snd, 0.4, 0.1, 0.5, 1, 0);
	Out.ar(out, snd*amp*master/2);
}).add;

// constansaw
SynthDef(~synthList2[1],{|freq=37,ringt=0.5,pan,amp=0,master=0,out,change0,change1|
	var snd = VarSaw.ar(
		freq:freq.midicps*change1.linlin(0,1,0.027,0.024),
		width:LFTri.kr(
			freq:change1.linlin(0,1,freq.midicps,freq.midicps+12),
			iphase:0,
			mul:0,
			add:0.1)
	);
	var dynfreqs = [freq.midicps, (freq+12).midicps, (freq+24).midicps];
	var ringtimes = [ringt,ringt,ringt]; //could by changed by eeg
	snd = Klank.ar(`[dynfreqs, nil, ringtimes], snd);
	snd = Pan2.ar(snd, SinOsc.kr(change1.linlin(0,1,0.6,0.01)));
	snd = HPF.ar(snd,70);
	snd = LPF.ar(snd,change0.linexp(0,1,17000,300));
	snd = FreeVerb.ar(snd, 0.73, 0.7, 0.5, 1, 0);
	Out.ar(out,snd*amp*master);
}).add;


//compressor
SynthDef(\compressor, {
	var in,compressed,snd;
	in = In.ar(0,2);
	snd = Compander.ar(in, in, 0.1, 1, 1/3, 0.01, 0.01);
	ReplaceOut.ar(0, snd);
}).add;

// main output with some stuff I don't understand :)
// from Fredik O.;
SynthDef(\main, {|out= 0, master = 1|
	var snd= In.ar(out, 2);
	snd= Select.ar(CheckBadValues.ar(snd, 0, 2), [snd, DC.ar(0), DC.ar(0), snd]);
	snd= Limiter.ar(LeakDC.ar(snd));
	ReplaceOut.ar(out, snd*master);
}).add;

"synths loaded".postln;