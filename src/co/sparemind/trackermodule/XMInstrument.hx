package co.sparemind.trackermodule ;
	class XMInstrument {
		import flash.utils.ByteArray;
		import flash.utils.Endian;

		var _name:ByteArray;
		public var volume:Int = 40;
		public var samples: Array<XMSample> = new Array<XMSample>();
		public var keymapAssignments: Array<Int> = Array<Int>([
				0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,0,0
				]);

		public function new() {
			_name = new ByteArray();
			_name.endian = Endian.LITTLE_ENDIAN;
			this.name  = '                      ';
		}

		public function addSample(sample:XMSample):Void {
			samples.push(sample);
		}

		
		public function addSamples(extraSamples: Array<XMSample>):Void {
			samples = samples.concat(extraSamples).slice(0,16);
		}

		public function name():String {
			return _name.toString();
		}
		public function name(unpadded:String):Void {
			_name.clear();
			_name.writeMultiByte(unpadded.slice(0,22), 'us-ascii');
		var i:Int = _name.length;
	while( i < 22){
				_name.writeByte(0x20); 
			 i++;
}
		}
	}



