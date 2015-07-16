

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
		public function text():ByteArray{
			_text.position = 0;
			return _text;
		}
		
		public function text(t:ByteArray):Void{
			_text.position = 0;
			_text.length = 0;
			_text.writeBytes(t);
		}
		
		public function type():Int{
			return _type;
		}
		
		public function type(t:Int):Void{
			_type = t;
		}
		public function metaName():String{
			return MidiEnum.getMessageName(type);
		}
		public function size():Int{
			if( _text )
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
	

