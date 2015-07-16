
CONFIG::desktop {
package ;
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
	import flash.utils.*;
  import flash.net.*;
	import flash.filesystem.*;
	import org.si.sion.midi.*;
	import org.si.sion.events.*;
	
	class Midicontrol {
		public static var MIDIDRUM_35_Acoustic_Bass_Drum:Int = 35;
		public static var MIDIDRUM_36_Bass_Drum_1:Int = 36;
		public static var MIDIDRUM_37_Side_Stick:Int = 37;
		public static var MIDIDRUM_38_Acoustic_Snare:Int = 38;
		public static var MIDIDRUM_39_Hand_Clap:Int = 39;
		public static var MIDIDRUM_40_Electric_Snare:Int = 40;
		public static var MIDIDRUM_41_Low_Floor_Tom:Int = 41;
		public static var MIDIDRUM_42_Closed_Hi_Hat:Int = 42;
		public static var MIDIDRUM_43_High_Floor_Tom:Int = 43;
		public static var MIDIDRUM_44_Pedal_Hi_Hat:Int = 44;
		public static var MIDIDRUM_45_Low_Tom:Int = 45;
		public static var MIDIDRUM_46_Open_Hi_Hat:Int = 46;
		public static var MIDIDRUM_47_Low_Mid_Tom:Int = 47;
		public static var MIDIDRUM_48_Hi_Mid_Tom:Int = 48;
		public static var MIDIDRUM_49_Crash_Cymbal_1:Int = 49;
		public static var MIDIDRUM_50_High_Tom:Int = 50;
		public static var MIDIDRUM_51_Ride_Cymbal_1:Int = 51;
		public static var MIDIDRUM_52_Chinese_Cymbal:Int = 52;
		public static var MIDIDRUM_53_Ride_Bell:Int = 53;
		public static var MIDIDRUM_54_Tambourine:Int = 54;
		public static var MIDIDRUM_55_Splash_Cymbal:Int = 55;
		public static var MIDIDRUM_56_Cowbell:Int = 56;
		public static var MIDIDRUM_57_Crash_Cymbal_2:Int = 57;
		public static var MIDIDRUM_58_Vibraslap:Int = 58;
		public static var MIDIDRUM_59_Ride_Cymbal_2:Int = 59;
		public static var MIDIDRUM_60_Hi_Bongo:Int = 60;
		public static var MIDIDRUM_61_Low_Bongo:Int = 61;
		public static var MIDIDRUM_62_Mute_Hi_Conga:Int = 62;
		public static var MIDIDRUM_63_Open_Hi_Conga:Int = 63;
		public static var MIDIDRUM_64_Low_Conga:Int = 64;
		public static var MIDIDRUM_65_High_Timbale:Int = 65;
		public static var MIDIDRUM_66_Low_Timbale:Int = 66;
		public static var MIDIDRUM_67_High_Agogo:Int = 67;
		public static var MIDIDRUM_68_Low_Agogo:Int = 68;
		public static var MIDIDRUM_69_Cabasa:Int = 69;
		public static var MIDIDRUM_70_Maracas:Int = 70;
		public static var MIDIDRUM_71_Short_Whistle:Int = 71;
		public static var MIDIDRUM_72_Long_Whistle:Int = 72;
		public static var MIDIDRUM_73_Short_Guiro:Int = 73;
		public static var MIDIDRUM_74_Long_Guiro:Int = 74;
		public static var MIDIDRUM_75_Claves:Int = 75;
		public static var MIDIDRUM_76_Hi_Wood_Block:Int = 76;
		public static var MIDIDRUM_77_Low_Wood_Block:Int = 77;
		public static var MIDIDRUM_78_Mute_Cuica:Int = 78;
		public static var MIDIDRUM_79_Open_Cuica:Int = 79;
		public static var MIDIDRUM_80_Mute_Triangle:Int = 80;
		public static var MIDIDRUM_81_Open_Triangle:Int = 81;
		
		public static function openfile():Void {
			control.stopmusic();	
			
			file = File.desktopDirectory.resolvePath("");
		  file.addEventListener(Event.SELECT, onloadmidi);
			file.browseForOpen("Load .mid File", [midiFilter]);
			
			control.fixmouseclicks = true;
		}
		
		public static function savemidi():Void {
			control.stopmusic();	
			
			file = File.desktopDirectory.resolvePath("*.mid");
      file.addEventListener(Event.SELECT, onsavemidi);
			file.browseForSave("Save .mid File");
			
			control.fixmouseclicks = true;
		}
		
		private static function onsavemidi(e:Event):Void {    
			file = cast(e.currentTarget,File);
			
			if (!control.fileHasExtension(file, "mid")) {
				control.addExtensionToFile(file, "mid");
			}
			
			convertceoltomidi();
			
			tempbytes = new ByteArray();
			tempbytes = clone(midiexporter.midifile.output());
			
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(tempbytes, 0, tempbytes.length);
			stream.close();
			
			control.fixmouseclicks = true;
			control.showmessage("SONG EXPORTED AS MIDI");
		}
		
		private static function onloadmidi(e:Event):Void {  
			mididata = new ByteArray();
			file = cast(e.currentTarget,File);
			
			stream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(mididata);
			stream.close();
			
			tempbytes = new ByteArray;
			tempbytes = clone(mididata);
			midiexporter = new Midiexporter;
			midiexporter.midifile.input(tempbytes);
			
			smfData.loadBytes(mididata);
			
			var track:SMFTrack;
			var event:SMFEvent;
			
			clearnotes();
			resetinstruments();
			
			
			
		var trackn:Int = 0;
	while( trackn < smfData.numTracks){
				
				for each(event in smfData.tracks[trackn].sequence) {
					
					switch (event.type & 0xf0) {
						case SMFEvent.NOTE_ON:
							if(event.velocity == 0) {
								
								changenotelength(event.time, event.note, event.channel);
							}else{
								addnote(event.time, event.note, event.channel);
								if (event.velocity > channelvolume[event.channel]) {
									channelvolume[event.channel] = event.velocity;
								}
							}
						break;
						case SMFEvent.NOTE_OFF:
							changenotelength(event.time, event.note, event.channel);
						break;
						case SMFEvent.PROGRAM_CHANGE:
							channelinstrument[event.channel] = event.value;
						break;
					}
				}
			 trackn++;
} 
			
			
			channelinstrument[9] = control.voicelist.getvoice("Simple Drumkit");
			
			convertmiditoceol();
			
			control.arrange.currentbar = 0; control.arrange.viewstart = 0;
			control.changemusicbox(0);
			
			
      
			control.showmessage("MIDI IMPORTED");
			control.fixmouseclicks = true;
		}
		
		public static function clone(source:Dynamic):Dynamic { 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}
		
		public static function resetinstruments():Void {
			if (channelinstrument.length == 0) {
			var i:Int = 0;
	while( i < 16){
					channelinstrument.push(-1);
					channelvolume.push(0);
				 i++;
}
			}else {
			i = 0;
	while( i < 16){
					channelinstrument[i] = -1;
					channelvolume[i] = 0;
				 i++;
}
			}
		}
		
		public static function clearnotes():Void {
			unmatchednotes = new Array<Rectangle>;
			midinotes = new Array<Rectangle>;
		}
		
		public static function addnote(time:Int, note:Int, instr:Int):Void {
			unmatchednotes.push(new Rectangle(time, note, 0, instr));
			
		}
		
		public static function changenotelength(time:Int, note:Int, instr:Int):Void {
			
			var timedist:Int = -1;
			var currenttimedist:Int = 0;
			var matchingnote:Int = -1;
		var i:Int = 0;
	while( i < unmatchednotes.length){
				if (unmatchednotes[i].y == note && unmatchednotes[i].height == instr) {
					currenttimedist = time - unmatchednotes[i].x;
					if (currenttimedist >= 0) {
						if (timedist == -1) {
							timedist = currenttimedist;
							matchingnote = i;
						}else {
							if (currenttimedist < timedist) {
								timedist = currenttimedist;
								matchingnote = i;
							}
						}
					}
				}
			 i++;
}
			
			if (matchingnote != -1) {
				unmatchednotes[matchingnote].width = -1;
			  midinotes.push(new Rectangle(unmatchednotes[matchingnote].x, 
																		 unmatchednotes[matchingnote].y, 
																		 time, 
																		 unmatchednotes[matchingnote].height));
				
        
				if (matchingnote != unmatchednotes.length - 1) {					
					var swp:Int;
					
					swp = unmatchednotes[matchingnote].x;
					unmatchednotes[matchingnote].x = unmatchednotes[unmatchednotes.length - 1].x;
					unmatchednotes[unmatchednotes.length - 1].x = swp;
					
					swp = unmatchednotes[matchingnote].y;
					unmatchednotes[matchingnote].y = unmatchednotes[unmatchednotes.length - 1].y;
					unmatchednotes[unmatchednotes.length - 1].y = swp;
					
					swp = unmatchednotes[matchingnote].width;
					unmatchednotes[matchingnote].width = unmatchednotes[unmatchednotes.length - 1].width;
					unmatchednotes[unmatchednotes.length - 1].width = swp;
					
					swp = unmatchednotes[matchingnote].height;
					unmatchednotes[matchingnote].height = unmatchednotes[unmatchednotes.length - 1].height;
					unmatchednotes[unmatchednotes.length - 1].height = swp;
				}
			}
			
			if (unmatchednotes.length > 0) {
				if (unmatchednotes[unmatchednotes.length - 1].width == -1) {
					unmatchednotes.pop();
				}
			}
		}
		
		public static function getsonglength():Int {
			return Std.int(smfData.measures);
		}
		
		public static function reversechannelinstrument(t:Int):Int {
			
		var i:Int = 0;
	while( i < 16){
				if (channelinstrument[i] == t) return i;
			 i++;
}
			return -1;
		}
		
		public static function gettopbox(currentpattern:Int, chan:Int):Int {
			
			if (chan == 9) {
				
				if(control.arrange.bar[currentpattern].channel[7] == -1) {
					return 7;
				}else {
					if (reversechannelinstrument(channelinstrument[control.musicbox[control.arrange.bar[currentpattern].channel[7]].instr]) == reversechannelinstrument(channelinstrument[chan])) {
						return 7;
					}	
				}
			}
			
			
		var i:Int = 0;
	while( i < 8){
				if(control.arrange.bar[currentpattern].channel[i] == -1) {
					return i;
				}else {
					if (channelinstrument[chan] != -1) {
						if (reversechannelinstrument(channelinstrument[control.musicbox[control.arrange.bar[currentpattern].channel[i]].instr]) == reversechannelinstrument(channelinstrument[chan])) {
							return i;
						}	
					}					
				}
			 i++;
}
			return -1;
		}
		
		public static function getmusicbox(currentpattern:Int, chan:Int):Int {
			
			var top:Int = gettopbox(currentpattern, chan);
			
			if (top > -1) {
				if (control.arrange.bar[currentpattern].channel[top] == -1) {
					control.currentinstrument = chan;
					if (channelinstrument[chan] > -1) {
						control.voicelist.index = channelinstrument[chan];
						control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					}else {
						control.voicelist.index = 0;
						control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					}
					control.addmusicbox();
					control.arrange.addpattern(currentpattern, top, control.numboxes - 1);
					return control.numboxes - 1;
				}else {
					return control.arrange.bar[currentpattern].channel[top];
				}
			}
			
			return -1;
		}
		
		public static function addnotetoceol(currentpattern:Int, time:Int, pitch:Int, notelength:Int, chan:Int):Void {
			
			currentpattern = getmusicbox(currentpattern, chan);
			if(currentpattern>-1){
				control.musicbox[currentpattern].addnote(time, pitch, notelength);
			}
		}
		
		public static function replaceontimeline(_old:Int, _new:Int):Void {
		var i:Int = 0;
	while( i < numpatterns){
			var j:Int = 0;
	while( j < 8){
					if (control.arrange.bar[i].channel[j] == _old) {
						control.arrange.bar[i].channel[j] = _new;
					}
				 j++;
}
			 i++;
}
		}
		
		public static function musicboxmatch(a:Int, b:Int):Bool {
			if (control.musicbox[a].numnotes == control.musicbox[b].numnotes) {
				if (control.musicbox[a].instr == control.musicbox[b].instr) {
				var i:Int = 0;
	while( i < control.musicbox[a].numnotes){
						if (control.musicbox[a].notes[i].x != control.musicbox[b].notes[i].x) {
							return false;
						}
					 i++;
}
					return true;
				}
			}
			return false;
		}
		
		public static function convertmiditoceol():Void {
			control.newsong();
			control.numboxes = 0;
			control.bpm = (smfData.bpm - (smfData.bpm % 5));
			if (control.bpm <= 10) control.bpm = 120;
			control._driver.bpm = control.bpm;
			control._driver.play(null, false);
			
			
			
			
			
			resolution = smfData.resolution;
			signature = smfData.signature_d;
			numnotes = smfData.signature_d * smfData.signature_n;
			if (signature == 0 || numnotes == 0) {
				signature = 4;
				numnotes = 16;
			}
			if (numnotes > 16) control.doublesize = true;
			
			var boxsize:Int = resolution;
			numpatterns = getsonglength();
			control.numboxes = 0;
			control.arrange.bar[0].channel[0] = -1;
			
			control.numinstrument = 16;
		var j:Int = 0;
	while( j < 16){
			  control.currentinstrument = j;
				control.voicelist.index = 132; 
				control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					
				if (channelinstrument[j] > -1) {
					control.voicelist.index = channelinstrument[j];
					control.changeinstrumentvoice(control.voicelist.name[control.voicelist.index]);
					
					control.instrument[control.currentinstrument].setvolume((channelvolume[j] * 256) / 128);
					control.instrument[control.currentinstrument].updatefilter();
					if (control.instrument[control.currentinstrument].type > 0) {
						control.drumkit[control.instrument[control.currentinstrument].type-1].updatevolume((channelvolume[j] * 256) / 128);
					}
				}
			 j++;
}
			
			var i:Int;
			var note:Int;
			var notelength:Int;
			var currentpattern:Int;
			
		i = 0;
	while( i < midinotes.length){
				
				if (Std.int (midinotes[i].height) == 9) {
					
					
					
					
				  note = ((midinotes[i].x * numnotes) / boxsize);
					notelength = (((midinotes[i].width - midinotes[i].x - 1) * numnotes) / boxsize) + 1;
					currentpattern = Std.int((midinotes[i].x  - (midinotes[i].x % boxsize)) / boxsize);
					
					var drumnote:Int = 0;
					
					
				  
					
					
					
					
					
					
					switch(midinotes[i].y) {
						case MIDIDRUM_35_Acoustic_Bass_Drum: drumnote = 0; break;
						case MIDIDRUM_36_Bass_Drum_1: drumnote = 1; break;
						case MIDIDRUM_37_Side_Stick: drumnote = 3; break;
						case MIDIDRUM_38_Acoustic_Snare: drumnote = 3; break;
						case MIDIDRUM_39_Hand_Clap: drumnote = 1; break;
						case MIDIDRUM_40_Electric_Snare: drumnote = 4; break;
						case MIDIDRUM_41_Low_Floor_Tom: drumnote = 1; break;
						case MIDIDRUM_42_Closed_Hi_Hat: drumnote = 6; break;
						case MIDIDRUM_43_High_Floor_Tom: drumnote = 2; break;
						case MIDIDRUM_44_Pedal_Hi_Hat: drumnote = 5; break;
						case MIDIDRUM_45_Low_Tom: drumnote = 1; break;
						case MIDIDRUM_46_Open_Hi_Hat: drumnote = 5; break;
						case MIDIDRUM_47_Low_Mid_Tom: drumnote = 1; break;
						case MIDIDRUM_48_Hi_Mid_Tom: drumnote = 2; break;
						case MIDIDRUM_49_Crash_Cymbal_1: drumnote = 7; break;
						case MIDIDRUM_50_High_Tom: drumnote = 2; break;
						case MIDIDRUM_51_Ride_Cymbal_1: drumnote = 7; break;
						case MIDIDRUM_52_Chinese_Cymbal: drumnote = 7; break;
						case MIDIDRUM_53_Ride_Bell: drumnote = 5; break;
						case MIDIDRUM_54_Tambourine: drumnote = 5; break;
						case MIDIDRUM_55_Splash_Cymbal: drumnote = 7; break;
						case MIDIDRUM_56_Cowbell: drumnote = 7; break;
						case MIDIDRUM_57_Crash_Cymbal_2: drumnote = 7; break;
						case MIDIDRUM_58_Vibraslap: drumnote = 5; break;
						case MIDIDRUM_59_Ride_Cymbal_2: drumnote = 7; break;
						case MIDIDRUM_60_Hi_Bongo: drumnote = 4; break;
						case MIDIDRUM_61_Low_Bongo: drumnote = 3; break;
						case MIDIDRUM_62_Mute_Hi_Conga: drumnote = 4; break;
						case MIDIDRUM_63_Open_Hi_Conga: drumnote = 5; break;
						case MIDIDRUM_64_Low_Conga: drumnote = 2; break;
						case MIDIDRUM_65_High_Timbale: drumnote = 4; break;
						case MIDIDRUM_66_Low_Timbale: drumnote = 3; break;
						case MIDIDRUM_67_High_Agogo: drumnote = 4; break;
						case MIDIDRUM_68_Low_Agogo: drumnote = 3; break;
						case MIDIDRUM_69_Cabasa: drumnote = 5; break;
						case MIDIDRUM_70_Maracas: drumnote = 7; break;
						case MIDIDRUM_71_Short_Whistle: drumnote = 7; break;
						case MIDIDRUM_72_Long_Whistle: drumnote = 7; break;
						case MIDIDRUM_73_Short_Guiro: drumnote = 3; break;
						case MIDIDRUM_74_Long_Guiro: drumnote = 4; break;
						case MIDIDRUM_75_Claves: drumnote = 6; break;
						case MIDIDRUM_76_Hi_Wood_Block: drumnote = 4; break;
						case MIDIDRUM_77_Low_Wood_Block: drumnote = 3; break;
						case MIDIDRUM_78_Mute_Cuica: drumnote = 2; break;
						case MIDIDRUM_79_Open_Cuica: drumnote = 4; break;
						case MIDIDRUM_80_Mute_Triangle: drumnote = 5; break;
						case MIDIDRUM_81_Open_Triangle: drumnote = 7; break;
					}
					
					addnotetoceol(currentpattern, note - (numnotes * currentpattern), drumnote, notelength, midinotes[i].height);
				}else {
					
					
					
					
					note = ((midinotes[i].x * numnotes) / boxsize);
			    notelength = (((midinotes[i].width - midinotes[i].x - 1) * numnotes) / boxsize) + 1;
					currentpattern = Std.int((midinotes[i].x  - (midinotes[i].x % boxsize)) / boxsize);
					
					addnotetoceol(currentpattern, note - (numnotes * currentpattern), midinotes[i].y, notelength, midinotes[i].height);
				}
			 i++;
}
			
			
		i = 0;
	while( i < control.numboxes){
				var currenthash:Int = control.musicbox[i].hash;
				if (currenthash != -1) {
				j = i + 1;
	while( j < control.numboxes){
						if (control.musicbox[j].hash == currenthash) {
							
							if (musicboxmatch(i, j)) {
								replaceontimeline(j, i);
								control.musicbox[j].hash = -1;
							}
						}
					 j++;
}
				}
			 i++;
}
			
			
			i = control.numboxes;
			while (i >= 0) {
				if (i < control.numboxes) {
					if (control.musicbox[i].hash == -1) {
						control.deletemusicbox(i);
					}
				}
			  i--;	
			}
			
			control.arrange.loopstart = 0;
			control.arrange.loopend = control.arrange.lastbar;	
			if (control.arrange.loopend <= control.arrange.loopstart) {
				control.arrange.loopend = control.arrange.loopstart + 1;
			}
		}
		
		public static function convertceoltomidi():Void {
		  
			
			
			midiexporter = new Midiexporter;
			
			midiexporter.nexttrack();
			midiexporter.writetimesig();
			midiexporter.writetempo(control.bpm);
			
			midiexporter.nexttrack();
			
			
			
		var j:Int = 0;
	while( j < control.numinstrument){
			  midiexporter.writeinstrument(instrumentconverttomidi(control.instrument[j].index), j);
			 j++;
}
			
			
			control.arrange.loopstart = 0;
			control.arrange.loopend = control.arrange.lastbar;	
			if (control.arrange.loopend <= control.arrange.loopstart) {
				control.arrange.loopend = control.arrange.loopstart + 1;
			}
			
			
			
			
		j = 0;
	while( j < control.arrange.lastbar){
			var i:Int = 0;
	while( i < 8){
					if (control.arrange.bar[j].channel[i] != -1) {
						var t:Int = control.arrange.bar[j].channel[i];
						
						if (control.instrument[control.musicbox[control.arrange.bar[j].channel[i]].instr].type == 0) {
						var k:Int = 0;
	while( k < control.musicbox[t].numnotes){
								midiexporter.writenote(control.musicbox[t].instr, 
																			 control.musicbox[t].notes[k].x, 
																			 ((j * control.boxcount) + control.musicbox[t].notes[k].width) * 30, 
																			 control.musicbox[t].notes[k].y * 30, 255);
							 k++;
}
						}
					}
				 i++;
}
			 j++;
}
			
			midiexporter.nexttrack();
			midiexporter.writeinstrument(0, 9);
			
		j = 0;
	while( j < control.arrange.lastbar){
			i = 0;
	while( i < 8){
					if (control.arrange.bar[j].channel[i] != -1) {
						t = control.arrange.bar[j].channel[i];
						var drumkit:Int = control.musicbox[control.arrange.bar[j].channel[i]].instr;
						
						if (help.Left(control.voicelist.voice[control.instrument[drumkit].index], 7) == "drumkit") {
						k = 0;
	while( k < control.musicbox[t].numnotes){
								midiexporter.writenote(9, 
																			 convertdrumtonote(control.musicbox[t].notes[k].x, control.instrument[drumkit].index), 
																			 ((j * control.boxcount) + control.musicbox[t].notes[k].width) * 30, 
																			 control.musicbox[t].notes[k].y * 30, 255);
							 k++;
}
						}
					}
				 i++;
}
			 j++;
}
			
			
			
			
			
			
		}
		
		public static function convertdrumtonote(note:Int, drumkit:Int):Int {
			
			
			var i:Int;
			var voicename:String = "";
			if (control.voicelist.name[drumkit] == "Simple Drumkit") {
				voicename = control.drumkit[0].voicename[note];
				
				if (voicename == "Bass Drum 1") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Bass Drum 2") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Bass Drum 3") return MIDIDRUM_66_Low_Timbale;
				if (voicename == "Snare Drum") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare Drum 2") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "Open Hi-Hat") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Closed Hi-Hat") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Crash Cymbal") return MIDIDRUM_49_Crash_Cymbal_1;
			}else if (control.voicelist.name[drumkit] == "SiON Drumkit") {
				voicename = control.drumkit[1].voicename[note];
				
				if (voicename == "Bass Drum 2") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Bass Drum 3 o1f") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "RUFINA BD o2c") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "B.D.(-vBend)") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "BD808_2(-vBend)") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Cho cho 3 (o2e)") return MIDIDRUM_72_Long_Whistle;
				if (voicename == "Cow-Bell 1") return MIDIDRUM_56_Cowbell;
				if (voicename == "Crash Cymbal (noise)") return MIDIDRUM_49_Crash_Cymbal_1;
				if (voicename == "Crash Noise") return MIDIDRUM_57_Crash_Cymbal_2;
				if (voicename == "Crash Noise Short") return MIDIDRUM_51_Ride_Cymbal_1;
				if (voicename == "ETHNIC Percus.0") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "ETHNIC Percus.1") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "Heavy BD.") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Heavy BD2") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Heavy SD1") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Hi-Hat close 5_") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat close 4") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat close 5") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat Close 6 -808-") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-hat #7 Metal o3-6") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-Hat Close #8 o4") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Hi-hat Open o4e-g+") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Open-hat2 Metal o4c-") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Open-hat3 Metal") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Hi-Hat Open #4 o4f") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Metal ride o4c or o5c") return MIDIDRUM_51_Ride_Cymbal_1;
				if (voicename == "Rim Shot #1 o3c") return MIDIDRUM_59_Ride_Cymbal_2;
				if (voicename == "Snare Drum Light") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare Drum Lighter") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare Drum 808 o2-o3") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare4 -808type- o2") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Snare5 o1-2(Franger)") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Tom (old)") return MIDIDRUM_45_Low_Tom;
				if (voicename == "Synth tom 2 algo 3") return MIDIDRUM_47_Low_Mid_Tom;
				if (voicename == "Synth (Noisy) Tom #3") return MIDIDRUM_48_Hi_Mid_Tom;
				if (voicename == "Synth Tom #3") return MIDIDRUM_50_High_Tom;
				if (voicename == "Synth -DX7- Tom #4") return MIDIDRUM_76_Hi_Wood_Block;
				if (voicename == "Triangle 1 o5c") return MIDIDRUM_81_Open_Triangle;
			}else if (control.voicelist.name[drumkit] == "Midi Drumkit") {
				
				trace(note, control.drumkit[2].midivoice[note]);
				if (control.drumkit[2].midivoice[note] >= 35 && control.drumkit[2].midivoice[note] <= 81) {
					return control.drumkit[2].midivoice[note];
				}
				
				
				voicename = control.drumkit[2].voicename[note];
				if (voicename == "Seq Click H") return MIDIDRUM_42_Closed_Hi_Hat;
				if (voicename == "Brush Tap") return MIDIDRUM_55_Splash_Cymbal;
				if (voicename == "Brush Swirl") return MIDIDRUM_59_Ride_Cymbal_2;
				if (voicename == "Brush Slap") return MIDIDRUM_49_Crash_Cymbal_1;
				if (voicename == "Brush Tap Swirl") return MIDIDRUM_49_Crash_Cymbal_1;
				if (voicename == "Snare Roll") return MIDIDRUM_38_Acoustic_Snare;
				if (voicename == "Castanet") return MIDIDRUM_35_Acoustic_Bass_Drum;
				if (voicename == "Snare L") return MIDIDRUM_40_Electric_Snare;
				if (voicename == "Sticks") return MIDIDRUM_37_Side_Stick;
				if (voicename == "Bass Drum L") return MIDIDRUM_36_Bass_Drum_1;
				if (voicename == "Open Rim Shot") return MIDIDRUM_46_Open_Hi_Hat;
				if (voicename == "Shaker") return MIDIDRUM_70_Maracas;
				if (voicename == "Jingle Bells") return MIDIDRUM_81_Open_Triangle;
				if (voicename == "Bell Tree") return MIDIDRUM_74_Long_Guiro;
			}
			
			
			return 35;
		}
		
		public static function instrumentconverttomidi(t:Int):Int {
			
			return control.voicelist.midimap[t];
		}
		
		CONFIG::desktop {
			public static var file:File, stream:FileStream;
		}
		
		public static var mididata:ByteArray;
		public static var resolution:Float;
		public static var signature:Float;
		public static var numnotes:Int;
		public static var numpatterns:Int;
		
		public static var midiFilter:FileFilter = new FileFilter("Standard MIDI File", "*.mid;*.midi;");
		
		public static var unmatchednotes: Array<Rectangle> = new Array<Rectangle>;
		public static var midinotes: Array<Rectangle> = new Array<Rectangle>;
		public static var channelinstrument: Array<Int> = new Array<Int>;
		public static var channelvolume: Array<Int> = new Array<Int>;
    public static var smfData:SMFData = new SMFData();
		
		
		public static var tempbytes:ByteArray;
		public static var midiexporter:Midiexporter;
	}
}
