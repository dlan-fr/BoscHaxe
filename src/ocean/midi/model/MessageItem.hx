

package ocean.midi.model ;
	
	
	class MessageItem {
		public var _timeline:Int;
		public var _kind:Int;
		
		public var mark:Bool;
		
		public function new():Void{
			mark = true;
		}
		
		@:isVar public var kind(get, set):Int;
		
		public function set_kind(k:Int):Int{
			_kind = k;
			return _kind;
		}
		
		public function get_kind():Int{
			return _kind;
		}
		
		@:isVar public var timeline(get, set):Int;
		
		public function get_timeline():Int{
			return _timeline;
		}
		
		public function set_timeline(t:Int):Int{
			_timeline = t;
			return _timeline;
		}
			
		public function clone():MessageItem{
			var msgItem:MessageItem = new MessageItem();
			msgItem.kind = this.kind;
			msgItem.timeline = this.timeline;
			return msgItem;
		}
	}
	

