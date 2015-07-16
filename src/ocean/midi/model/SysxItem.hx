
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
			if( _data )
				return _data.length;
			else
				return 0;
		}
		public function data():ByteArray{
			_data.position = 0;
			return _data;
		}
		public function data(d:ByteArray):Void{
			_data.position = 0 ;
			_data.length = 0;
			_data.writeBytes(d);			
		}
		override public function clone():MessageItem{
			var item:SysxItem = new SysxItem();
			item.timeline = this.timeline;
			item.data = this.data;
			return item;
		}
	}
