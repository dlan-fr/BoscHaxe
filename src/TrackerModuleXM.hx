package ;
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.geom.Rectangle;
	import org.si.sion.SiONDriver;
	import org.si.sion.SiONVoice;
	import co.sparemind.trackermodule.XMSong;
	import co.sparemind.trackermodule.XMInstrument;
	import co.sparemind.trackermodule.XMSample;
	import co.sparemind.trackermodule.XMPattern;
	import co.sparemind.trackermodule.XMPatternLine;
	import co.sparemind.trackermodule.XMPatternCell;

	class TrackerModuleXM {
		public function new() {
			
		}
		
		public var xm:XMSong;

		public function loadFromLiveBoscaCeoilModel(desiredSongName:String):Void {
			var boscaInstrument:instrumentclass;
			
			xm = new XMSong;
			
			xm.songname = desiredSongName;
			xm.defaultBPM = control.bpm;
			xm.defaultTempo = Std.int(control.bpm / 20);
			xm.numChannels = 8; 
			xm.numInstruments = control.numinstrument;
			
			var notesByEachInstrumentNumber: Array<Array<Int>> = _notesUsedByEachInstrumentAcrossEntireSong();
			
			
			var perInstrumentBoscaNoteToXMNoteMap: Array<Array<Int>> = new Array<Array<Int>>;
		i = 0;
	while( i < control.numinstrument){
				boscaInstrument = control.instrument[i];
				var boscaNoteToXMNoteMapForThisInstrument: Array<Int> = _boscaNoteToXMNoteMapForInstrument(boscaInstrument, notesByEachInstrumentNumber[i]);
				perInstrumentBoscaNoteToXMNoteMap[i] = boscaNoteToXMNoteMapForThisInstrument;
			 i++;
}
			
			
		var i:Int = 0;
	while( i < control.arrange.lastbar){
				var xmpat:XMPattern = xmPatternFromBoscaBar(i, perInstrumentBoscaNoteToXMNoteMap);
				xm.patterns.push(xmpat);
				xm.patternOrderTable[i] = i;
				xm.numPatterns++;
				xm.songLength++;
			 i++;
}
			
		i = 0;
	while( i < control.numinstrument){
				boscaInstrument = control.instrument[i];
				var xmInstrument:XMInstrument = new XMInstrument();
				var notesUsed: Array<Int> = notesByEachInstrumentNumber[i];
				xmInstrument.name = boscaInstrument.name;
				xmInstrument.volume = Std.int(boscaInstrument.volume / 4);
				switch (boscaInstrument.type) {
					case 0:
				    xmInstrument.addSample(_boscaInstrumentToXMSample(boscaInstrument, control._driver));
						break;
					default:
						
						
				    var drumkitNumber:Int = boscaInstrument.type - 1;
				    xmInstrument.addSamples(_boscaDrumkitToXMSamples(control.drumkit[drumkitNumber], notesUsed, perInstrumentBoscaNoteToXMNoteMap[i], control._driver));
				   var s:Int = 0;
	while( s < notesUsed.length){
							var sionNote:Int = notesUsed[s];
							var key:Int = perInstrumentBoscaNoteToXMNoteMap[i][sionNote] - 1; 
							xmInstrument.keymapAssignments[key] = s;
						 s++;
}
						
				    for each (var sample:XMSample in xmInstrument.samples) {
							sample.volume = xmInstrument.volume;
						}
				}
				
				xm.addInstrument(xmInstrument);
			 i++;
}
		}

		public function writeToStream(stream:IDataOutput):Void {
			xm.writeToStream(stream);
		}

		public function _notesUsedByEachInstrumentAcrossEntireSong(): Array<Array<Int>> {
			var seenNotePerInstrument:Array<Dynamic> = [];
			var i:Int;
			var n:Int;

			
		i = 0;
	while( i < control.numinstrument){
				seenNotePerInstrument[i] = [];
			 i++;
}

			
		i = 0;
	while( i < control.numboxes){
				var box:musicphraseclass = control.musicbox[i];
				var instrumentNum:Int = box.instr;

			n = 0;
	while( n < box.numnotes){
					var noteNum:Int = box.notes[n].x;
					seenNotePerInstrument[instrumentNum][noteNum] = true;
				 n++;
}
			 i++;
}

			
			var notesUsedByEachInstrument: Array<Array<Int>> = new Array<Array<Int>>;
		i = 0;
	while( i < seenNotePerInstrument.length){
				var notesUsedByThisInstrument: Array<Int> = new Array<Int>;
			n = 0;
	while( n < seenNotePerInstrument[i].length){
					if (seenNotePerInstrument[i][n]) {
						notesUsedByThisInstrument.push(n);
					}
				 n++;
}
				notesUsedByEachInstrument.push(notesUsedByThisInstrument);
			 i++;
}

			return notesUsedByEachInstrument;
		}

		function xmPatternFromBoscaBar(barNum:Int, instrumentNoteMap: Array<Array<Int>>):XMPattern {
			var numtracks:Int = 8;
			var numrows:Int = control.boxcount;
			var pattern:XMPattern = new XMPattern(numrows);
			var rows: Array<XMPatternLine> = pattern.rows;
		
		
		
		
		
		
		
		
		
		
		
		var rowToBlank:Int = 0;
	while( rowToBlank < numrows){
				rows[rowToBlank] = new XMPatternLine(numtracks);
			 rowToBlank++;
}
			
		var i:Int = 0;
	while( i < numtracks){
				var whichbox:Int = control.arrange.bar[barNum].channel[i];
				if (whichbox < 0) { continue; }
				var box:musicphraseclass = control.musicbox[whichbox];

				var notes: Array<Rectangle> = box.notes;
			var j:Int = 0;
	while( j < box.numnotes){
					var boscaNote:Rectangle = notes[j];
					var timerelativetostartofbar:Int = boscaNote.width; 
					var notelength:Int = boscaNote.y;
					var xmnote:XMPatternCell = boscaBoxNoteToXMNote(box, j, instrumentNoteMap);

					
					var targetTrack:Int = i;
					while (rows[timerelativetostartofbar].cellOnTrack[targetTrack].note > 0) {
						
						targetTrack++;
						if (!(targetTrack < numtracks)) {
							
							continue;
						}
					}

					rows[timerelativetostartofbar].cellOnTrack[targetTrack] = xmnote;
					var endrow:Int = timerelativetostartofbar + notelength;
					if (endrow >= numrows) { continue; }
					if (rows[endrow].cellOnTrack[targetTrack].note > 0) { continue; } 
					rows[endrow].cellOnTrack[targetTrack] = new XMPatternCell({
						note: 97, 
						instrument: 0,
						volume: 0,
						effect: 0,
						effectParam: 0
					});
				 j++;
}
			 i++;
}
			return pattern;
		}

		function boscaBoxNoteToXMNote(box:musicphraseclass, notenum:Int, noteMapping: Array<Array<Int>>):XMPatternCell {
			var sionNoteNum:Int = box.notes[notenum].x;
			var xmNoteNum:Int = noteMapping[box.instr][sionNoteNum];
			return new XMPatternCell(
					{
					note: xmNoteNum,
					instrument: box.instr + 1,
					volume: 0,
					effect: 0,
					effectParam: 0
			});
		}

		function _boscaNoteToXMNoteMapForInstrument(boscaInstrument:instrumentclass, usefulNotes: Array<Int>): Array<Int> {
			if (boscaInstrument.type > 0) {
				return _boscaDrumkitToXMNoteMap(usefulNotes);
			}

			return _boscaNoteToXMNoteMapLinear();
		}

		function _boscaNoteToXMNoteMapLinear(): Array<Int> {
			var map: Array<Int> = new Array<Int>;
		var scionNote:Int = 0;
	while( scionNote < 127){
				var maybeXMNote:Int = scionNote + 13;
				var xmNote:Int;
				if (maybeXMNote < 1) { 
					map[scionNote] = 0;
					continue;
				}
				if (maybeXMNote > 96) { 
					map[scionNote] = 0;
					continue;
				}
				map[scionNote] = Std.int(maybeXMNote);
			 scionNote++;
}
			return map;
		}

		function _boscaDrumkitToXMNoteMap(necessaryNotes: Array<Int>): Array<Int> {
			var map: Array<Int> = new Array<Int>;
			var startAt:Int = 49; 
			var scionNote:Int;
			var offset:Int;

			
		scionNote = 0;
	while( scionNote < 128){
				map[scionNote] = 0; 
			 scionNote++;
}

			
			
		offset = 0;
	while( offset < necessaryNotes.length){
				var necessaryNote:Int = necessaryNotes[offset];
				var xmNote:Int = startAt + offset;
				map[necessaryNote] = xmNote;
			 offset++;
}

			return map;
		}

		
		
		
		
		function _boscaDrumkitToXMSamples(drumkit:drumkitclass, whichDrumNumbers: Array<Int>, noteMapping: Array<Int>, driver:SiONDriver): Array<XMSample> {
			var samples: Array<XMSample> = new Array<XMSample>;
		var di:Int = 0;
	while( di < whichDrumNumbers.length){
				var d:Int = whichDrumNumbers[di];
				var voice:SiONVoice = drumkit.voicelist[d];
				var samplename:String = drumkit.voicename[d];
				var sionNoteNum:Int = drumkit.voicenote[d];
				var xmNoteNum:Int = noteMapping[sionNoteNum];

				var compensationNeeded:Int = 0; 

				var xmsample:XMSample = new XMSample;
				xmsample.relativeNoteNumber = 0;
				xmsample.name = voice.name;
				xmsample.volume = 0x40;
				xmsample.bitsPerSample = 16;
				xmsample.data = _playSiONNoteTo16BitDeltaSamples(sionNoteNum + compensationNeeded, voice, 32, driver);

				samples.push(xmsample);
			 di++;
}
			return samples;
		}

		function _boscaInstrumentToXMSample(instrument:instrumentclass, driver:SiONDriver):XMSample {
			var voice:SiONVoice = instrument.voice;
			var xmsample:XMSample = new XMSample;
			xmsample.relativeNoteNumber = +3;
			xmsample.name = voice.name;
			xmsample.volume = 0x40;
			xmsample.bitsPerSample = 16;
			
			
			var c5:Int = 60;
			
			xmsample.data = _playSiONNoteTo16BitDeltaSamples(c5, voice, 16, driver);
			trace(xmsample);
			return xmsample;
		}

		function _playSiONNoteTo16BitDeltaSamples(note:Int, voice:SiONVoice, length:Float, driver:SiONDriver):ByteArray {
			var deltasamples:ByteArray = new ByteArray;
			deltasamples.endian = Endian.LITTLE_ENDIAN;

			
			
			driver.stop();

			var renderBuffer: Array<Float> = new Array<Float>;
			
			
			var mml:String = voice.getMML(voice.channelNum) + ' %6,' + voice.channelNum + '@' + voice.toneNum + ' ' + _mmlNoteFromSiONNoteNumber(note); 
			trace(mml);
			driver.render(mml, renderBuffer, 1);

			
			var previousSample:Int = 0;
		var i:Int;
	while( i < renderBuffer.length){
				var thisSample:Int = renderBuffer[i] * 32767; 
				var sampleDelta:Int = thisSample - previousSample;
				deltasamples.writeShort(sampleDelta);
				previousSample = thisSample;
			 i++;
}
			driver.play();

			return deltasamples;
		}

		
		function _mmlNoteFromSiONNoteNumber(noteNum:Int):String {
			var noteNames: Array<String> = Array<String>(['c', 'c+', 'd', 'd+', 'e', 'f', 'f+', 'g', 'g+', 'a', 'a+', 'b']);

			var octave:Int = Std.int(noteNum / 12);
			var noteName:String = noteNames[noteNum % 12];
			return 'o' + octave + noteName;
		}
	}


