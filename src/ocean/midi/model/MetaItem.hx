

package ocean.midi.model ;
	import flash.utils.ByteArray;
	
	import ocean.midi.MidiEnum;
	
	
	class MetaItem extends MessageItem{
		public var _text:ByteArray;
		public var _type:Int;
		
		public function new():Void{
			super();
			
			_text = new ByteArray();
			_type = MidiEnum.END_OF_TRK;
			this.kind = MidiEnum.META;
		}
		
		@:isVar public var text(get, set):ByteArray;
		
		public function get_text():ByteArray{
			_text.position = 0;
			return _text;
		}
		
		public function set_text(t:ByteArray):ByteArray{
			_text.position = 0;
			_text.writeBytes(t);
			return _text;
		}
		
		@:isVar public var type(get, set):Int;
		
		public function get_type():Int{
			return _type;
		}
		
		public function set_type(t:Int):Int{
			_type = t;
			return _type;
		}
		public function metaName():String{
			return MidiEnum.getMessageName(type);
		}
		public function size():Int{
			if( _text != null )
				return _text.length;
			else
				return 0;
		}
		
		override public function clone():MessageItem{
			var item:MetaItem = new MetaItem();
			item.kind = this.kind;
			item.timeline = this.timeline;
			item.text = this.text;
			item.type = this.type;
			return item;
		}
	}
	

