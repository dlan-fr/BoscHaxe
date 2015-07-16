

package ocean.midi.model ;

	
	class ChannelItem extends MessageItem{
		public var _channel:Int;
		public var _command:Int;
		public var _data1:Int;
		public var _data2:Dynamic;

		public function new():Void{
			super();
		}
		
		public function channel():Int{
			return _channel;
		}
		
		public function channel(c:Int):Void{
			_channel = c&0x0F;
		}
		
		public function command():Int{
			return _command;
		}
		
		public function command(c:Int):Void{
			_command = c&0xF0;
			kind = _command;
		}
		

		
		public function data1():Int{
			return _data1;
		}
		
		public function data1(d:Int):Void{
			_data1 = d;
		}
		
		public function data2():Dynamic{
			return _data2;
		}
		
		public function data2(d:Dynamic):Void{
			_data2 = d;
		}
		
		override public function clone():MessageItem{
			var item:ChannelItem = new ChannelItem();
			item.kind = this.kind;
			item.timeline = this.timeline;
			item.channel = this.channel;
			item.command = this.command;
			item.data1 = this.data1;
			item.data2 = this.data2;
			return item;
		}
	}
	

