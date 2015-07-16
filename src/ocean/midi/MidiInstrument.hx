



package ocean.midi ;
	
	
	final class MidiInstrument {
		
		static private var _instrumentName:Array<Dynamic> = ["Acoustic Grand Piano",
													"Bright Acoustic Piano",
													"Electric Grand Piano",
													"Honky-tonk Piano",
													"Rhodes Piano",
													"Chorused Piano",
													"Harpsichord",
													"Clavichord",
													"Celesta",
													"Glockenspiel",
													"Music box",
													"Vibraphone",
													"Marimba",
													"Xylophone",
													"Tubular Bells",
													"Dulcimer",
													"Hammond Organ",
													"Percussive Organ",
													"Rock Organ",
													"Church Organ",
													"Reed Organ",
													"Accordian",
													"Harmonica",
													"Tango Accordian",
													"Acoustic Guitar (nylon)",
													"Acoustic Guitar (steel)",
													"Electric Guitar (jazz)",
													"Electric Guitar (clean)",
													"Electric Guitar (muted)",
													"Overdriven Guitar",
													"Distortion Guitar",
													"Guitar Harmonics",
													"Acoustic Bass",
													"Electric Bass(finger)",
													"Electric Bass (pick)",
													"Fretless Bass",
													"Slap Bass 1",
													"Slap Bass 2",
													"Synth Bass 1",
													"Synth Bass 2",
													"Violin",
													"Viola",
													"Cello",
													"Contrabass",
													"Tremolo Strings",
													"Pizzicato Strings",
													"Orchestral Harp",
													"Timpani",
													"String Ensemble 1",
													"String Ensemble 2",
													"Synth Strings 1",
													"Synth Strings 2",
													"Choir Aahs",
													"Voice Oohs",
													"Synth Voice",
													"Orchestra Hit",
													"Trumpet",
													"Trombone",
													"Tuba",
													"Muted Trumpet",
													"French Horn",
													"Brass Section",
													"Synth Brass 1",
													"Synth Brass 2",
													"Soprano Sax",
													"Alto Sax",
													"Tenor Sax",
													"Baritone Sax",
													"Oboe",
													"English Horn",
													"Bassoon",
													"Clarinet",
													"Piccolo",
													"Flute",
													"Recorder",
													"Pan Flute",
													"Bottle Blow",
													"Shakuhachi",
													"Whistle",
													"Ocarina",
													"Lead 1 (square)",
													"Lead 2 (sawtooth)",
													"Lead 3 (caliope lead)",
													"Lead 4 (chiff lead)",
													"Lead 5 (charang)",
													"Lead 6 (voice)",
													"Lead 7 (fifths)",
													"Lead 8 (bass+lead)",
													"Pad 1 (new age)",
													"Pad 2 (warm)",
													"Pad 3 (polysynth)",
													"Pad 4 (choir)",
													"Pad 5 (bowed)",
													"Pad 6 (metallic)",
													"Pad 7 (halo)",
													"Pad 8 (sweep)",
													"FX 1 (rain)",
													"FX 2 (soundtrack)",
													"FX 3 (crystal)",
													"FX 4 (atmosphere)",
													"FX 5 (brightness)",
													"FX 6 (goblins)",
													"FX 7 (echoes)",
													"FX 8 (sci-fi)",
													"Sitar",
													"Banjo",
													"Shamisen",
													"Koto",
													"Kalimba",
													"Bagpipe",
													"Fiddle",
													"Shanai",
													"Tinkle Bell",
													"Agogo",
													"Steel Drums",
													"Woodblock",
													"Taiko Drum",
													"Melodic Tom",
													"Synth Drum",
													"Reverse Cymbal",
													"Guitar Fret Noise",
													"Breath Noise",
													"Seashore",
													"Bird Tweet",
													"Telephone Ring",
													"Helicopter",
													"Applause",
													"Gunshot"];
		
		static private var _percussionName:Array<Dynamic> = ["Acoustic Bass Drum",
												"Bass Drum 1",
												"Side Stick",
												"Acoustic Snare",
												"Hand Clap",
												"Electric Snare",
												"Low Floor Tom",
												"Closed Hi-Hat",
												"High Floor Tom",
												"Pedal Hi-Hat",
												"Low Tom",
												"Open Hi-Hat",
												"Low-Mid Tom",
												"Hi-Mid Tom",
												"Crash Cymbal 1",
												"High Tom",
												"Ride Cymbal 1",
												"Chinese Cymbal",
												"Ride Bell",
												"Tambourine",
												"Splash Cymbal",
												"Cowbell",
												"Crash Cymbal 2",
												"Vibraslap",
												"Ride Cymbal 2",
												"Hi Bongo",
												"Low Bongo",
												"Mute Hi Conga",
												"Open Hi Conga",
												"Low Conga",
												"High Timbale",
												"Low Timbale",
												"High Agogo",
												"Low Agogo",
												"Cabasa",
												"Maracas",
												"Short Whistle",
												"Long Whistle",
												"Short Guiro",
												"Long Guiro",
												"Claves",
												"Hi Wood Block",
												"Low Wood Block",
												"Mute Cuica",
												"Open Cuica",
												"Mute Triangle",
												"Open Triangle"];
												
		
		private static var _familyName:Array<Dynamic> = ["Piano",
												"Chromatic Percussion",
												"Organ",
												"Guitar",
												"Bass",
												"Strings",
												"Ensemble",
												"Brass",
												"Reed",
												"Pipe",
												"Synth Lead",
												"Synth Pad",
												"Synth Effects",
												"Ethnic",
												"Percussive",
												"Sound Effects"];
		
		public static function getInstrumentName(key:Int):String{
			if( key>127 || key<0 ){
				throw new Error("getInstrumentName("+key+") Error! Invalid instrument channel number. In GM1 specification, 0-127 indicate 128 program channels.");
			}else{
				return _instrumentName[key];
			}
		}
		
		
		public static function getPercussionName(key:Int):String{
			if( key<35 || key>81 ){
				throw new Error("getPercussionName("+key+") Error! Invalid drum key number. In GM1 specification, 35-81 indicate 46 drum sounds.");
			}else{
				return _percussionName[key-35];
			}
		}
		
		
		public static function getFamilyNameOf(key:Int):String{
			if( key>127 || key<0 ){
				throw new Error("getFamilyNameOf("+key+") Error! Invalid instrument channel number. In GM1 specification, 0-127 indicate 128 program channels.");
			}else{
				return _familyName[Math.floor(key/8)];
			}
		}
	}
	

