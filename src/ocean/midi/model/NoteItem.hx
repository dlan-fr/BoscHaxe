

package ocean.midi.model ;

	
	class NoteItem extends MessageItem{
		private var _pitch:Int;
		private var _velocity:Int;
		private var _duration:Int;
		private var _channel:Int;
		private static var _pitchName:Array<Dynamic> = ["C","Db","D","Eb","E","F","F#","G","G#","A","Bb","B"];
		
		public function new( c:Int=0 , p:Int=67 , v:Int=127 , d:Int=120, t:Int=0 ):Void{
			super();
			_channel = c&0x0F;
			_pitch = p&0x7F;
			_velocity = v&0x7F;
			_duration = d;
			
			_timeline = t;
		}
		
		@:isVar public var channel(get, set):Int;
		
		public function get_channel():Int{
			return _channel;
		}
		
		public function set_channel(c:Int):Int{
			_channel = c;
			return _channel;
		}
		
		@:isVar public var pitch(get, set):Int;
		
		public function get_pitch():Int{
			return _pitch;
		}
		
		@:isVar public var pitchName(get, never):String;
		
		public function get_pitchName():String{
			var level:Int = (Std.int(_pitch/12)>>0);
			var str:String = _pitchName[_pitch%12] + (level != 0 ? Std.string(level):"");
			return str;
		}
		
		public function set_pitch(p:Int):Int{
			_pitch = p;
			return _pitch;
		}
		
		@:isVar public var duration(get, set):Int;
		
		public function get_duration():Int{
			return _duration;
		}
		
		public function set_duration(d:Int):Int{
			_duration = d;
			return _duration;
		}
		
		@:isVar public var velocity(get, set):Int;
		
		public function get_velocity():Int{
			return _velocity;
		}
		
		public function set_velocity(v:Int):Int{
			_velocity = v;
			return _velocity;
		}
		
		override public function clone():MessageItem{
			var item:NoteItem = new NoteItem();
			item.kind = this.kind;
			item.timeline = this.timeline;
			item.channel = this.channel;
			item.duration = this.duration;
			item.pitch = this.pitch;
			item.velocity = this.velocity;
			return item;
		}
	}
	

