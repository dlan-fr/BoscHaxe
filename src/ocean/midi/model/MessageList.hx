

package ocean.midi.model ;
	import ocean.midi.MidiTrack;
	
	
	dynamic class MessageList extends Array{
				
		public function new():Void{
			super();
		}

		
		public function output():MidiTrack{
			var mt:MidiTrack = new MidiTrack();
			mt.msgList = this.clone();
			return mt;
		}
		
		
		public function input(mt:MidiTrack):Void{
			for each( var item:Dynamic in mt.msgList ){
				this.push( item.clone() );
			}
		}
		
		
		public function clone():MessageList{
			var msgList:MessageList = new MessageList();
			for each( var item:Dynamic in this ){
				msgList.push(item.clone());
			}
			return msgList;
		}
		
		
	}
	


