package ;
	import flash.utils.IDataOutput;
	import flash.geom.Rectangle;
	import mx.utils.StringUtil;

	class MMLSong {
		var instrumentDefinitions: Array<String>;
		var mmlToUseInstrument: Array<String>;
		var noteDivisions:Int = 4;
		var bpm:Int = 120;
		var lengthOfPattern:Int = 16;
		var monophonicTracksForBoscaTrack: Array<Array<String>>;

		public function new() {
		}

		public function loadFromLiveBoscaCeoilModel():Void {
			noteDivisions = control.barcount;
			bpm = control.bpm;
			lengthOfPattern = control.boxcount;

			var emptyBarMML:String = "\n// empty bar\n" + StringUtil.repeat("  r   ", lengthOfPattern) + "\n";
			var bar:Int;
			var patternNum:Int;
			var numberOfPatterns:Int = control.numboxes;

			instrumentDefinitions = new Array<String>();
			mmlToUseInstrument = new Array<String>();
		var i:Int = 0;
	while( i < control.numinstrument){
				var boscaInstrument:instrumentclass = control.instrument[i];
				if (boscaInstrument.type == 0) { 
					instrumentDefinitions[i] = _boscaInstrumentToMML(boscaInstrument, i);
					mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
				} else {
					instrumentDefinitions[i] = "#OPN@" + i + " { 
						"4,6,\n" +
						"31,15, 0, 9, 1, 0, 0,15, 0, 0\n" +
						"31,20, 5,14, 5, 3, 0, 4, 0, 0\n" +
						"31,10, 9, 9, 1, 0, 0,10, 0, 0\n" +
						"31,22, 5,14, 5, 0, 1, 7, 0, 0};\n";
					mmlToUseInstrument[i] = _boscaInstrumentToMMLUse(boscaInstrument, i);
				}
			 i++;
}

			var monophonicTracksForBoscaPattern: Array<Array<String>> = new Array<Array<String>>(numberOfPatterns + 1);
			monophonicTracksForBoscaTrack = new Array<Array<String>>();
		var track:Int = 0;
	while( track < 8){
				var maxMonoTracksForBoscaTrack:Int = 0;
			bar = 0;
	while( bar < control.arrange.lastbar){
					patternNum = control.arrange.bar[bar].channel[track];

					if (patternNum < 0) { continue; }
					var monoTracksForBar: Array<String> = _mmlTracksForBoscaPattern(patternNum, control.musicbox);
					maxMonoTracksForBoscaTrack = Math.max(maxMonoTracksForBoscaTrack, monoTracksForBar.length);

					monophonicTracksForBoscaPattern[patternNum] = monoTracksForBar;
				 bar++;
}

				var outTracks: Array<String> = new Array<String>();
				for(var monoTrackNo:Int = 0; monoTrackNo < maxMonoTracksForBoscaTrack; monoTrackNo++) {
					var outTrack:String = "\n";
				bar = 0;
	while( bar < control.arrange.lastbar){
						patternNum = control.arrange.bar[bar].channel[track];
						if (patternNum < 0) {
							outTrack += emptyBarMML;
							continue;
						}

						monoTracksForBar = monophonicTracksForBoscaPattern[patternNum];
						if (monoTrackNo in monoTracksForBar) {
							outTrack += ("\n
							outTrack += monoTracksForBar[monoTrackNo];
						} else {
							outTrack += emptyBarMML;
						}
					 bar++;
}
					outTracks.push(outTrack)
				}
				monophonicTracksForBoscaTrack[track] = outTracks;
			 track++;
}
		}

		public function writeToStream(stream:IDataOutput):Void {
			var out:String = "";
			out += "\n";
			for each (var def:String in instrumentDefinitions) {
				out += def;
				out += "\n";
			}

			for each (var monoTracks: Array<String> in monophonicTracksForBoscaTrack) {
				if (monoTracks.length == 0) { continue; } 

				out += StringUtil.substitute("\n\n

				for each (var monoTrack:String in monoTracks) {
					out += "\n

					
					out += StringUtil.substitute("\nt{0} l{1} 

					out += monoTrack;
					out += ";\n"
				}
			}
			stream.writeMultiByte(out, "utf-8");
		}

		function _mmlTracksForBoscaPattern(patternNum:Int, patternDefinitions: Array<musicphraseclass>): Array<String> {
			var tracks: Array<String> = new Array<String>();

			var pattern:musicphraseclass = patternDefinitions[patternNum];
			var octave:Int = -1;

		var place:Int = 0;
	while( place < lengthOfPattern){
				var notesInThisSlot: Array<String> = new Array<String>();
			var n:Int = 0;
	while( n < pattern.numnotes){
					var note:Rectangle = pattern.notes[n];
					var noteStartingAt:Int = note.width;
					var sionNoteNum:Int = note.x;
					var noteLength:Int = note.y;
					var noteEndingAt:Int = noteStartingAt + noteLength - 1;

					var isNotePlaying:Bool = (noteStartingAt <= place) && (place <= noteEndingAt);

					if (!isNotePlaying) { continue; }

					var newOctave:Int = _octaveFromSiONNoteNumber(sionNoteNum);
					var mmlOctave:String = _mmlTransitionFromOctaveToOctave(octave, newOctave);
					var mmlNoteName:String = _mmlNoteNameFromSiONNoteNumber(sionNoteNum);
					var mmlSlur:String = (noteEndingAt > place) ? "& " : "  ";

					octave = newOctave;

					notesInThisSlot.push(mmlOctave + mmlNoteName + mmlSlur);
				 n++;
}
				while (notesInThisSlot.length > tracks.length) {
					var emptyTrackSoFar:String = StringUtil.repeat(emptyNoteMML, place);
					tracks.push(mmlToUseInstrument[pattern.instr] + "\n" + emptyTrackSoFar);
				}
				var emptyNoteMML:String = "  r   ";

			var track:Int = 0;
	while( track < tracks.length){
					var noteMML:String;
					if (track in notesInThisSlot) {
						noteMML = notesInThisSlot[track];
					} else {
						noteMML = emptyNoteMML;
					}
					tracks[track] += noteMML;
				 track++;
}
			 place++;
}

			return tracks;
		}

		
		function _mmlNoteNameFromSiONNoteNumber(noteNum:Int):String {
			var noteNames: Array<String> = Array<String>(['c ', 'c+', 'd ', 'd+', 'e ', 'f ', 'f+', 'g ', 'g+', 'a ', 'a+', 'b ']);

			var noteName:String = noteNames[noteNum % 12];
			return noteName;
		}

		
		function _octaveFromSiONNoteNumber(noteNum:Int):Int {
			var octave:Int = Std.int(noteNum / 12);
			return octave;
		}

		function _mmlTransitionFromOctaveToOctave(oldOctave:Int, newOctave:Int):String {
			if (oldOctave == newOctave) {
				return "  ";
			}
			if ((oldOctave + 1) == newOctave) {
				return "< ";
			}
			if ((oldOctave - 1) == newOctave) {
				return "> ";
			}
			return "o" + newOctave;
		}

		function _boscaInstrumentToMML(instrument:instrumentclass, channel:Int):String {
			return StringUtil.substitute("
		}

		function _boscaInstrumentToMMLUse(instrument:instrumentclass, channel:Int):String {
			return StringUtil.substitute("%6@{0} v{1} @f{2},{3}", channel, Std.int(instrument.volume / 16), instrument.cutoff, instrument.resonance);
		}

	}
