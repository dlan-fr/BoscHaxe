

package ocean.midi.model ;
	import flash.utils.ByteArray;

	
	class RawItem {
		public var noteOn:Int;
		public var raw:ByteArray;
		public var timeline:Int;
		public var index:Int;
		public function new():Void{
			raw = new ByteArray();
			noteOn = 0;
		}
	}
	

