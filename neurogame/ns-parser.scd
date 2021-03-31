(
var accumR;
~sigQ = 0;

~attSig=0;
~medSig=0;
~attSmooth = 0;
~medSmooth = 0;
~eegPower = 0 ! 8;
~delta = 0 ! 3;
~theta = 0 ! 3;
~lowalpha = 0 ! 3;
~highalpha = 0 ! 3;
~lowbeta = 0 ! 3;
~highbeta = 0 ! 3;
~lowgamma = 0 ! 3;
~midgamma = 0 ! 3;

~smootheegPower = 0 ! 10; //contains eSenses as well, if accumR[8] and accumR[9] is chosen to be used in smoothing Tasks


accumR = Array.fill(10, {arg i; Routine { |in|
	var accum = [], n = 5;
	loop {
		accum = accum.add(in).keep(n.neg);
		~smootheegPower[i] = (accum.sum / accum.size).round(0.1);
		in = (accum.sum / accum.size).yield;
	}
};};);


~smoothAttTask = Task({
	var oldAtt = 0;
	var genAtt = 0;
	var length = 0;
	inf.do({

		//oldAtt = ~smootheegPower[8]+1; //+1 so it never is 0,  SLOWER
		oldAtt = ~attSig+1; //+1 so it never is 0, FASTER

		length = oldAtt - genAtt;
		//("length" + length).postln;

		case	{length == 0}	{
			5.do({ |i|
				~attSmooth = genAtt;
				//("fake smoothed data" + ~attSmooth).postln;
				(1.0/5).wait;


			}); //if data doesn't change flicker for a sec
		}
		{length > 0}	{
			length.do({ |i|
				~attSmooth = genAtt+i;
				//("smoothed data" + ~attSmooth).postln;
				(1.0/length).wait;
			});
		}
		{length < 0}	{
			length = length.abs;
			length.do({ |i|
				~attSmooth = genAtt-i;
				//("smoothed data" + ~attSmooth).postln;
				(1.0/length).wait;

			});
		};

		//("oldAtt			" + genAtt).postln;
		genAtt = oldAtt;
		//("generatedAttention		" + genAtt).postln;

	}) //end do
});

~smoothMedTask = Task({
	var oldMed = 0;
	var genMed = 0;
	var length = 0;
	inf.do({

		//oldMed = ~smootheegPower[9]+1; //+1 so it never is 0
		oldMed = ~medSig+1; //+1 so it never is 0
		length = oldMed - genMed;
		//("length" + length).postln;

		case	{length == 0}	{
			5.do({ |i|
				~medSmooth = genMed;
				//("fake smoothed data" + ~medSmooth).postln;
				(1.0/5).wait;


			});
		}
		{length > 0}	{
			length.do({ |i|
				~medSmooth = genMed+i;
				//("smoothed data" + ~medSmooth).postln;
				(1.0/length).wait;
			});
		}
		{length < 0}	{
			length = length.abs;
			length.do({ |i|
				~medSmooth = genMed-i;
				//("smoothed data" + ~medSmooth).postln;
				(1.0/length).wait;

			});
		};

		//("oldAtt			" + genMed).postln;
		genMed = oldMed;
		//("genMed		" + genMed).postln;
	}) //end do
});

// NEUROSKYCONNECT TASK
~neuroSkyConnect = Task({
	var sP=nil;
	var serialOpen =

	Task({ sP = SerialPort(
		//"/dev/tty.MindWaveMobile-DevA-2",
		"/dev/tty.MindWaveMobile-DevA", // stopped working in 2015 (Mavericks or new Nsky driver)
		//"/dev/tty.MindSet-DevB",
		baudrate: 57600,
		crtscts: true); //hardwareflow control
	});

	if(~parser.isPlaying,
		{
			~parser.stop; //stop the parser below
			SerialPort.closeAll;
			~smoothMedTask.stop;
			~smoothAttTask.stop;
		},


		// if parser is not playing than start it:
		{

			serialOpen.start; //open the serail port

			3.wait; //wait for serial port to be open
			~smoothMedTask.start;
			~smoothAttTask.start;

			//parsing the asychronous serial stream from the NeuroSky Headset
			~parser = Routine.run({
				var readOneByte = 0;
				var loadLength = 0;
				var payloadData = 0;
				var generatedchecksum = 0;
				var checksum = 0;
				var poorQuality = 0;
				inf.do{
					readOneByte = sP.read;

					if(readOneByte==170, //sync 1
						{
							// ("sync 01" + readOneByte.value).postln;
							readOneByte = sP.read;
							if(readOneByte==170, //sync 2
								{
									//	("sync 02" + readOneByte.value).postln;

									loadLength = sP.read;				//
									if (loadLength < 169,
										{
											//("loadLength" + loadLength.value).postln;

											payloadData = Array.fill(loadLength, {0});
											loadLength.do{ |i|
												payloadData[i] = sP.read;
												generatedchecksum = payloadData.sum;	//sum it
												generatedchecksum = generatedchecksum&255; //keep lower 8bits
												generatedchecksum = 255-generatedchecksum;

												// the same thing in one line and using hex notation
												//~checkload= 0xFF-(~payload.sum&0xFF);

											};

											checksum = sP.read;

											if( checksum == generatedchecksum,
												{
													//("payloadData " + payloadData.value).postln;

													//with good signal quality:
													/*loadLength 32
													payloadData  [ 2, 0, 131, 24, 1, 45, 241, 1, 2, 175, 0, 84, 218, 0, 29, 158, 0, 26, 83, 0, 77, 211, 0, 43, 118, 0, 9, 102, 4, 88, 5, 66 ]
													loadLength 4
													payloadData  [ 128, 2, 0, 9 ]*/


													//very bad signal quality:
													/*
													loadLength 32
													payloadData  [ 2, 200, 131, 24, 1, 111, 239, 1, 127, 163, 0, 61, 112, 0, 137, 61, 0, 84, 22, 0, 51, 161, 0, 71, 126, 0, 66, 130, 4, 0, 5, 0 ]
													loadLength 4
													payloadData  [ 128, 2, 0, 154 ]*/

													/*
													THIS IS ONLY THE SEQUENCE IN THE PAYLOAD DATA
													for more information check 'mindset communication protocol' by neurosky

													[ 0]: 0x02 // [POOR_SIGNAL] Quality
													[ 1]: 0x00 // No poor signal detected (0/200)
													[ 2]: 0x83 // [ASIC_EEG_POWER_INT]
													[ 3]: 0x18 // [VLENGTH] 24 bytes
													[ 4]: 0x00 // (1/3) Begin Delta bytes
													[ 5]: 0x00 // (2/3)
													[ 6]: 0x94 // (3/3) End Delta bytes
													[ 7]: 0x00 // (1/3) Begin Theta bytes
													[ 8]: 0x00 // (2/3)
													[ 9]: 0x42 // (3/3) End Theta bytes
													[10]: 0x00 // (1/3) Begin Low-alpha bytes
													[11]: 0x00 // (2/3)
													[12]: 0x0B // (3/3) End Low-alpha bytes
													[13]: 0x00 // (1/3) Begin High-alpha bytes
													[14]: 0x00 // (2/3)
													[15]: 0x64 // (3/3) End High-alpha bytes
													[16]: 0x00 // (1/3) Begin Low-beta bytes
													[17]: 0x00 // (2/3)
													[18]: 0x4D // (3/3) End Low-beta bytes
													[19]: 0x00 // (1/3) Begin High-beta bytes
													[20]: 0x00 // (2/3)
													[21]: 0x3D // (3/3) End High-beta bytes
													[22]: 0x00 // (1/3) Begin Low-gamma bytes
													[23]: 0x00 // (2/3)
													[24]: 0x07 // (3/3) End Low-gamma bytes
													[25]: 0x00 // (1/3) Begin Mid-gamma bytes
													[26]: 0x00 // (2/3)
													[27]: 0x05 // (3/3) End Mid-gamma bytes
													[28]: 0x04 // [ATTENTION] eSense
													[29]: 0x0D // eSense Attention level of 13
													[30]: 0x05 // [MEDITATION] eSense
													[31]: 0x3D // eSense Meditation level of 61
													[32]: 0x34 // [CHKSUM] (1's comp inverse of 8-bit Payload sum of 0xCB)*/

													// for raw data;
													// if (payloadData[0] == 0x80, { };);


													// [POOR_SIGNAL] Quality (always 0x02)
													if (payloadData[0] == 0x02,

														{
															// ("sQuality " + payloadData[1].value).postln;
															// No poor signal detected (0/200)
															~sigQ = payloadData[1];

															//[ASIC_EEG_POWER_INT]
															~delta[0] = payloadData[4];
															~delta[1] = payloadData[5];
															~delta[2] = payloadData[6];
															~theta[0] = payloadData[7];
															~theta[1] = payloadData[8];
															~theta[2] = payloadData[9];
															~lowalpha[0] = payloadData[10];
															~lowalpha[1] = payloadData[11];
															~lowalpha[2] = payloadData[12];
															~highalpha[0] = payloadData[13];
															~highalpha[1] = payloadData[14];
															~highalpha[2] = payloadData[15];
															~lowbeta[0] = payloadData[16];
															~lowbeta[1] = payloadData[17];
															~lowbeta[2] = payloadData[18];
															~highbeta[0] = payloadData[19];
															~highbeta[1] = payloadData[20];
															~highbeta[2] = payloadData[21];
															~lowgamma[0] = payloadData[22];
															~lowgamma[1] = payloadData[23];
															~lowgamma[2] = payloadData[24];
															~midgamma[0] = payloadData[25];
															~midgamma[1] = payloadData[26];
															~midgamma[2] = payloadData[27];

															~deltaPower = ((~delta[0] << 16) + (~delta[1] << 8) + (~delta[2]));
															~thetaPower = ((~theta[0] << 16) + (~theta[1] << 8) + (~theta[2]));
															~lowalphaPower = ((~lowalpha[0] << 16) + (~lowalpha[1] << 8) + (~lowalpha[2]));
															~highalphaPower = ((~highalpha[0] << 16) + (~highalpha[1] << 8) + (~highalpha[2]));
															~lowbetaPower = ((~lowbeta[0] << 16) + (~lowbeta[1] << 8) + (~lowbeta[2]));
															~highbetaPower = ((~highbeta[0] << 16) + (~highbeta[1] << 8) + (~highbeta[2]));
															~lowgammaPower = ((~lowgamma[0] << 16) + (~lowgamma[1] << 8) + (~lowgamma[2]));
															~midgammaPower = ((~midgamma[0] << 16) + (~midgamma[1] << 8) + (~midgamma[2]));

															/*("eegPower" + (~eegPower = [~deltaPower, ~thetaPower, ~lowalphaPower, ~highalphaPower, ~lowbetaPower, ~highbetaPower,  ~lowgammaPower, ~midgammaPower].linlin(0, 16777215, 0, 5000).round(0.1))).postln;*/

															~eegPower = [~deltaPower, ~thetaPower, ~lowalphaPower, ~highalphaPower, ~lowbetaPower, ~highbetaPower,  ~lowgammaPower, ~midgammaPower].linlin(0, 16777215, 0, 5000).round(0.1);


															accumR[0].(~eegPower[0]);
															accumR[1].(~eegPower[1]);
															accumR[2].(~eegPower[2]);
															accumR[3].(~eegPower[3]);
															accumR[4].(~eegPower[4]);
															accumR[5].(~eegPower[5]);
															accumR[6].(~eegPower[6]);
															accumR[7].(~eegPower[7]);


															// ("attention " + payloadData[29].value).postln;
															~attSig = payloadData[29];
															// ("meditation " + payloadData[31].value).postln;
															~medSig = payloadData[31];


															accumR[8].(~attSig);
															accumR[9].(~medSig);



															//~smootheegPower.postln;

														};
													);

												}
												, {
													//"wrong checksum".postln
												};
											); //if checksum end

									}; ); //if loadLength end
							};); // sync 2 end
					};); // sync 1 end

					0.001.wait; // PARSER SPEED, don't go above, perhaps down..

				}; //end inf.do
			});
		}; //end if true
	); //end of if structure
}); //end Task;


//CmdPeriod.doOnce({~sendOsc.stop;}); // you can close the port and stop the task with this


)