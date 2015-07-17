

package ocean.midi.model ;

	
	class ChannelItem extends MessageItem{
		public var _channel:Int;
		public var _command:Int;
		public var _data1:Int;
		public var _data2:Dynamic;

		public function new():Void{
			super();
		}
		
		@:isVar public var channel(get, set):Int;
		
		public function get_channel():Int{
			return _channel;
		}
		
		public function set_channel(c:Int):Int{
			_channel = c & 0x0F;
			return _channel;
		}
		
		@:isVar public var command(get, set):Int;
		
		public function get_command():Int{
			return _command;
		}
		
		public function set_command(c:Int):Int{
			_command = c&0xF0;
			kind = _command;
			_command;
		}
		
		@:isVar public var data1(get, set):Int;
		
		public function get_data1():Int{
			return _data1;
		}
		
		public function set_data1(d:Int):Int{
			_data1 = d;
			return _data1;
		}
		
		@:isVar public var data2(get, set):Dynamic;
		
		public function get_data2():Dynamic{
			return _data2;
		}
		
		public function set_data2(d:Dynamic):Dynamic{
			_data2 = d;
			return _data2;
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
	

