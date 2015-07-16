

package ocean.midi.model ;
	
	
	class MessageItem {
		public var _timeline:Int;
		public var _kind:Int;
		
		public var mark:Bool;
		
		public function new():Void{
			mark = true;
		}
		
		public function kind(k:Int):Void{
			_kind = k;
		}
		
		public function kind():Int{
			return _kind;
		}
		
		public function timeline():Int{
			return _timeline;
		}
		
		public function timeline(t:Int):Void{
			_timeline = t;
		}
			
		public function clone():MessageItem{
			var msgItem:MessageItem = new MessageItem();
			msgItem.kind = this.kind;
			msgItem.timeline = this.timeline;
			return msgItem;
		}
	}
	

