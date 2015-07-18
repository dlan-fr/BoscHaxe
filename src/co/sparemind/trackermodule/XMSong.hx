package co.sparemind.trackermodule ;
		
	import flash.utils.IDataOutput;
	import flash.utils.ByteArray; 
	import flash.utils.Endian;
	import sys.io.FileOutput;

	class XMSong {  

		
		public function new() {
			
		}
		 
		public var trackerName:String = 'FastTracker v2.00   ';
		public var songLength:Int = 0;
		public var restartPos:Int;
		public var numChannels:Int = 8;
		public var numPatterns:Int = 0;
		public var numInstruments:Int;
		public var instruments: Array<XMInstrument> = new Array<XMInstrument>();

		
		public var defaultTempo:Int;

		
		public var defaultBPM:Int;
		public var patternOrderTable:Array<Dynamic> = [
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
				];

		
		public var flags:Int = 0x0001; 

		
		private var headerSize:Int = 20 + 256;
		private var idText:String = 'Extended Module: ';
		private var sep:Int = 26; 
		private var version:Int = 0x0104;

		public var patterns: Array<XMPattern> = new Array<XMPattern>();

		var _name:ByteArray = new ByteArray();

		
		@:isVar public var songname(get, set):String;
		
		public function get_songname():String {
			return _name.toString();
		}

		public function set_songname(unpadded:String):String {
			_name.clear();
			_name.writeMultiByte(unpadded.substring(0,20), 'us-ascii');
		var i:Int = _name.length;
	while( i < 20){
				_name.writeByte(0x20); 
			 i++;
}
		return _name.toString();

		}

		public function writeToStream(stream:FileOutput):Void {
			var xm:XMSong = this;
			var headbuf:ByteArray = new ByteArray();
			headbuf.endian = Endian.LITTLE_ENDIAN;

			headbuf.writeMultiByte(xm.idText, 'us-ascii'); 
			headbuf.writeMultiByte(xm.songname, 'us-ascii');
			headbuf.writeByte(xm.sep); 
			headbuf.writeMultiByte(xm.trackerName, 'us-ascii');
			headbuf.writeShort(xm.version); 
			headbuf.writeUnsignedInt(xm.headerSize); 
			headbuf.writeShort(xm.songLength);
			headbuf.writeShort(xm.restartPos);
			headbuf.writeShort(xm.numChannels);
			headbuf.writeShort(xm.numPatterns);
			headbuf.writeShort(xm.numInstruments);
			headbuf.writeShort(xm.flags); 
			headbuf.writeShort(xm.defaultTempo);
			headbuf.writeShort(xm.defaultBPM);
		var i:Int = 0;
	while( i < xm.patternOrderTable.length){
				headbuf.writeByte(xm.patternOrderTable[i]);
			 i++;
}
			
			stream.writeBytes(headbuf, 0, headbuf.byteLength);

		i = 0;
	while( i < xm.patterns.length){
				var pattern:XMPattern = xm.patterns[i];
				var patbuf:ByteArray = new ByteArray();
				patbuf.endian = Endian.LITTLE_ENDIAN;
				var patternHeaderLength:Int = 9; 
				patbuf.writeUnsignedInt(patternHeaderLength);
				patbuf.writeByte(0); 
				patbuf.writeShort(pattern.rows.length);

				var patBodyBuf:ByteArray = new ByteArray();
				patBodyBuf.endian = Endian.LITTLE_ENDIAN;
			var rownum:Int = 0;
	while( rownum < pattern.rows.length){
					var line:XMPatternLine = pattern.rows[rownum];
				var chan:Int = 0;
	while( chan < line.cellOnTrack.length){
						var cell:XMPatternCell = line.cellOnTrack[chan];
						if (cell.isEmpty()) {
							patBodyBuf.writeByte(0x80);
							continue;
						}
						patBodyBuf.writeByte(cell.note);
						patBodyBuf.writeByte(cell.instrument);
						patBodyBuf.writeByte(cell.volume);
						patBodyBuf.writeByte(cell.effect);
						patBodyBuf.writeByte(cell.effectParam);
					 chan++;
}
				 rownum++;
}

				patbuf.writeShort(patBodyBuf.length); 
				
				
				stream.writeBytes(patbuf,0,patbuf.byteLength);
				stream.writeBytes(patBodyBuf,0,patBodyBuf.byteLength);
			 i++;
}

		var instno:Int = 0;
	while( instno < xm.instruments.length){
				var inst:XMInstrument = xm.instruments[instno];
				var instrheadbuf:ByteArray = new ByteArray();
				instrheadbuf.endian = Endian.LITTLE_ENDIAN;
				var headerSize:Int = (inst.samples.length < 1) ? 29 : 263;
				instrheadbuf.writeUnsignedInt(headerSize);
				instrheadbuf.writeMultiByte(inst.name, 'us-ascii');
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeShort(inst.samples.length);
				if (inst.samples.length < 1) {
					stream.writeBytes(instrheadbuf,0,instrheadbuf.byteLength);
				}
				instrheadbuf.writeUnsignedInt(40); 
			var kma:Int = 0;
	while( kma < inst.keymapAssignments.length){
					instrheadbuf.writeByte(inst.keymapAssignments[kma]);
				 kma++;
}
			var p:Int = 0;
	while( p < 12){
					
					
					
					instrheadbuf.writeShort(0x1111);
					instrheadbuf.writeShort(0x2222);
				 p++;
}
			p = 0;
	while( p < 12){
					
					
					
					instrheadbuf.writeShort(0x0000);
					instrheadbuf.writeShort(0x0000);
				 p++;
}
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeByte(0); 
				instrheadbuf.writeShort(0); 

				
			i = 0;
	while( i < 22){
					instrheadbuf.writeByte(0x00);
				 i++;
}
				stream.writeBytes(instrheadbuf,0,instrheadbuf.byteLength);
			var s:Int = 0;
	while( s < inst.samples.length){
					var sample:XMSample = inst.samples[s];
					var sampleHeadBuf:ByteArray = new ByteArray();
					sampleHeadBuf.endian = Endian.LITTLE_ENDIAN;
					sampleHeadBuf.writeUnsignedInt(sample.data.length);
					sampleHeadBuf.writeUnsignedInt(sample.loopStart);
					sampleHeadBuf.writeUnsignedInt(sample.loopLength);
					sampleHeadBuf.writeByte(sample.volume);
					sampleHeadBuf.writeByte(sample.finetune);
					var sampleType:Int = (sample.loopsForward ? 1 : 0) |
						(sample.bitsPerSample == 16 ? 16 : 0);
					sampleHeadBuf.writeByte(sampleType);
					sampleHeadBuf.writeByte(sample.panning);
					sampleHeadBuf.writeByte(sample.relativeNoteNumber);
					sampleHeadBuf.writeByte(0); 
					sampleHeadBuf.writeMultiByte(sample.name, 'us-ascii');
					stream.writeBytes(sampleHeadBuf,0,sampleHeadBuf.byteLength);
				 s++;
}
			s = 0;
	while( s < inst.samples.length){
					var sample:XMSample = inst.samples[s];
					stream.writeBytes(sample.data,0,sample.data.byteLength);
				 s++;
}
			 instno++;
}
		}

		public function addInstrument(instrument:XMInstrument):Void {
			instruments.push(instrument);
		}

	}


