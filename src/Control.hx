package ;
  import org.si.sion.SiONDriver;
	import org.si.sion.SiONData;
	import org.si.sion.utils.SiONPresetVoice;
	import org.si.sion.SiONVoice;
	import org.si.sion.sequencer.SiMMLTrack;
	
	import org.si.sion.effector.SiEffectStereoDelay;
	import org.si.sion.effector.SiEffectStereoChorus;
	import org.si.sion.effector.SiEffectDistortion;
	import org.si.sion.effector.SiFilterLowBoost;
	import org.si.sion.effector.SiEffectCompressor;
	import org.si.sion.effector.SiCtrlFilterHighPass;
	import org.si.sion.effector.SiEffectStereoReverb;
	
	#if cpp
	import sys.FileSystem;
	import sys.io.FileInput;
	import sys.io.FileOutput;
	
		#if (!android && !emscripten)
			import systools.Dialogs;
		#end
	#end
	
	import openfl.display.Sprite;
	import openfl.events.Event;
	import org.si.sion.events.SiONEvent;

  //import flash.net.FileFilter;
  
  import flash.system.Capabilities;
  //import openfl.filesystem.File;
  #if cpp
	   import sys.io.File;
	   import sys.FileStat;
	   
	   #if (!android && !emscripten)
		import systools.Browser;
	   #end
   #end

  import flash.utils.ByteArray;
  import flash.net.SharedObject;
  
  import flash.utils.Endian;
  import haxe.io.Input;

		
	class Control{
		inline static var SCALE_NORMAL:Int = 0;
		inline static var SCALE_MAJOR:Int = 1;
		inline static var SCALE_MINOR:Int = 2;
		inline static var SCALE_BLUES:Int = 3;
		inline static var SCALE_HARMONIC_MINOR:Int = 4;
		inline static var SCALE_PENTATONIC_MAJOR:Int = 5;
		inline static var SCALE_PENTATONIC_MINOR:Int = 6;
		inline static var SCALE_PENTATONIC_BLUES:Int = 7;
		inline static var SCALE_PENTATONIC_NEUTRAL:Int = 8;
		inline static var SCALE_ROMANIAN_FOLK:Int = 9;
		inline static var SCALE_SPANISH_GYPSY:Int = 10;
		inline static var SCALE_ARABIC_MAGAM:Int = 11;
		inline static var SCALE_CHINESE:Int = 12;
		inline static var SCALE_HUNGARIAN:Int = 13;
		inline static var CHORD_MAJOR:Int = 14;
		inline static var CHORD_MINOR:Int = 15;
		inline static var CHORD_5TH:Int = 16;
		inline static var CHORD_DOM_7TH:Int = 17;
		inline static var CHORD_MAJOR_7TH:Int = 18;
		inline static var CHORD_MINOR_7TH:Int = 19;
		inline static var CHORD_MINOR_MAJOR_7TH:Int = 20;
		inline static var CHORD_SUS4:Int = 21;
		inline static var CHORD_SUS2:Int = 22;
		
		public inline static var LIST_KEY:Int = 0;
		public inline static var LIST_SCALE:Int = 1;
		public inline static var LIST_INSTRUMENT:Int = 2;
		public inline static var LIST_CATEGORY:Int = 3;
		public inline static var LIST_SELECTINSTRUMENT:Int = 4;
		public inline static var LIST_BUFFERSIZE:Int = 5;
		public inline static var LIST_MOREEXPORTS:Int = 6;
		public inline static var LIST_EFFECTS:Int = 7;
		public inline static var LIST_EXPORTS:Int = 8;
		public inline static var LIST_MIDIINSTRUMENT:Int = 9;
		public inline static var LIST_MIDI_0_PIANO:Int = 10;
		public inline static var LIST_MIDI_1_BELLS:Int = 11;
		public inline static var LIST_MIDI_2_ORGAN:Int = 12;
		public inline static var LIST_MIDI_3_GUITAR:Int = 13;
		public inline static var LIST_MIDI_4_BASS:Int = 14;
		public inline static var LIST_MIDI_5_STRINGS:Int = 15;
		public inline static var LIST_MIDI_6_ENSEMBLE:Int = 16;
		public inline static var LIST_MIDI_7_BRASS:Int = 17;
		public inline static var LIST_MIDI_8_REED:Int = 18;
		public inline static var LIST_MIDI_9_PIPE:Int = 19;
		public inline static var LIST_MIDI_10_SYNTHLEAD:Int = 20;
		public inline static var LIST_MIDI_11_SYNTHPAD:Int = 21;
		public inline static var LIST_MIDI_12_SYNTHEFFECTS:Int = 22;
		public inline static var LIST_MIDI_13_WORLD:Int = 23;
		public inline static var LIST_MIDI_14_PERCUSSIVE:Int = 24;
		public inline static var LIST_MIDI_15_SOUNDEFFECTS:Int = 25;
		
		public static var MENUTAB_FILE:Int = 0;
		public static var MENUTAB_ARRANGEMENTS:Int = 1;
		public static var MENUTAB_INSTRUMENTS:Int = 2;
		public static var MENUTAB_ADVANCED:Int = 3;
		public static var MENUTAB_CREDITS:Int = 4;
		public static var MENUTAB_HELP:Int = 5;
		
		public static function init():Void {
			version = 3;
			clicklist = false;
			clicksecondlist = false;
			midilistselection = -1;
			savescreencountdown = 0;
			
			
			test = false; teststring = "TEST = True";
			patternmanagerview = 0;
			dragaction = 0;
			trashbutton = 0;
			bpm = 120;
			
		i = 0;
	while( i < 144){ notename.push(""); i++;
}			
		j = 0;
	while( j < 12){
				scale.push(Std.int (1));
			 j++;
}
			
		i = 0;
	while( i < 256){
				pianoroll.push(i);
				invertpianoroll.push(i);
			 i++;
}
			scalesize = 12;
			
		j = 0;
	while( j < 11){
				notename[(j * 12) + 0] = "C";
				notename[(j * 12) + 1] = "C#";
				notename[(j * 12) + 2] = "D";
				notename[(j * 12) + 3] = "D#";
				notename[(j * 12) + 4] = "E";
				notename[(j * 12) + 5] = "F";
				notename[(j * 12) + 6] = "F#";
				notename[(j * 12) + 7] = "G";
				notename[(j * 12) + 8] = "G#";
				notename[(j * 12) + 9] = "A";
				notename[(j * 12) + 10] = "A#";
				notename[(j * 12) + 11] = "B";
			 j++;
}
			
		i = 0;
	while( i < 23){
				scalename.push("");
			 i++;
}
			scalename[SCALE_NORMAL] = "Scale: Normal";
			scalename[SCALE_MAJOR] = "Scale: Major";
			scalename[SCALE_MINOR] = "Scale: Minor";
			scalename[SCALE_BLUES] = "Scale: Blues";
			scalename[SCALE_HARMONIC_MINOR] = "Scale: Harmonic Minor";
			scalename[SCALE_PENTATONIC_MAJOR] = "Scale: Pentatonic Major";
			scalename[SCALE_PENTATONIC_MINOR] = "Scale: Pentatonic Minor";
			scalename[SCALE_PENTATONIC_BLUES] = "Scale: Pentatonic Blues";
			scalename[SCALE_PENTATONIC_NEUTRAL] = "Scale: Pentatonic Neutral";
			scalename[SCALE_ROMANIAN_FOLK] = "Scale: Romanian Folk";
			scalename[SCALE_SPANISH_GYPSY] = "Scale: Spanish Gypsy";
			scalename[SCALE_ARABIC_MAGAM] = "Scale: Arabic Magam";
			scalename[SCALE_CHINESE] = "Scale: Chinese";
			scalename[SCALE_HUNGARIAN] = "Scale: Hungarian";
			scalename[CHORD_MAJOR] = "Chord: Major";
			scalename[CHORD_MINOR] = "Chord: Minor";
			scalename[CHORD_5TH] = "Chord: 5th";
			scalename[CHORD_DOM_7TH] = "Chord: Dom 7th";
			scalename[CHORD_MAJOR_7TH] = "Chord: Major 7th";
			scalename[CHORD_MINOR_7TH] = "Chord: Minor 7th";
			scalename[CHORD_MINOR_MAJOR_7TH] = "Chord: Minor Major 7th";
			scalename[CHORD_SUS4] = "Chord: Sus4";
			scalename[CHORD_SUS2] = "Chord: sus2";
			
			looptime = 0;
			swingoff = 0;
			SetSwing(); //Swing functions submitted on gibhub via @increpare, cheers!
			
			_presets = new SiONPresetVoice();
			voicelist = new Voicelistclass();
			
			//Setup drumkits
			drumkit.push(new Drumkitclass()); //Midi Drums
			drumkit.push(new Drumkitclass()); 
			drumkit.push(new Drumkitclass()); 
			createdrumkit(0);
			createdrumkit(1);
			createdrumkit(2);
			
		i = 0;
	while( i < 16){
				instrument.push(new Instrumentclass());
				if (i == 0) {
				  instrument[i].voice = _presets.voices.get("midi.piano1");
				}else {
					voicelist.index = Std.int(Math.random() * voicelist.listsize);
					instrument[i].index = voicelist.index;
					instrument[i].voice = _presets.voices.get(voicelist.voice[voicelist.index]);
					instrument[i].category = voicelist.category[voicelist.index];
					instrument[i].name = voicelist.name[voicelist.index];
					instrument[i].palette = voicelist.palette[voicelist.index];
				}
				instrument[i].updatefilter();
			 i++;
}
			numinstrument = 1;
			instrumentmanagerview = 0;
			
		i = 0;
	while( i < 4096){
			  musicbox.push(new Musicphraseclass());
			 i++;
}
			numboxes = 1;
			
			arrange.loopstart = 0; arrange.loopend = 1;
			arrange.bar[0].channel[0] = 0;
			
			setscale(SCALE_NORMAL);
			key = 0;
			updatepianoroll();
		i = 0;
	while( i < numboxes){
			  musicbox[i].start = scalesize * 3;
			 i++;
}
			
			currentbox = 0;
			notelength = 1;
			currentinstrument = 0;
			
			boxcount = 16; barcount = 4;
			
			//programsettings = SharedObject.getLocal("boscaceoil_settings");
			buffersize = 2048;
			
			/*if (programsettings.data.buffersize == null) {
				buffersize = 2048;
				programsettings.data.buffersize = buffersize;
				programsettings.flush();
				programsettings.close();
				programsettings.data.fullscreen = 0;
				programsettings.data.windowsize = 2;
			  } else {
					buffersize = programsettings.data.buffersize;
					programsettings.flush();
					programsettings.close();
			  }*/
			
			
			_driver = new SiONDriver(buffersize); currentbuffersize = buffersize;
			_driver.debugMode = true;
			_driver.setBeatCallbackInterval(1);
			_driver.setTimerInterruption(1, _onTimerInterruption);
			
			effecttype = 0;
			effectvalue = 0;
			effectname.push("DELAY"); 
			effectname.push("CHORUS"); 
			effectname.push("REVERB"); 
			effectname.push("DISTORTION"); 
			effectname.push("LOW BOOST"); 
			effectname.push("COMPRESSOR"); 
			effectname.push("HIGH PASS");  
			
			_driver.addEventListener(SiONEvent.STREAM, onStream);
			
			_driver.bpm = bpm; 
			_driver.play(null, false);
			
			startup = 1;
			if (invokefile != "null") {
				onloadceol([invokefile]);
				invokefile = "null";
			}
			
			//super();
		}
		
		public static function notecut():Void {
			
			
		}
			
		public static function updateeffects():Void {
			
			//So, I can't see to figure out WHY only one effect at a time seems to work.
			//If anyone else can, please, by all means update this code!
			
			//start by turning everything off:
			_driver.effector.clear(0);
			
			if (effectvalue > 5) {
				if (effecttype == 0) {
					_driver.effector.connect(0, new SiEffectStereoDelay((300 * effectvalue) / 100, 0.1, false));
				}else if (effecttype == 1) {
					_driver.effector.connect(0, new SiEffectStereoChorus(20, 0.2, 4, 10 + ((50 * effectvalue) / 100)));
				}else if (effecttype == 2) {
					_driver.effector.connect(0, new SiEffectStereoReverb(0.7, 0.4+ ((0.5 * effectvalue) / 100), 0.8, 0.3));
				}else if (effecttype == 3) {
					_driver.effector.connect(0, new SiEffectDistortion(-20 - ((80 * effectvalue) / 100), 18, 2400, 1));
				}else if (effecttype == 4) {
					_driver.effector.connect(0, new SiFilterLowBoost(3000, 1, 4 + ((6 * effectvalue) / 100)));
				}else if (effecttype == 5) {
					_driver.effector.connect(0, new SiEffectCompressor(0.7, 50, 20, 20, -6, 0.2 + ((0.6 * effectvalue) / 100)));
				}else if (effecttype == 6) {
					_driver.effector.connect(0, new SiCtrlFilterHighPass(((1.0 * effectvalue) / 100),0.9));
				}
			}
			
		}
		
		public static function _onTimerInterruption():Void {
			if (musicplaying) {
				if (looptime >= boxcount) {
					looptime-= boxcount;
					SetSwing();
					arrange.currentbar++;
					if (arrange.currentbar >= arrange.loopend) {
						arrange.currentbar = arrange.loopstart;
						if (nowexporting) {
							musicplaying = false;
							savewav();
						}
					}
					
				i = 0;
					while( i < numboxes){
						musicbox[i].isplayed = false;
					 i++;
					}
				}
				
			k = 0;
			while( k < 8){
					if (arrange.channelon[k]) {
						i = arrange.bar[arrange.currentbar].channel[k];
						if (i > -1) {
							musicbox[i].isplayed = true;
							if (instrument[musicbox[i].instr].type == 0) {
							j = 0;
							while( j < musicbox[i].numnotes){
									if (musicbox[i].notes[j].width == looptime) {
										if (musicbox[i].notes[j].x > -1) {
											instrument[musicbox[i].instr].updatefilter();
											
											if (musicbox[i].recordfilter == 1) {
												instrument[musicbox[i].instr].changefilterto(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount], musicbox[i].volumegraph[looptime % boxcount]);
											}
											_driver.noteOn(Std.int (musicbox[i].notes[j].x), instrument[musicbox[i].instr].voice, Std.int(musicbox[i].notes[j].y));
										}	
									}
								 j++;
							}
							}else {
								

							j = 0;
							while( j < musicbox[i].numnotes){
									if (musicbox[i].notes[j].width == looptime) {
										if (musicbox[i].notes[j].x > -1) {
											if (musicbox[i].notes[j].x < drumkit[instrument[musicbox[i].instr].type-1].size) {												
												
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type-1].updatefilter(instrument[musicbox[i].instr].cutoff, instrument[musicbox[i].instr].resonance);
												if (looptime == 0) drumkit[instrument[musicbox[i].instr].type-1].updatevolume(instrument[musicbox[i].instr].volume);
												
												if (musicbox[i].recordfilter == 1) {
													drumkit[instrument[musicbox[i].instr].type-1].updatefilter(musicbox[i].cutoffgraph[looptime % boxcount], musicbox[i].resonancegraph[looptime % boxcount]);
												  drumkit[instrument[musicbox[i].instr].type-1].updatevolume(musicbox[i].volumegraph[looptime % boxcount]);
												}
		
												_driver.noteOn(drumkit[instrument[musicbox[i].instr].type-1].voicenote[Std.int(musicbox[i].notes[j].x)], drumkit[instrument[musicbox[i].instr].type-1].voicelist[Std.int(musicbox[i].notes[j].x)], Std.int(musicbox[i].notes[j].y));
											}
										}	
									}
								 j++;
							}
							}
						}
					}
				 k++;
			}
				
				looptime = looptime + 1;
				SetSwing();
			}
		}
		
		private static function SetSwing():Void{  
      if (_driver == null) return;
      
      
      
      var fswing:Float = 0.2+(swing+10)*(1.8-0.2)/20.0;
      
	 
	  
			if (swing == 0) {
				if (swingoff == 1) {
					 
					_driver.setTimerInterruption(1, _onTimerInterruption);
					swingoff = 0;
				}
			}else {
				swingoff = 1;
				if (looptime%2==0)
				{
					_driver.setTimerInterruption(fswing, _onTimerInterruption);
				}
				else        
				{
					_driver.setTimerInterruption(2-fswing, _onTimerInterruption);
				}
			}
    }
		
		public static function loadscreensettings():Void {
			
			//TODO: port to haxe settings load
			programsettings = SharedObject.getLocal("boscaceoil_settings");		
			
			if (programsettings.data.firstrun == null) {
				Guiclass.firstrun = true;
				programsettings.data.firstrun = 1;
			}else {
				Guiclass.firstrun = false;
			}
			
			if (programsettings.data.fullscreen == 0) {
				fullscreen = false;
			}else {
				fullscreen = true;
			}
			
			if (programsettings.data.scalemode == null) {
				Gfx.changescalemode(0);
			}else{
				Gfx.changescalemode(programsettings.data.scalemode);
			}
			
			if (programsettings.data.windowwidth == null) {
				Gfx.windowwidth = 768;
				Gfx.windowheight = 560;
			}else {
				Gfx.windowwidth = programsettings.data.windowwidth;
				Gfx.windowheight = programsettings.data.windowheight;
			}
			
			Gfx.changewindowsize(Gfx.windowwidth, Gfx.windowheight);
			
			programsettings.flush();
			programsettings.close();
			
		}
		
		public static function savescreensettings():Void {
			
			//TODO: port to haxe settings save
			programsettings = SharedObject.getLocal("boscaceoil_settings");		
			
			programsettings.data.firstrun = 1;
			
			if (!fullscreen){
				programsettings.data.fullscreen = 0;
			}else {
				programsettings.data.fullscreen = 1;
			}
			
			programsettings.data.scalemode = Gfx.scalemode;
			programsettings.data.windowwidth = Gfx.windowwidth;
			programsettings.data.windowheight = Gfx.windowheight;
			
			programsettings.flush();
			programsettings.close();
		}
		
		public static function setbuffersize(t:Int):Void {
			if (t == 0) buffersize = 2048;
			if (t == 1) buffersize = 4096;
			if (t == 2) buffersize = 8192;
			
			/*programsettings = SharedObject.getLocal("boscaceoil_settings");			
			programsettings.data.buffersize = buffersize;
			programsettings.flush();
			programsettings.close();*/
		}
		
		public static function adddrumkitnote(t:Int, name:String, voice:String, note:Int = 60):Void {
			if (t == 2 && note == 60) note = 16;
			drumkit[t].voicelist.push(_presets.voices.get(voice));
			drumkit[t].voicename.push(name);
			drumkit[t].voicenote.push(note);
			
			if (t == 2) {
				//Midi drumkit
				var voicenum:String = "";
				var afterdot:Bool = false;
				for (i in 0...voice.length) {
					if (afterdot) {
						voicenum = voicenum + voice.charAt(i);
					}
					if (i >= 8) afterdot = true;
				}
				drumkit[t].midivoice.push(Std.parseInt(voicenum));
			}
	  
			drumkit[t].size++;
		}
		
		public static function createdrumkit(t:Int):Void {
			
			switch(t) {
				case 0:
					
					drumkit[0].kitname = "Simple Drumkit";
					adddrumkitnote(0, "Bass Drum 1", "valsound.percus1", 30);
					adddrumkitnote(0, "Bass Drum 2", "valsound.percus13", 32);//13
					adddrumkitnote(0, "Bass Drum 3", "valsound.percus3", 30);//3
					adddrumkitnote(0, "Snare Drum", "valsound.percus30", 20);
					adddrumkitnote(0, "Snare Drum 2", "valsound.percus29", 48);
					adddrumkitnote(0, "Open Hi-Hat", "valsound.percus17", 60);
					adddrumkitnote(0, "Closed Hi-Hat", "valsound.percus23", 72);
					adddrumkitnote(0, "Crash Cymbal", "valsound.percus8", 48);

				case 1:
					
					drumkit[1].kitname = "SiON Drumkit";
					adddrumkitnote(1, "Bass Drum 2", "valsound.percus1", 30);
					adddrumkitnote(1, "Bass Drum 3 o1f", "valsound.percus2");
					adddrumkitnote(1, "RUFINA BD o2c", "valsound.percus3", 30);
					adddrumkitnote(1, "B.D.(-vBend)", "valsound.percus4");
					adddrumkitnote(1, "BD808_2(-vBend)", "valsound.percus5");
					adddrumkitnote(1, "Cho cho 3 (o2e)", "valsound.percus6");
					adddrumkitnote(1, "Cow-Bell 1", "valsound.percus7");
					adddrumkitnote(1, "Crash Cymbal (noise)", "valsound.percus8", 48);
					adddrumkitnote(1, "Crash Noise", "valsound.percus9");
					adddrumkitnote(1, "Crash Noise Short", "valsound.percus10");
					adddrumkitnote(1, "ETHNIC Percus.0", "valsound.percus11");
					adddrumkitnote(1, "ETHNIC Percus.1", "valsound.percus12");
					adddrumkitnote(1, "Heavy BD.", "valsound.percus13", 32);
					adddrumkitnote(1, "Heavy BD2", "valsound.percus14");
					adddrumkitnote(1, "Heavy SD1", "valsound.percus15");
					adddrumkitnote(1, "Hi-Hat close 5_", "valsound.percus16");
					adddrumkitnote(1, "Hi-Hat close 4", "valsound.percus17");
					adddrumkitnote(1, "Hi-Hat close 5", "valsound.percus18");
					adddrumkitnote(1, "Hi-Hat Close 6 -808-", "valsound.percus19");
					adddrumkitnote(1, "Hi-hat #7 Metal o3-6", "valsound.percus20");
					adddrumkitnote(1, "Hi-Hat Close #8 o4", "valsound.percus21");
					adddrumkitnote(1, "Hi-hat Open o4e-g+", "valsound.percus22");
					adddrumkitnote(1, "Open-hat2 Metal o4c-", "valsound.percus23");
					adddrumkitnote(1, "Open-hat3 Metal", "valsound.percus24");
					adddrumkitnote(1, "Hi-Hat Open #4 o4f", "valsound.percus25");
					adddrumkitnote(1, "Metal ride o4c or o5c", "valsound.percus26");
					adddrumkitnote(1, "Rim Shot #1 o3c", "valsound.percus27");
					adddrumkitnote(1, "Snare Drum Light", "valsound.percus28");
					adddrumkitnote(1, "Snare Drum Lighter", "valsound.percus29");
					adddrumkitnote(1, "Snare Drum 808 o2-o3", "valsound.percus30", 20);
					adddrumkitnote(1, "Snare4 -808type- o2", "valsound.percus31");
					adddrumkitnote(1, "Snare5 o1-2(Franger)", "valsound.percus32");
					adddrumkitnote(1, "Tom (old)", "valsound.percus33");
					adddrumkitnote(1, "Synth tom 2 algo 3", "valsound.percus34");
					adddrumkitnote(1, "Synth (Noisy) Tom #3", "valsound.percus35");
					adddrumkitnote(1, "Synth Tom #3", "valsound.percus36");
					adddrumkitnote(1, "Synth -DX7- Tom #4", "valsound.percus37");
					adddrumkitnote(1, "Triangle 1 o5c", "valsound.percus38");

				case 2:
					
					drumkit[2].kitname = "Midi Drumkit";
					adddrumkitnote(2, "Seq Click H", "midi.drum24",24);
					adddrumkitnote(2, "Brush Tap", "midi.drum25",25);
					adddrumkitnote(2, "Brush Swirl", "midi.drum26",26);
					adddrumkitnote(2, "Brush Slap", "midi.drum27",27);
					adddrumkitnote(2, "Brush Tap Swirl", "midi.drum28",28);
					adddrumkitnote(2, "Snare Roll", "midi.drum29");
					adddrumkitnote(2, "Castanet", "midi.drum32");
					adddrumkitnote(2, "Snare L", "midi.drum31");
					adddrumkitnote(2, "Sticks", "midi.drum32");
					adddrumkitnote(2, "Bass Drum L", "midi.drum33");
					adddrumkitnote(2, "Open Rim Shot", "midi.drum34");
					adddrumkitnote(2, "Bass Drum M", "midi.drum35");
					adddrumkitnote(2, "Bass Drum H", "midi.drum36");
					adddrumkitnote(2, "Closed Rim Shot", "midi.drum37");
					adddrumkitnote(2, "Snare M", "midi.drum38");
					adddrumkitnote(2, "Hand Clap", "midi.drum39");
					adddrumkitnote(2, "Snare H", "midi.drum42");
					adddrumkitnote(2, "Floor Tom L", "midi.drum41");
					adddrumkitnote(2, "Hi-Hat Closed", "midi.drum42");
					adddrumkitnote(2, "Floor Tom H", "midi.drum43");
					adddrumkitnote(2, "Hi-Hat Pedal", "midi.drum44");
					adddrumkitnote(2, "Low Tom", "midi.drum45");
					adddrumkitnote(2, "Hi-Hat Open", "midi.drum46");
					adddrumkitnote(2, "Mid Tom L", "midi.drum47");
					adddrumkitnote(2, "Mid Tom H", "midi.drum48");
					adddrumkitnote(2, "Crash Cymbal 1", "midi.drum49");
					adddrumkitnote(2, "High Tom", "midi.drum52");
					adddrumkitnote(2, "Ride Cymbal 1", "midi.drum51");
					adddrumkitnote(2, "Chinese Cymbal", "midi.drum52");
					adddrumkitnote(2, "Ride Cymbal Cup", "midi.drum53");
					adddrumkitnote(2, "Tambourine", "midi.drum54");
					adddrumkitnote(2, "Splash Cymbal", "midi.drum55");
					adddrumkitnote(2, "Cowbell", "midi.drum56");
					adddrumkitnote(2, "Crash Cymbal 2", "midi.drum57");
					adddrumkitnote(2, "Vibraslap", "midi.drum58");
					adddrumkitnote(2, "Ride Cymbal 2", "midi.drum59");
					adddrumkitnote(2, "Bongo H", "midi.drum62");
					adddrumkitnote(2, "Bongo L", "midi.drum61");
					adddrumkitnote(2, "Conga H Mute", "midi.drum62");
					adddrumkitnote(2, "Conga H Open", "midi.drum63");
					adddrumkitnote(2, "Conga L", "midi.drum64");
					adddrumkitnote(2, "Timbale H", "midi.drum65");
					adddrumkitnote(2, "Timbale L", "midi.drum66");
					adddrumkitnote(2, "Agogo H", "midi.drum67");
					adddrumkitnote(2, "Agogo L", "midi.drum68");
					adddrumkitnote(2, "Cabasa", "midi.drum69");
					adddrumkitnote(2, "Maracas", "midi.drum72");
					adddrumkitnote(2, "Samba Whistle H", "midi.drum71");
					adddrumkitnote(2, "Samba Whistle L", "midi.drum72");
					adddrumkitnote(2, "Guiro Short", "midi.drum73");
					adddrumkitnote(2, "Guiro Long", "midi.drum74");
					adddrumkitnote(2, "Claves", "midi.drum75");
					adddrumkitnote(2, "Wood Block H", "midi.drum76");
					adddrumkitnote(2, "Wood Block L", "midi.drum77");
					adddrumkitnote(2, "Cuica Mute", "midi.drum78");
					adddrumkitnote(2, "Cuica Open", "midi.drum79");
					adddrumkitnote(2, "Triangle Mute", "midi.drum80");
					adddrumkitnote(2, "Triangle Open", "midi.drum81");
					adddrumkitnote(2, "Shaker", "midi.drum82");
					adddrumkitnote(2, "Jingle Bells", "midi.drum83");
					adddrumkitnote(2, "Bell Tree", "midi.drum84");
			}
		}
		
		public static function changekey(t:Int):Void {
			var keyshift:Int = t - key;
		i = 0;
	while( i < musicbox[currentbox].numnotes){
				musicbox[currentbox].notes[i].x += keyshift;
			 i++;
}
			musicbox[currentbox].key = t;
			key = t;
			musicbox[currentbox].setnotespan();
			updatepianoroll();
		}
		
		public static function changescale(t:Int):Void {
			setscale(t);
			updatepianoroll();
			
			//Delete notes not in scale
			i = 0;
			while( i < musicbox[currentbox].numnotes){
				if (invertpianoroll[Std.int(musicbox[currentbox].notes[i].x)] == -1) {
					musicbox[currentbox].deletenote(i);
					i--;
				}
			 i++;
			}
			
			musicbox[currentbox].scale = t;
			if (musicbox[currentbox].bottomnote < 250) {
				musicbox[currentbox].start = invertpianoroll[musicbox[currentbox].bottomnote] - 2;
				if (musicbox[currentbox].start < 0) musicbox[currentbox].start = 0;
			}else{
			  musicbox[currentbox].start = (scalesize * 4) - 2;
			}
			musicbox[currentbox].setnotespan();
		}
		
		public static  function changemusicbox(t:Int):Void {
			currentbox = t;
			key = musicbox[t].key;
			setscale(musicbox[t].scale);			
			updatepianoroll();
			
			if (instrument[musicbox[t].instr].type == 0) {
				if (musicbox[t].bottomnote < 250) {
					musicbox[t].start = invertpianoroll[musicbox[t].bottomnote] - 2;
					if (musicbox[t].start < 0) musicbox[t].start = 0;
				}else{
					musicbox[t].start = (scalesize * 4) - 2;
				}
			}else {
				musicbox[t].start = 0;
			}
			
			Guiclass.changetab(currenttab);
		}
		
		public static function _setscale(t1:Int = -1, t2:Int = -1, t3:Int = -1, t4:Int = -1, t5:Int = -1, t6:Int = -1,
		                          t7:Int = -1, t8:Int = -1, t9:Int = -1, t10:Int = -1, t11:Int = -1, t12:Int = -1):Void {
		  if (t1 == -1) {
				scalesize = 0;
			}else if (t2 == -1) {
				scale[0] = t1;
				scalesize = 1;
			}else if (t3 == -1) {
				scale[0] = t1; scale[1] = t2;
				scalesize = 2;
			}else if (t4 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3;
				scalesize = 3;
			}else if (t5 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4;
				scalesize = 4;
			}else if (t6 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5;
				scalesize = 5;
			}else if (t7 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scalesize = 6;
			}else if (t8 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; 
				scalesize = 7;
			}else if (t9 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8;
				scalesize = 8;
			}else if (t10 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9;
				scalesize = 9;
			}else if (t11 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9; scale[9] = t10;
				scalesize = 10;
			}else if (t12 == -1) {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9; scale[9] = t10; scale[10] = t11;
				scalesize = 11;
			}else {
				scale[0] = t1; scale[1] = t2; scale[2] = t3; scale[3] = t4; scale[4] = t5; scale[5] = t6;
				scale[6] = t7; scale[7] = t8; scale[8] = t9; scale[9] = t10; scale[10] = t11; scale[11] = t12;
				scalesize = 12;
			}
		}
		
		public static function setscale(t:Int):Void {
			currentscale = t;
			switch(t) {
				case SCALE_MAJOR: _setscale(2, 2, 1, 2, 2, 2, 1); 
				case SCALE_MINOR: _setscale(2, 1, 2, 2, 2, 2, 1); 
				case SCALE_BLUES: _setscale(3, 2, 1, 1, 3, 2); 
				case SCALE_HARMONIC_MINOR: _setscale(2, 1, 2, 2, 1, 3, 1); 
				case SCALE_PENTATONIC_MAJOR: _setscale(2, 3, 2, 2, 3); 
				case SCALE_PENTATONIC_MINOR: _setscale(3, 2, 2, 3, 2); 
				case SCALE_PENTATONIC_BLUES: _setscale(3, 2, 1, 1, 3, 2);
				case SCALE_PENTATONIC_NEUTRAL: _setscale(2, 3, 2, 3, 2); 
				case SCALE_ROMANIAN_FOLK: _setscale(2, 1, 3, 1, 2, 1, 2); 
				case SCALE_SPANISH_GYPSY: _setscale(2, 1, 3, 1, 2, 1, 2); 
				case SCALE_ARABIC_MAGAM: _setscale(2, 2, 1, 1, 2, 2, 2); 
				case SCALE_CHINESE: _setscale(4, 2, 1, 4, 1); 
				case SCALE_HUNGARIAN: _setscale(2, 1, 3, 1, 1, 3, 1); 
				case CHORD_MAJOR: _setscale(4, 3, 5); 
				case CHORD_MINOR: _setscale(3, 4, 5); 
				case CHORD_5TH: _setscale(7, 5);
				case CHORD_DOM_7TH: _setscale(4, 3, 3, 2); 
				case CHORD_MAJOR_7TH: _setscale(4, 3, 4, 1); 
				case CHORD_MINOR_7TH: _setscale(3, 4, 3, 2); 
				case CHORD_MINOR_MAJOR_7TH: _setscale(3, 4, 4, 1); 
				case CHORD_SUS4: _setscale(5, 2, 5); 
				case CHORD_SUS2: _setscale(2, 5, 5); 
				case SCALE_NORMAL:_setscale(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);	
				default: _setscale(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);	
			}
		}
		
		public static function updatepianoroll():Void {
			
			var scaleiter:Int = -1, pianorolliter:Int = 0, lastnote:Int = 0;
			
			lastnote = key;
			pianorollsize = 0;
			
			while (lastnote < 104){
				pianoroll[pianorolliter] = lastnote;
				pianorollsize++;
				pianorolliter++; scaleiter++;
				if (scaleiter >= scalesize) scaleiter -= scalesize;
				
				lastnote = pianoroll[pianorolliter - 1] + scale[scaleiter];
			}
			
		i = 0;
			while ( i < 104) {
				invertpianoroll[i] = -1;
				j = 0;
				while( j < pianorollsize){
					if (pianoroll[j] == i) {
						invertpianoroll[i] = j;
					}
				 j++;
				}
				 i++;
			}
		}
		
		public static function addmusicbox():Void {
			musicbox[numboxes].clear();
			musicbox[numboxes].instr = currentinstrument;
			musicbox[numboxes].palette = instrument[currentinstrument].palette;
			musicbox[numboxes].hash += currentinstrument;
			numboxes++;
		}
		
		public static function copymusicbox(a:Int, b:Int):Void {
		  musicbox[a].numnotes = musicbox[b].numnotes;
			
		 j = 0;
 while( j < musicbox[a].numnotes){
			  musicbox[a].notes[j].x = musicbox[b].notes[j].x;
				musicbox[a].notes[j].y = musicbox[b].notes[j].y;
				musicbox[a].notes[j].width = musicbox[b].notes[j].width;
				musicbox[a].notes[j].height = musicbox[b].notes[j].height;
			 j++;
}
			
		j = 0;
	while( j < 16){
			  musicbox[a].cutoffgraph[j] = musicbox[b].cutoffgraph[j];
				musicbox[a].resonancegraph[j] = musicbox[b].resonancegraph[j];
				musicbox[a].volumegraph[j] = musicbox[b].volumegraph[j];
			 j++;
}
			
		  musicbox[a].recordfilter = musicbox[b].recordfilter;
		  musicbox[a].topnote = musicbox[b].topnote;
			musicbox[a].bottomnote = musicbox[b].bottomnote;
			musicbox[a].notespan = musicbox[b].notespan;
			
		  musicbox[a].start = musicbox[b].start;
		  musicbox[a].key = musicbox[b].key;
		  musicbox[a].instr = musicbox[b].instr;
		  musicbox[a].palette = musicbox[b].palette;
		  musicbox[a].scale = musicbox[b].scale;
		  musicbox[a].isplayed = musicbox[b].isplayed;
		}
		
		public static function deletemusicbox(t:Int):Void {
			if (currentbox == t) currentbox--;
		i = t;
	while( i < numboxes){
				copymusicbox(i, i + 1);
			 i++;
}
			numboxes--;
			
		j = 0;
	while( j < 8){
			i = 0;
	while( i < arrange.lastbar){
					if (arrange.bar[i].channel[j] == t) {
						arrange.bar[i].channel[j] = -1;
					}else if (arrange.bar[i].channel[j] > t) {
						arrange.bar[i].channel[j]--;
					}
				 i++;
}
			 j++;
}
		}
		
		
		public static function seekposition(t:Int):Void {
			
		  barposition = t;
		}
		
		public static function filllist(t:Int):Void {
			list.type = t;
			switch(t) {
				case LIST_KEY:
				i = 0;
	while( i < 12){
						list.item[i] = notename[i];
					 i++;
}
					list.numitems = 12;
		
				case LIST_SCALE:
				i = 0;
	while( i < 23){
						list.item[i] = scalename[i];
					 i++;
}
					list.numitems = 23;
			
			  case LIST_CATEGORY:
					list.item[0] = "MIDI";
					list.item[1] = "DRUMKIT";
					list.item[2] = "CHIPTUNE";
					list.item[3] = "PIANO";
					list.item[4] = "BRASS";
					list.item[5] = "BASS";
					list.item[6] = "STRINGS";
					list.item[7] = "WIND";
					list.item[8] = "BELL";
					list.item[9] = "GUITAR";
					list.item[10] = "LEAD";
					list.item[11] = "SPECIAL";
					list.item[12] = "WORLD";
					list.numitems = 13;
	
			  case LIST_INSTRUMENT:
				  if (voicelist.sublistsize > 15) {
						
						
						if ((voicelist.pagenum * 15) > voicelist.sublistsize) voicelist.pagenum = 0;
						if (voicelist.sublistsize - (voicelist.pagenum * 15) > 15) {
						i = 0;
	while( i < 15){
								list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
							 i++ ;
}
							list.item[15] = ">> Next Page";
							list.numitems = 16;
						}else{
						i = 0;
	while( i < voicelist.sublistsize - (voicelist.pagenum * 15)){
								list.item[i] = voicelist.subname[(voicelist.pagenum * 15) + i];
							 i++ ;
}
							list.item[voicelist.sublistsize - (voicelist.pagenum * 15)] = "<< First Page";
							list.numitems = voicelist.sublistsize - (voicelist.pagenum * 15)+1;
						}
					}else {
						
					i = 0;
	while( i < voicelist.sublistsize){
							list.item[i] = voicelist.subname[i];
						 i++ ;
}
						list.numitems = voicelist.sublistsize;
					}
					
			  case LIST_MIDIINSTRUMENT:
					midilistselection = -1;
					list.item[0] = "> Piano";
					list.item[1] = "> Bells";
					list.item[2] = "> Organ";
					list.item[3] = "> Guitar";
					list.item[4] = "> Bass";
					list.item[5] = "> Strings";
					list.item[6] = "> Ensemble";
					list.item[7] = "> Brass";
					list.item[8] = "> Reed";
					list.item[9] = "> Pipe";
					list.item[10] = "> Lead";
					list.item[11] = "> Pads";
					list.item[12] = "> Synth";
					list.item[13] = "> World";
					list.item[14] = "> Drums";
					list.item[15] = "> Effects";
					list.numitems = 16;
				  
		
			  case LIST_SELECTINSTRUMENT:
				  
				i = 0;
	while( i < numinstrument){
						list.item[i] = Std.string(i + 1) + " " +instrument[i].name;
					 i++ ;
}
					list.numitems = numinstrument;
	
				case LIST_BUFFERSIZE:
					list.item[0] = "2048 (default, high performance)";
					list.item[1] = "4096 (try if you cracking on wav exports)";
					list.item[2] = "8192 (slow, not recommended)";
					list.numitems = 3;
		
			  case LIST_EFFECTS:
				 i = 0;
				 while( i < 7){
					list.item[i] = effectname[i];
					 i++;
				}
					list.numitems = 7;
			  case LIST_MOREEXPORTS:
				  list.item[0] = "EXPORT .xm (wip)";
					list.item[1] = "EXPORT .mml (wip)";
					list.numitems = 2;
				case LIST_EXPORTS:
					list.item[0] = "EXPORT .wav";
					list.item[1] = "EXPORT .mid";
					list.item[2] = "> More";
					list.numitems = 3;
				default:
					//Midi list
					list.type = LIST_MIDIINSTRUMENT;
					secondlist.type = t;
					for (i in 0...8) {
						secondlist.item[i] = voicelist.name[i + ((t - 10) * 8)];
					}
					secondlist.numitems = 8;

			}
		}
		
		public static function setinstrumenttoindex(t:Int):Void {
			voicelist.index = instrument[t].index;
	
			if (voicelist.voice[voicelist.index].substr(0,7) == "drumkit") {
			  instrument[t].type = Std.parseInt(voicelist.voice[voicelist.index].charAt(voicelist.voice[voicelist.index].length - 1));
				instrument[t].updatefilter();
				drumkit[instrument[t].type-1].updatefilter(instrument[t].cutoff, instrument[t].resonance);
			}else {
				instrument[t].type = 0;
				instrument[t].voice = _presets.voices.get(voicelist.voice[voicelist.index]);
				instrument[t].updatefilter();
			}
			
			instrument[t].name = voicelist.name[voicelist.index];
			instrument[t].category = voicelist.category[voicelist.index];
			instrument[t].palette = voicelist.palette[voicelist.index];
		}
		
		public static function nextinstrument():Void {
			//Change to the next instrument in a category
			voicelist.index = voicelist.getnext(voicelist.getvoice(instrument[currentinstrument].name));
			changeinstrumentvoice(voicelist.name[voicelist.index]);
		}
		
		public static function previousinstrument():Void {
			//Change to the previous instrument in a category
			voicelist.index = voicelist.getprevious(voicelist.getvoice(instrument[currentinstrument].name));
			changeinstrumentvoice(voicelist.name[voicelist.index]);
		}
		
		public static function changeinstrumentvoice(t:String):Void {
			instrument[currentinstrument].name = t;
			voicelist.index = voicelist.getvoice(t);
			instrument[currentinstrument].category = voicelist.category[voicelist.index];
			
			if (voicelist.voice[voicelist.index].substr(0,7) == "drumkit") {
			  instrument[currentinstrument].type = Std.parseInt(voicelist.voice[voicelist.index].charAt(voicelist.voice[voicelist.index].length - 1));
				instrument[currentinstrument].updatefilter();
				drumkit[instrument[currentinstrument].type-1].updatefilter(instrument[currentinstrument].cutoff, instrument[currentinstrument].resonance);
				
				if (currentbox > -1) {
				  if (musicbox[currentbox].start > drumkit[instrument[currentinstrument].type-1].size) {
						musicbox[currentbox].start = 0;
					}
				}
			}else {
				instrument[currentinstrument].type = 0;
				instrument[currentinstrument].voice = _presets.voices.get(voicelist.voice[voicelist.index]);
				instrument[currentinstrument].updatefilter();
			}
			
			instrument[currentinstrument].palette = voicelist.palette[voicelist.index];
			instrument[currentinstrument].index = voicelist.index;
				
		i = 0;
	while( i < numboxes){
				if (musicbox[i].instr == currentinstrument) {
					musicbox[i].palette = instrument[currentinstrument].palette;
				}
			 i++;
}
		}
		
		public static function makefilestring():Void {
			filestring = "";
			filestring += Std.string(version) + ",";
			filestring += Std.string(swing)+",";
			filestring += Std.string(effecttype) + ",";
			filestring += Std.string(effectvalue) + ",";
			filestring += Std.string(bpm) + ",";
			filestring += Std.string(boxcount) + ",";
			filestring += Std.string(barcount) + ",";
			
			filestring += Std.string(numinstrument) + ",";
		i = 0;
	while( i < numinstrument){
				filestring += Std.string(instrument[i].index) + ",";
				filestring += Std.string(instrument[i].type) + ",";
				filestring += Std.string(instrument[i].palette) + ",";
				filestring += Std.string(instrument[i].cutoff) + ",";
				filestring += Std.string(instrument[i].resonance) + ",";
				filestring += Std.string(instrument[i].volume) + ",";
			 i++;
}
			
			filestring += Std.string(numboxes) + ",";
		i = 0;
	while( i < numboxes){
			  filestring += Std.string(musicbox[i].key) + ",";
				filestring += Std.string(musicbox[i].scale) + ",";
				filestring += Std.string(musicbox[i].instr) + ",";
				filestring += Std.string(musicbox[i].palette) + ",";
			  filestring += Std.string(musicbox[i].numnotes) + ",";
			j = 0;
	while( j < musicbox[i].numnotes){
				  filestring += Std.string(musicbox[i].notes[j].x) + ",";	
				  filestring += Std.string(musicbox[i].notes[j].y) + ",";	
				  filestring += Std.string(musicbox[i].notes[j].width) + ",";	
				  filestring += Std.string(musicbox[i].notes[j].height) + ",";	
				 j++;
}
				filestring += Std.string(musicbox[i].recordfilter) + ",";
				if (musicbox[i].recordfilter == 1) {
				j = 0;
	while( j < 32){
				    filestring += Std.string(musicbox[i].volumegraph[j]) + ",";
				    filestring += Std.string(musicbox[i].cutoffgraph[j]) + ",";
				    filestring += Std.string(musicbox[i].resonancegraph[j]) + ",";
					 j++;
}
				}
			 i++;
}
			
			filestring += Std.string(arrange.lastbar) + ",";
			filestring += Std.string(arrange.loopstart) + ",";
			filestring += Std.string(arrange.loopend) + ",";
		i = 0;
	while( i < arrange.lastbar){
			j = 0;
	while( j < 8){
			    filestring += Std.string(arrange.bar[i].channel[j]) + ",";
				 j++;
}
			 i++;
}
		}
		
		public static function newsong():Void {
			changetab(MENUTAB_FILE);
			bpm = 120; boxcount = 16; barcount = 4; doublesize = false;
			effectvalue = 0; effecttype = 0; updateeffects();
			_driver.bpm = bpm;
			arrange.clear();
			musicbox[0].clear();
			changekey(0); changescale(0);
			arrange.bar[0].channel[0] = 0;
			numboxes = 1; currentbox = 0;
			numinstrument = 1;
			instrumentmanagerview = 0;
			patternmanagerview = 0;
			
			//set instrument to grand piano
			instrument[0] = new Instrumentclass();
			instrument[0].voice = _presets.voices["midi.piano1"];
			instrument[0].updatefilter();
			
			
			showmessage("NEW SONG CREATED");
		}
		
		public static function readfilestream():Int {
			fi++;
			return filestream[fi-1];
		}
		
		public static function convertfilestring():Void {
			fi = 0;
			version = readfilestream();
			if (version == 3) {
				swing = readfilestream();
				effecttype = readfilestream();
				effectvalue = readfilestream(); updateeffects();
				bpm = readfilestream();	
				_driver.bpm = bpm;
				boxcount = readfilestream(); doublesize = boxcount > 16;
				barcount = readfilestream();
				numinstrument = readfilestream();
			i = 0;
	while( i < numinstrument){
					instrument[i].index = readfilestream();
					setinstrumenttoindex(i);
					instrument[i].type = readfilestream();
					instrument[i].palette = readfilestream();
					instrument[i].cutoff = readfilestream();
					instrument[i].resonance = readfilestream();
					instrument[i].volume = readfilestream();
					instrument[i].updatefilter();
					if(instrument[i].type>0){
						drumkit[instrument[i].type-1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						drumkit[instrument[i].type-1].updatevolume(instrument[i].volume);
					}
				 i++;
}
				
				numboxes = readfilestream();
			i = 0;
	while( i < numboxes){
					musicbox[i].key = readfilestream();
					musicbox[i].scale = readfilestream();
					musicbox[i].instr = readfilestream();
					musicbox[i].palette = readfilestream();
					musicbox[i].numnotes = readfilestream();
				j = 0;
	while( j < musicbox[i].numnotes){
						musicbox[i].notes[j].x = readfilestream();
						musicbox[i].notes[j].y = readfilestream();
						musicbox[i].notes[j].width = readfilestream();
						musicbox[i].notes[j].height = readfilestream();
					 j++;
}
					musicbox[i].findtopnote(); musicbox[i].findbottomnote(); 
					musicbox[i].notespan = musicbox[i].topnote-musicbox[i].bottomnote;
					musicbox[i].recordfilter = readfilestream();
					if (musicbox[i].recordfilter == 1) {
					j = 0;
	while( j < 32){
							musicbox[i].volumegraph[j] = readfilestream();
							musicbox[i].cutoffgraph[j] = readfilestream();
							musicbox[i].resonancegraph[j] = readfilestream();
						 j++;
}
					}
				 i++;
}
				
				arrange.lastbar = readfilestream();
				arrange.loopstart = readfilestream();
				arrange.loopend = readfilestream();
			i = 0;
	while( i < arrange.lastbar){
				j = 0;
	while( j < 8){
						arrange.bar[i].channel[j] = readfilestream();
					 j++;
}
				 i++;
}
			}else {
				
				legacy_convertfilestring(version);
				version = 3;
			}
		}
		
		public static function legacy_convertfilestring(t:Int):Void {
			switch(t) {
				case 2: 
					swing = readfilestream();
					effecttype = 0; effectvalue = 0;
					bpm = readfilestream();	
					_driver.bpm = bpm;
					boxcount = readfilestream(); doublesize = boxcount > 16;
					barcount = readfilestream();
					numinstrument = readfilestream();
				i = 0;
	while( i < numinstrument){
						instrument[i].index = readfilestream();
						setinstrumenttoindex(i);
						instrument[i].type = readfilestream();
						instrument[i].palette= readfilestream();
						instrument[i].cutoff= readfilestream();
						instrument[i].resonance = readfilestream();
						instrument[i].volume = readfilestream();
						instrument[i].updatefilter();
						if(instrument[i].type>0){
							drumkit[instrument[i].type-1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
							drumkit[instrument[i].type-1].updatevolume(instrument[i].volume);
						}
					 i++;
}
					
					numboxes = readfilestream();
				i = 0;
	while( i < numboxes){
						musicbox[i].key = readfilestream();
						musicbox[i].scale = readfilestream();
						musicbox[i].instr = readfilestream();
						musicbox[i].palette = readfilestream();
						musicbox[i].numnotes = readfilestream();
					j = 0;
	while( j < musicbox[i].numnotes){
							musicbox[i].notes[j].x = readfilestream();
							musicbox[i].notes[j].y = readfilestream();
							musicbox[i].notes[j].width = readfilestream();
							musicbox[i].notes[j].height = readfilestream();
						 j++;
}
						musicbox[i].findtopnote(); musicbox[i].findbottomnote(); 
						musicbox[i].notespan = musicbox[i].topnote-musicbox[i].bottomnote;
						musicbox[i].recordfilter = readfilestream();
						if (musicbox[i].recordfilter == 1) {
						j = 0;
	while( j < 16){
								musicbox[i].volumegraph[j] = readfilestream();
								musicbox[i].cutoffgraph[j] = readfilestream();
								musicbox[i].resonancegraph[j] = readfilestream();
							 j++;
}
						}
					 i++;
}
					
					arrange.lastbar = readfilestream();
					arrange.loopstart = readfilestream();
					arrange.loopend = readfilestream();
				i = 0;
	while( i < arrange.lastbar){
					j = 0;
	while( j < 8){
							arrange.bar[i].channel[j] = readfilestream();
						 j++;
}
					 i++;
}
			
				case 1: 
					bpm = readfilestream();	
					_driver.bpm = bpm; 
					swing = 0; effecttype = 0; effectvalue = 0;
					boxcount = readfilestream(); doublesize = boxcount > 16;
					barcount = readfilestream();
					numinstrument = readfilestream();
				i = 0;
	while( i < numinstrument){
						instrument[i].index = readfilestream();
						setinstrumenttoindex(i);
						instrument[i].type = readfilestream();
						instrument[i].palette= readfilestream();
						instrument[i].cutoff= readfilestream();
						instrument[i].resonance = readfilestream();
						instrument[i].updatefilter();
						if(instrument[i].type>0){
							drumkit[instrument[i].type-1].updatefilter(instrument[i].cutoff, instrument[i].resonance);
						}
					 i++;
}
					
					numboxes = readfilestream();
				i = 0;
	while( i < numboxes){
						musicbox[i].key = readfilestream();
						musicbox[i].scale = readfilestream();
						musicbox[i].instr = readfilestream();
						musicbox[i].palette = readfilestream();
						musicbox[i].numnotes = readfilestream();
					j = 0;
	while( j < musicbox[i].numnotes){
							musicbox[i].notes[j].x = readfilestream();
							musicbox[i].notes[j].y = readfilestream();
							musicbox[i].notes[j].width = readfilestream();
							musicbox[i].notes[j].height = readfilestream();
						 j++;
}
						musicbox[i].findtopnote(); musicbox[i].findbottomnote(); 
						musicbox[i].notespan = musicbox[i].topnote-musicbox[i].bottomnote;
						musicbox[i].recordfilter = readfilestream();
						if (musicbox[i].recordfilter == 1) {
						j = 0;
	while( j < 16){
								musicbox[i].volumegraph[j] = readfilestream();
								musicbox[i].cutoffgraph[j] = readfilestream();
								musicbox[i].resonancegraph[j] = readfilestream();
							 j++;
}
						}
					 i++;
}
					
					arrange.lastbar = readfilestream();
					arrange.loopstart = readfilestream();
					arrange.loopend = readfilestream();
				i = 0;
	while( i < arrange.lastbar){
					j = 0;
	while( j < 8){
							arrange.bar[i].channel[j] = readfilestream();
						 j++;
}
					 i++;
}
		
			}
		}
		
		public static function fileHasExtension(filename:String, extension:String):Bool {

			if (!StringTools.endsWith(filename, "."+extension)) {         
				return false;     
			}                 
			return true; 
		}
		
		public static function addExtensionToFile(filename:String, extension:String):String {     
			return filename + "." + extension;
		}
		
		public static function saveceol():Void {
		
			#if cpp
				#if (!android && !emscripten)
				var filename:String = Dialogs.saveFile("Save .ceol File", "Save .ceol File", Sys.getCwd(), ceolFilter);
				
				if(StringTools.trim(filename) != "")
					onsaveceol(filename);
				
				fixmouseclicks = true;
				#end
			#end
		}
		
		private static function onsaveceol(filename:String):Void {    
						
			if (!fileHasExtension(filename, "ceol")) {
				filename = addExtensionToFile(filename, "ceol");
			}
			
			makefilestring();
			
			#if cpp
			var fo:FileOutput =  File.write(filename,false);
			
			fo.writeString(filestring);
			fo.close();
			#end
			
			fixmouseclicks = true;
			showmessage("SONG SAVED");
		}
		
		public static function loadceol():Void {
			#if cpp
				#if (!android && !emscripten)
				
				var result:Array<String> = Dialogs.openFile(
				"Load .ceol File"
				, "Load .ceol File"
				, ceolFilter
				);	

				if (result != null && result.length != 0)
					onloadceol(result);
				
				fixmouseclicks = true;
				#end
			#end
		}
		

		private static function onloadceol(arr:Array<String>):Void {  
			if (arr != null && arr.length > 0)
			{
				#if cpp
					var str_ceol:String = File.getContent(arr[0]);
				#else
					var str_ceol:String = "";
				#end
				
				loadfilestring(str_ceol);
				
				_driver.play(null, false);
				
				fixmouseclicks = true;
				showmessage("SONG LOADED");
			}
			
		}
		
		private function onreadceolcomplete(result:String):Void
		{
			filestream = new Array<Dynamic>();
			filestream = result.split(",");
			
			
			//stop playing sound before loading new level
			if (musicplaying)
			{
				musicplaying = false;
				looptime = 0;
				notecut();
			}
			
			
			numinstrument = 1;
			numboxes = 0;
			arrange.clear();
			arrange.currentbar = 0; arrange.viewstart = 0;
			
			convertfilestring();
			
			changemusicbox(0);
			looptime = 0;
			
			
		}
		
		public static function exportxm():Void {
			stopmusic();
			
			#if cpp
				#if (!android && !emscripten)
				
				var result:String = Dialogs.saveFile(
				"Export XM module file"
				, "Export XM module file",Sys.getCwd()
				, xmFilter
				);	
				

				if (result != null && result.length != 0)
					onexportxm(result);
				
				fixmouseclicks = true;
				#end
			#end
			
			
			fixmouseclicks = true;
		}

		private static function onexportxm(filename:String):Void {

			if (!fileHasExtension(filename, "xm")) {
				addExtensionToFile(filename, "xm");
			}

			var xm:TrackerModuleXM = new TrackerModuleXM();
			xm.loadFromLiveBoscaCeoilModel(filename);
			
			#if cpp
			var fo:FileOutput = File.write(filename);
			
			xm.writeToStream(fo);
			
			fo.close();
			#end

			fixmouseclicks = true;
			showmessage("SONG EXPORTED AS XM");
		}

		public static function exportmml():Void {
			stopmusic();
			
			#if cpp
				#if (!android && !emscripten)
				
				var result:String = Dialogs.saveFile(
				"Export MML music text"
				, "Export MML music text",Sys.getCwd()
				, mmlFilter
				);	
				

				if (result != null && result.length != 0)
					onexportmml(result);
				
				fixmouseclicks = true;
				#end
			#end

			fixmouseclicks = true;
		}

		private static function onexportmml(filename:String):Void {

			if (!fileHasExtension(filename, "mml")) {
				addExtensionToFile(filename, "mml");
			}

			var song:MMLSong = new MMLSong();
			song.loadFromLiveBoscaCeoilModel();
			
			#if cpp
			var fo:FileOutput = File.write(filename);
			
			song.writeToStream(fo);
			
			fo.close();
			#end

			fixmouseclicks = true;
			showmessage("SONG EXPORTED AS MML");
		}
		
		
		private static function loadfilestring(s:String):Void {
			filestream = new Array<Dynamic>();
			filestream = s.split(",");

			numinstrument = 1;
			numboxes = 0;
			arrange.clear();
			arrange.currentbar = 0; arrange.viewstart = 0;
			
			convertfilestring();
			
			changemusicbox(0);
			looptime = 0;
		}
		
		
		public static function showmessage(t:String):Void {
			message = t;
			messagedelay = 90;
		}
		
		public static function onStream(e : SiONEvent) : Void {
			e.streamBuffer.position = 0;
			while(e.streamBuffer.bytesAvailable > 0){
				var d : Int = Std.int( e.streamBuffer.readFloat() * 32767);
				if (nowexporting) _data.writeShort(d);
			}
		}
		
		public static function pausemusic():Void {
			if (musicplaying) {
				musicplaying = !musicplaying;
				if (!musicplaying) notecut();
			}
		}
		
		public static function stopmusic():Void {
			if (musicplaying) {
				musicplaying = !musicplaying;
				looptime = 0;
				arrange.currentbar = arrange.loopstart;
				if (!musicplaying) notecut();
			}
		}
		
		public static function startmusic():Void {
			if (!musicplaying) {
				musicplaying = !musicplaying;
			}
		}
		
		
		
		public static function exportwav():Void {
			changetab(MENUTAB_ARRANGEMENTS); clicklist = true;
			arrange.loopstart = 0; arrange.loopend = arrange.lastbar;
			musicplaying = true;
			looptime = 0;	arrange.currentbar = arrange.loopstart;
			SetSwing();
			
			
			_data = new ByteArray();
			_data.endian = Endian.LITTLE_ENDIAN;
			
			followmode = true;
			nowexporting = true;
		}
		
		public static function savewav():Void {
			nowexporting = false; followmode = false;
			
			_wav = new ByteArray();
			_wav.endian = Endian.LITTLE_ENDIAN;
			_wav.writeUTFBytes("RIFF");
			var len : Int = _data.length;
			_wav.writeInt(len + 36);
			_wav.writeUTFBytes("WAVE");
			_wav.writeUTFBytes("fmt ");
			_wav.writeInt(16);
			_wav.writeShort(1);
			_wav.writeShort(2);
			_wav.writeInt(44100);
			_wav.writeInt(176400);
			_wav.writeShort(4);
			_wav.writeShort(16);
			_wav.writeUTFBytes("data");
			_wav.writeInt(len);
			_data.position = 0;
			_wav.writeBytes(_data);
			
			#if cpp
				#if (!android && !emscripten)
				
				var filechoose = false;
				var result:String = "";
				
				while (!filechoose)
				{
					result = Dialogs.saveFile("Export .wav File", "Export .wav File", Sys.getCwd(), wavFilter);
					
					if (FileSystem.exists(result))
					{
						
						var lastpos = result.lastIndexOf("\\");
						
						if (lastpos == -1)
							lastpos = result.lastIndexOf("/");
						
						var filename = result.substring(lastpos+1, result.length);
						
						if (Dialogs.confirm("File already exist", filename+" already exist, replace it?",false))
						{
							try
							{
								FileSystem.deleteFile(result);
								filechoose = true;
							}
							catch (e:Dynamic)
							{
								Dialogs.message("File in use!","Can't overwrite " + filename+", please choose another export destination",true);
							}
							
						}
					}
					else
					{
						filechoose = true;
					}
				}
				
				
				onsavewav(result);
				#end
			#end
			
			
			fixmouseclicks = true;
		}
		
		private static function onsavewav(filename:String):Void {    
			
			if (!fileHasExtension(filename, "wav")) {
				filename = addExtensionToFile(filename, "wav");
			}
			#if cpp
			var fo:FileOutput = File.write(filename);
			
			var iwav:Int = 0;
			
			while (iwav < _wav.byteLength)
			{
				fo.writeByte(_wav.get(iwav));
				iwav++;
			}
			
			fo.close();
			#end
			
			fixmouseclicks = true;
			showmessage("SONG EXPORTED AS WAV");
		}
		
		
		public static function changetab(newtab:Int):Void {
			currenttab = newtab;
			Guiclass.changetab(newtab);
		}
		
		public static function changetab_ifdifferent(newtab:Int):Void {
			if(currenttab!=newtab){
				currenttab = newtab;
				Guiclass.changetab(newtab);
			}
		}
		
		//public var file:FileInput;
		public static var filestring:String;
		public static var fi:Int;
		public static var filestream:Array<Dynamic>;
		
		#if cpp
			#if (!android && !emscripten)
		private static var ceolFilter: FILEFILTERS =
					{ count: 1
					, descriptions: ["Ceol files"]
					, extensions: ["*.ceol"]	
					};	
					
		private static var wavFilter:FILEFILTERS = 
				{
					count: 1,
					descriptions: ["Wav file"],
					extensions: ["*.wav"]
				};
				
		private static var xmFilter:FILEFILTERS = 
				{
					count: 1,
					descriptions: ["XM file"],
					extensions: ["*.xm"]
				};
				
		private static var mmlFilter:FILEFILTERS = 
				{
					count: 1,
					descriptions: ["MML file"],
					extensions: ["*.mml"]
				};
			#end
		#end
		
		
		public static var i:Int;
		public static var j:Int;
		public static var k:Int;
		
		public static var fullscreen:Bool;
		
		public static var fullscreentoggleheld:Bool = false;
		
		public static var press_up:Bool;
		public static var press_down:Bool;
		public static var press_left:Bool;
		public static var press_right:Bool;
		public static var press_space:Bool;
		public static var press_enter:Bool;
		public static var keypriority:Int = 0;
		public static var keyheld:Bool = false;
		public static var clicklist:Bool;
		public static var clicksecondlist:Bool;
		public static var copykeyheld:Bool = false;
		
		public static var keydelay:Int;
		public static var keyboardpressed:Int = 0;
		public static var fixmouseclicks:Bool = false;
		
		public static var mx:Int;
		public static var my:Int;
		public static var test:Bool;
		public static var teststring:String;
		
		public static var _driver:SiONDriver;
		public static var _presets:SiONPresetVoice;
		public static var voicelist:Voicelistclass;
		
		public static var instrument: Array<Instrumentclass> = new Array<Instrumentclass>();
		public static var numinstrument:Int;
		public static var instrumentmanagerview:Int;
		
		public static var musicbox: Array<Musicphraseclass> = new Array<Musicphraseclass>();
		public static var numboxes:Int;
		public static var looptime:Int;
		public static var currentbox:Int;
		public static var currentnote:Int;
		public static var currentinstrument:Int;
		public static var boxsize:Int;
		public static var boxcount:Int;
		public static var barsize:Int;
		public static var barcount:Int;
		public static var notelength:Int;
		public static var doublesize:Bool;
		public static var arrangescrolldelay:Int = 0;
		
		public static var barposition:Float = 0;
		public static var drawnoteposition:Int;
		public static var drawnotelength:Int;
		
		public static var cursorx:Int;
		public static var cursory:Int;
		public static var arrangecurx:Int;
		public static var arrangecury:Int;
		public static var patterncury:Int;
		public static var timelinecurx:Int;
		public static var instrumentcury:Int;
		public static var notey:Int;
		
		public static var notename: Array<String> = new Array<String>();
		public static var scalename: Array<String> = new Array<String>();
		
		public static var currentscale:Int = 0;
		public static var scale: Array<Int> = new Array<Int>();
		public static var key:Int;
		public static var scalesize:Int;
		
		public static var pianoroll: Array<Int> = new Array<Int>();
		public static var invertpianoroll: Array<Int> = new Array<Int>();
		public static var pianorollsize:Int;
		
		public static var arrange:Arrangementclass = new Arrangementclass();
		public static var drumkit: Array<Drumkitclass> = new Array<Drumkitclass>();
		
		public static var currenttab:Int;
		
		public static var dragaction:Int;
		public static var dragx:Int;
		public static var dragy:Int;
		public static var dragpattern:Int;
		public static var patternmanagerview:Int;
		
		public static var trashbutton:Int;
		
		public static var list:Listclass = new Listclass();
		public static var secondlist:Listclass = new Listclass();
		public static var midilistselection:Int;
		
		public static var musicplaying:Bool = true;
		public static var nowexporting:Bool = false;
		public static var followmode:Bool = false;
		public static var bpm:Int;
		public static var version:Int;
		public static var swing:Int;
		public static var swingoff:Int;
		
		public static var doubleclickcheck:Int;
		
		public static var programsettings:SharedObject;
		public static var buffersize:Int;
		public static var currentbuffersize:Int;
		
		private static var _data:ByteArray;
		private static var _wav:ByteArray;
		
		public static var message:String;
		public static var messagedelay:Int = 0;
		public static var startup:Int = 0;
		public static var invokefile:String = "null";
		public static var ctrl:String;
		
		
		public static var effecttype:Int;
		public static var effectvalue:Int;
		public static var effectname: Array<String> = new Array<String>();
		
		public static var versionnumber:String;
		public static var savescreencountdown:Int;
		public static var minresizecountdown:Int;
		public static var forceresize:Bool = false;
	}
