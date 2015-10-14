package co.sparemind.trackermodule ;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;


	class XMSample {
		
		public var volume:Int;
		public var finuetune:Int = 0;
		
		public var panning:Int = 0x80;
		public var relativeNoteNumber:Int = 0;
		var _name:ByteArray;
		public var data:ByteArray;
		public var bitsPerSample:Int = 8;
		public var finetune:Int = 0;
		public var loopStart:Int = 0;
		public var loopLength:Int = 0;
		public var loopsForward:Bool = false;

		public function new() {
			_name = new ByteArray();
			_name.endian = Endian.LITTLE_ENDIAN;
			this.name  = '                      ';
		}
		
		@:isVar public var name(get, set):String;
		
		public function get_name():String {
			return _name.toString();
		}
		public function set_name(unpadded:String):String {
			_name.clear();
			//_name.writeMultiByte(unpadded.substring(0,22), 'us-ascii');
			_name.writeUTFBytes(unpadded.substring(0,22));
		var i:Int = _name.length;
	while( i < 22){
				_name.writeByte(0x20); 
			 i++;
}
			return _name.toString();
		}
	}


