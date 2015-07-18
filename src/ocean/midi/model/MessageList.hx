

package ocean.midi.model ;
	import ocean.midi.MidiTrack;
	
	
	class MessageList implements Dynamic {
				
		private var _array:Array<Dynamic>;
		
		//@:arrayAccess doesn't seem to work in this case
		public inline function get(key:Int):Dynamic
		{
			return _array[key];
		}
		
		//@:arrayAccess doesn't seem to work in this case
		public inline function set(key:Int, value:Dynamic)
		{
			_array[key] = value;
		}
		
		
		public function new():Void{
			_array = new Array<Dynamic>();
			
		}

		
		public function output():MidiTrack{
			var mt:MidiTrack = new MidiTrack();
			mt.msgList = this.clone();
			return mt;
		}
		
		
		public function input(mt:MidiTrack):Void{
			for ( item in mt.msgList ) {
				this._array.push( item.clone());
			}
		}
		
		
		public function clone():MessageList{
			var msgList:MessageList = new MessageList();
			for ( item in this ) {
				msgList._array.push(item.clone());
			}
			return msgList;
		}
		
		
		
		public inline function iterator():Iterator<Dynamic>
		{
			return _array.iterator();
		}
		
		
	}
	


