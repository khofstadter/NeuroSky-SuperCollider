~grp0=Group(s);
~grp1=Group(s);
CmdPeriod.doOnce({~grp0.free;~grp1.free});

~synthList=[\sine,\saw,\windpad,\saw2,\bells,\FM0,\FM1,\FM2,\FM3,\FM4,\bells2,\nice1,\nice2,\newFM1,\newFM2,\newFM3,\newFM4,\laserbeam,\windX,\sample];
~synthList2=[\constantSaw1,\constantSaw2];

//## ~synthList (envelopedSynths)

(
//sine
SynthDef(~synthList[0],{|out,freq=37,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=SinOsc.ar(hz, 0);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-8),doneAction:2)*AmpComp.kr(hz);
	snd=LPF.ar(snd,16000);
	snd=Pan2.ar(snd,0);
	Out.ar(out,snd*amp*master/2);
}).add;
);
(
//saw
SynthDef(~synthList[1],{|out,freq=35,
	amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=RLPF.ar(
		Array.fill(2,{Saw.ar([hz+rrand(0,3),hz+rrand(0,3),])}),
		XLine.kr(12000,100,sustain+0.5),0.1,1);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-7),doneAction:2)*AmpComp.kr(hz);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,16000);
	snd=Pan2.ar(snd,FSinOsc.kr(sustain));
	Out.ar(out,snd*amp*master/10);
}).add;
);
(
//windpad
SynthDef(~synthList[2],{|out,freq=37,pan,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var freqs,ringtimes,snd;
	freqs=Control.names([\hz]).kr([1,1,1,1]);
	ringtimes=Control.names([\ringtimes]).kr([1,1,1,1]);
	snd=DynKlank.ar(`[freqs,
		nil,ringtimes],
	{ClipNoise.ar(0.003)}.dup,freq);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-8),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,pan);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,19000);
	Out.ar(out,snd*amp*master/3);
}).add;
);
(
//saw2
SynthDef(~synthList[3],{|out,freq=37,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=VarSaw.ar(hz,0,LFTri.kr(4,0.5,0.5,0.6));
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-8),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,0);
	snd=LPF.ar(snd,16000);
	snd=HPF.ar(snd,50);
	Out.ar(out,snd*amp*master/4);
}).add;
);
(
//bells
SynthDef(~synthList[4],{|out,freq=37,ringt=0.9,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=Saw.ar((hz/12),mul:0.05);
	var dynfreqs=[hz,hz,hz];
	var ringtimes=[ringt,ringt,ringt];
	snd=Klank.ar(`[dynfreqs,nil,ringtimes],snd);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-6),doneAction:2)*AmpComp.kr(hz);
	snd=MidEQ.ar(snd,7000,0.9,9);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,19000);
	snd=Pan2.ar(snd,0);
	Out.ar(out,snd*amp*master/6);
}).add;
);
(
//FM0
SynthDef(~synthList[5],{|out,freq,sustain,amp=0,master=0|
	var hz=freq.midicps;
	var snd=SinOsc.ar(hz,mul:400);
	snd=SinOsc.ar(snd*sustain/2);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,FSinOsc.kr(0.1));
	snd=LPF.ar(snd,18000);
	Out.ar(out,snd*amp*master/2);
}).add;
);
(
//FM1
SynthDef(~synthList[6],{|out,freq=440,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=Saw.ar(hz);
	snd=SinOsc.kr(hz,mul:snd,add:hz);
	snd=Saw.ar(snd);
	snd=snd*EnvGen.ar(Env.perc(0.04,sustain,1,-4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,FSinOsc.kr(sustain*freq.midicps/300));
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,19000);
	Out.ar(out,snd*amp*master/4);
}).add;
);
(
//FM2
SynthDef(~synthList[7],{|out,freq=37,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var move=SinOsc.kr(2);
	var snd= Pulse.kr(hz,mul:hz*(move*sustain)*hz/hz);
	snd=SinOsc.ar(snd);
	snd=snd*EnvGen.ar(Env.perc(0.3,sustain,1,-4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,move);
	snd=HPF.ar(snd,50);
	snd=MidEQ.ar(snd,100,1,3);
	snd=LPF.ar(snd,19000);
	Out.ar(out,snd*amp*master/4);
}).add;
);
(
//FM3
SynthDef(~synthList[8],{
	|out,freq=37,amp=0,master=0,sustain=0.25,harmdur=3|
	var hz=freq.midicps;
	var move=SinOsc.kr(SinOsc.kr(sustain)*sustain);
	var snd=
	Blip.ar(hz,Line.kr(sustain/2,sustain,
		dur:sustain*harmdur*amp),mul:678);
	snd=SinOsc.ar(snd);
	snd=snd*EnvGen.ar(Env.perc(0.4,sustain,1,1),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,move);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,19000);
	Out.ar(out,snd*amp*master/4);
}).add;
);
(
//FM4
SynthDef(~synthList[9],{
	|out,freq=37,amp=0,master=0,sustain=0.25,harmdur=2|
	var hz=freq.midicps;
	var osc1=SinOsc.ar(hz,
		phase:XLine.kr(1,500,1,sustain),mul:sustain*100);
	var osc2=LFSaw.ar(hz,mul:sustain*10);
	var osc3=FSinOsc.ar(hz,mul:sustain);
	var mod=osc1+osc2;
	var snd=SinOsc.ar(mod,amp);
	snd=((snd*osc3)*0.125+snd);//ringmodulation
	snd=snd*EnvGen.ar(Env.perc(0.3,sustain,1,-4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,0);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,19000);
	Out.ar(out,snd*amp*master/3);
}).add;
);
(
//bells2
SynthDef(~synthList[10],{|out,freq=37,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=Pulse.ar(hz,sustain/10,0.2);
	snd=Limiter.ar(snd,0.6);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-8),doneAction:2)*AmpComp.kr(hz);
	snd=GVerb.ar(snd,2,2);
	snd=Pan2.ar(snd,0);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,18000);
	Out.ar(out,snd*amp*master/4);
}).add;
);
(
//nice1
SynthDef(~synthList[11],{
|out,freq=37,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=SinOsc.ar(hz, 0);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,SinOsc.kr(sustain/3));
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,18000);
	Out.ar(out,snd*amp*master/7);
}).add;
);
(
//nice2
SynthDef(~synthList[12],{|out,freq=37,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var snd=Mix.new([
		Array.fill(4,{SinOsc.ar(hz+8.0.rand)});
	]);
	snd=snd*EnvGen.ar(Env.perc(0.03,sustain,1,-1),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,FSinOsc.kr(4));
	snd=MantissaMask.ar(snd,2);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,19000);
	Out.ar(out,snd*amp*master/10);
}).add;
);

