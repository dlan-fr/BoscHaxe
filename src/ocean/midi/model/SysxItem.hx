
package ocean.midi.model
;
	import flash.utils.ByteArray;
	import ocean.midi.MidiEnum;
	
	
	class SysxItem extends MessageItem
	{
		private var _data:ByteArray;
		public function new():Void{
			super();
			this.kind = MidiEnum.SYSTEM_EXCLUSIVE;
			_data = new ByteArray();
		}
		public function size():Int{
			if( _data != null)
				return _data.length;
			else
				return 0;
		}
		
		@:isVar public var data(get, set):ByteArray;
		
		public function get_data():ByteArray{
			_data.position = 0;
			return _data;
		}
		public function set_data(d:ByteArray):ByteArray{
			_data.position = 0 ;
			_data = new ByteArray();
			_data.writeBytes(d);			
			return _data;
		}
		override public function clone():MessageItem{
			var item:SysxItem = new SysxItem();
			item.timeline = this.timeline;
			item.data = this.data;
			return item;
		}
	}
