

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
		
		public function channel():Int{
			return _channel;
		}
		
		public function channel(c:Int):Void{
			_channel = c;
		}
		
		public function pitch():Int{
			return _pitch;
		}
		
		public function pitchName():String{
			var level:Int = (_pitch/12>>0);
			var str:String = _pitchName[_pitch%12] + (level?level:"");
			return str;
		}
		
		public function pitch(p:Int):Void{
			_pitch = p;
		}
		
		public function duration():Int{
			return _duration;
		}
		
		public function duration(d:Int):Void{
			_duration = d;
		}
		
		public function velocity():Int{
			return _velocity;
		}
		
		public function velocity(v:Int):Void{
			_velocity = v;
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
	