(
//newFM1
SynthDef(~synthList[13],{|out,freq=37,carPartial=0.2,modPartial=0.8,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var mod,snd;
	var index=sustain*freq/30;
	//index usually between 0-24
	mod=SinOsc.ar(
		hz*modPartial,
		0,	hz*index*LFNoise1.kr(sustain.reciprocal).abs*(Saw.kr(sustain/2))
	);
	snd=SinOsc.ar(
		(hz*carPartial)+mod);
	snd=snd*EnvGen.ar(Env.perc(0.02,sustain,1,-4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,0);
	snd=HPF.ar(snd,50);
	Out.ar(out,snd*amp*master/4);
}).add;
);
(
//newFM2
SynthDef(~synthList[14],{|out,freq=50,carPartial=0.9,modPartial=0.3,index=1,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var mod,snd;
	//carPartial::modPartial=>car/modratio
	mod=SinOsc.ar(
		hz*modPartial,
		0,
		hz*index*LFNoise1.kr(5.reciprocal).abs*(Saw.kr(sustain)));
	snd=Mix.new(
		Array.fill(5,{|i|
			SinOsc.ar((hz*carPartial+(i/5))+mod)
			;})
	);
	snd=snd*EnvGen.ar(Env.perc(0.02,sustain,1,4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,FSinOsc.kr(0.1));
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,18000);
	Out.ar(out,snd*amp*master/22);
}).add;
);
(
//newFM3
SynthDef(~synthList[15],{|out,freq=45,carPartial=0.5,modPartial=0.5,index=1,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var mod,snd;
	mod=SinOsc.ar(
		hz*modPartial*(Saw.kr(amp)/6789),
		0,hz*index*LFNoise1.kr(sustain*2.reciprocal).abs);
	snd=Mix.new(
		Array.fill(5,{|i|
			SinOsc.ar((hz*carPartial+(i/2))+mod*(i))
			;}));
	snd=snd*EnvGen.ar(Env.perc(0.02,sustain,1,4),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,FSinOsc.kr(0.05*sustain));
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,18000);
	Out.ar(out,snd*amp*master/20);
}).add;
);
(
//newFM4
SynthDef(~synthList[16],{|out,freq=50,carPartial=0.4,modPartial=0.95,index=2,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var mod,snd;
	mod=SinOsc.ar(
		hz*modPartial,
		0,	hz*index*LFNoise1.kr(5.reciprocal).abs*(SinOsc.kr(SinOsc.kr(0.1)))*BrownNoise.kr(1));
	snd=Mix.new(
		Array.fill(2,{|i|
		SinOsc.ar((hz*carPartial+(i/2))+mod)
			;})
	);
	snd=snd*EnvGen.ar(Env.perc(0.02,sustain,1,4),doneAction:2)*AmpComp.kr(hz);	snd=Pan2.ar(snd,FSinOsc.kr(0.3));
	snd=CombC.ar(snd,0.1,XLine.kr(0.0001,0.1,5),0.2);
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,18000);
	Out.ar(out,snd*amp*master/30);
}).add;
);
(
//laserbeamfromstealthisosund
SynthDef(~synthList[17],{|out,freq=440,attackTime=0.01,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var freqenv=EnvGen.ar(Env([6,0.5,1,1],[attackTime,0.01,0.5]));
	var osc1=LFTri.ar(hz*freqenv,0);
	var ampenv=EnvGen.ar(Env.perc(0.02,sustain,1,4),doneAction:2)*AmpComp.kr(hz);
	var snd=osc1*ampenv;
	snd=Pan2.ar(snd,FSinOsc.kr(0.3));
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,17000);
	Out.ar(out,snd*amp*master/6);
}).add;
);
(
//windX
SynthDef(~synthList[18],{|out,freq=24,amp=0,master=0,sustain=0.25|
	var hz=freq.midicps;
	var freqs,ringtimes,snd;
	freqs=Control.names([\freqs.midicps]).kr([1,1,1,1]);
	ringtimes=Control.names([\ringtimes]).kr([1,1,1,1]);
	snd=DynKlank.ar(`[freqs,nil,ringtimes],{ClipNoise.ar(0.01)}.dup,freq);
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-8),doneAction:2)*AmpComp.kr(hz);
	snd=Pan2.ar(snd,FSinOsc.kr(0.3*sustain));
	snd=HPF.ar(snd,50);
	snd=LPF.ar(snd,18000);
	snd=Resonz.ar(snd,XLine.kr(freq/2,1000,sustain/100),0.99);
	Out.ar(out,snd*amp*master/2);
}).add;
);
(
//sample
SynthDef(~synthList[19],{|out,freq,buf,amp=0.5,master=0.0,sustain=0.25|
	var snd;
	snd=PlayBuf.ar(2,buf,(freq/60),doneAction:2);//monoagain;
	snd=snd*EnvGen.ar(Env.perc(0.01,sustain,1,-8),doneAction:2);
	//	snd=Pan2.ar(snd,0);
	snd=Splay.ar(snd);
	Out.ar(out,snd*amp*master*2);//withtherandombuttontheyarequiet;
}).add;
);

//## ~synthList2 (constantSynths)

//constantSaw1
SynthDef(~synthList2[0],{|freq=35,amp=0,master=0,out,change0=0,change1=0|
	var hz=freq.midicps;
	var snd=RLPF.ar(
		Array.fill(4,{
			Saw.ar([
				hz,
				hz+1,
				hz+2,
				hz+3
		])})*AmpComp.kr(hz),
		change0.linlin(0,1,100,150));
	snd=HPF.ar(snd,70);
	snd=LPF.ar(snd,16000);
	snd=Pan2.ar(snd,SinOsc.kr(change1.linlin(0,1,0.3,0.01)));
	snd=FreeVerb.ar(snd,0.4,0.1,0.5,1,0);
	Out.ar(out,snd*amp*master*4);
}).add;

//constantSaw2
SynthDef(~synthList2[1],{|freq=37,ringt=0.5,pan,amp=0,master=0,out,change0,change1|
	var snd=VarSaw.ar(
		freq:freq.midicps*change1.linlin(0,1,0.027,0.024),
		width:LFTri.kr(
			freq:change1.linlin(0,1,freq.midicps,freq.midicps+12),
			iphase:0,
			mul:0,
			add:0.5)
	);
	var dynfreqs=[freq.midicps,(freq+12).midicps,(freq+24).midicps];
	var ringtimes=[ringt,ringt,ringt];//couldbychangedbyeeg
	snd=Klank.ar(`[dynfreqs,nil,ringtimes],snd);
	snd=Pan2.ar(snd,SinOsc.kr(change1.linlin(0,1,0.6,0.01)));
	snd=HPF.ar(snd,70);
	snd=LPF.ar(snd,change0.linexp(0,1,17000,300));
	snd=FreeVerb.ar(snd,0.73,0.7,0.5,1,0);
	Out.ar(out,snd*amp*master*4);
}).add;

//## mastering

//compressor
SynthDef(\compressor,{
	var in,compressed,snd;
	in=In.ar(0,2);
	snd=Compander.ar(in,in,0.1,1,1/3,0.01,0.01);
	ReplaceOut.ar(0,snd);
}).add;

//main
SynthDef(\main,{|out=0,master=1|
	var snd=In.ar(out,2);
	snd=Select.ar(CheckBadValues.ar(snd,0,2),[snd,DC.ar(0),DC.ar(0),snd]);
	snd=Limiter.ar(LeakDC.ar(snd));
	ReplaceOut.ar(out,snd*master);
}).add;

"synthsloaded".postln;