

package ocean.midi.controller ;
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import ocean.midi.model.MetaItem;
	import ocean.midi.model.NoteItem;
	
	import ocean.midi.model.MessageItem;
	import ocean.midi.model.MessageList;
	import ocean.midi.MidiEnum;
	import ocean.midi.InvalidMidiError;
	import ocean.midi.event.MvcEvent;
	import ocean.midi.controller.History;
	
	
	class TrackEditor extends EventDispatcher{
		
		private var _activeMsgList:MessageList;
		private var _globalHistory:History;
		private var _stack:DLinkedList;
		private var _itr:DListIterator;
		public var pending:Array<Dynamic>;

		
		public function new(messageList:MessageList=null):Void{
			
			if( messageList != null ){
				_activeMsgList = messageList;
			}
			else{
				_activeMsgList = new MessageList();
			}
			_globalHistory = History.getHistory();
			_stack = _globalHistory.stack;
			
			_itr = _globalHistory.iterator;
		}
		
		
		public function activeMsgList(msgList:MessageList):Void{
			if( msgList != null ){
				_activeMsgList = msgList;
			}
			else{
				throw new InvalidMidiError("set midi message list error, midi Std.is(track,invalid"));
			}
			dispatchEvent( new MvcEvent( MvcEvent.APPLY_TRACK ) );
		}
		
		
		public function activeMsgList():MessageList{
			return _activeMsgList;
		}

		private function _history():Int{
			return _globalHistory.size;
		}
		
		
		public function copy( list:MessageList ):MessageList{
			var msgList:MessageList = new MessageList();
			
			var min:Int = 0;
			for each( var item:MessageItem in list ){
				if( item.mark ){
					min = min<item.timeline ? min : item.timeline;
					
					msgList.push(item.clone());
				}
			}
			
			
			for each( item in msgList ){
				item.timeline -= min;
			}
			return msgList;
		}
		
		
		public function cut( list:MessageList ):MessageList{
			var msgList:MessageList = copy(list);
			erase(list);
			return msgList;
		}
		

		
		public function applyFilter( selected:MessageList , filter:Dynamic , ...args ):Void{
			var after:Array<Dynamic> = new Array<Dynamic>();
			var temp:MessageItem;
			var item:MessageItem;
			
			
			
			
			var selfFeedbackSecurity:Array<Dynamic> = new Array<Dynamic>();
			for each( item in selected ){
				temp = item.clone();
				
				item.mark = false;
				after.push( item );
				selfFeedbackSecurity.push(temp);
			}
			
			
		 var i:Int=selfFeedbackSecurity.length ;
	while( i>0 ){
					temp = selfFeedbackSecurity[i-1];
					
					filter( temp , args );
					_activeMsgList.push(temp);
					after.push( temp );
			 i-- ;
}
			execute(after);
		}
		

		
		public function pan( list:MessageList , v:Int=0 , h:Int=0 ):Void{
			if( v!=0 || h!=0 ){
				var filter:Dynamic = function(item:MessageItem , args:Array<Dynamic> ):Void{
					
					if( ( item.timeline+args[1] )<0 )
						item.timeline = 0;
					else
						item.timeline += args[1];
					if( Std.is(item,NoteItem )){
						
						if( ((cast(item,NoteItem)).pitch+args[0])>0x7F )
							(cast(item,NoteItem)).pitch = 0x7F;
						
						else if(((cast(item,NoteItem)).pitch+args[0])<0x00 )
							(cast(item,NoteItem)).pitch = 0x00;
						
						else
							(cast(item,NoteItem)).pitch += args[0];
						
						
					}
					
				}
				this.applyFilter( list , filter , v , h );
			}
		}

		
		
		public function insertMessage( atTime:Int , item:MessageItem ):Void{
			
			var after:Array<Dynamic> = new Array<Dynamic>();
			var temp:MessageItem;

			temp = item.clone();
			temp.timeline = atTime;
			temp.mark = true;
			after.push(temp);
			
			
			var tempList:MessageList = new MessageList();
			tempList.push(temp);
			
			
			var slide:Int = (Std.is(temp,NoteItem)) ? (cast(temp,NoteItem)).duration : 0;
			
			
			

			if( Std.is(temp,NoteItem )){

				
				for each( var it:Dynamic in _activeMsgList ){
					
					if( it.mark ){
						if( it.timeline>=atTime ){

							
							temp = it.clone();
							temp.timeline += slide;
							
							
							temp.mark = true;
							
							
							it.mark = false;
							
							
							tempList.push(temp);
							
							
							after.push(temp);
							
							
							after.push(it);
							
						}
					}
				}
			}
			
			for each( var _it:Dynamic in tempList){
				_activeMsgList.push(_it);
			}
		
			execute(after);
		}
		
		 public function pasteMessage( atTime:Int , item:MessageItem ):Void{
			
			var after:Array<Dynamic> = new Array<Dynamic>();
			var temp:MessageItem;
			temp = item.clone();
			temp.timeline = atTime;
			temp.mark = true;
			after.push(temp);
			
			
			if( Std.is(temp,NoteItem )){
		
				for each( var it:MessageItem in _activeMsgList ){
					if( it.kind==MidiEnum.NOTE && it.timeline>=atTime && it.timeline<(atTime+(cast(temp,NoteItem)).duration) ){
						
						it.mark = false;
						after.push(it);
						
					}
				}
			}
			
			_activeMsgList.push(temp);
			
			execute(after);
		}
		
		
		public function mergeMessage( atTime:Int , item:MessageItem ):Void{
			
			var after:Array<Dynamic> = new Array<Dynamic>();
			var temp:MessageItem;
			temp = item.clone();
			temp.timeline = atTime;
			temp.mark = true;
			_activeMsgList.push(temp);
			after.push(temp);
			execute(after);
		}
		
		
		public function eraseMessage( item:MessageItem ):Void{
			var after:Array<Dynamic> = new Array<Dynamic>();
			item.mark = false;
			after.push(item);
			execute(after);
		}
		
		
		public function insert(atTime:Int , list:MessageList):Void{
			
			var after:Array<Dynamic> = new Array<Dynamic>();
			var slide:Int=0;
			var temp:MessageItem;
			var tempList:MessageList = new MessageList();
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					
					temp = item.clone();
					
					
					temp.timeline += atTime;
					
					if( Std.is(item,NoteItem )){
						
						
						slide = ( slide > (temp.timeline+(cast(temp,NoteItem)).duration)) ? slide : (temp.timeline+(cast(temp,NoteItem)).duration) ;
					}
					
					
					temp.mark = true;
					
					
					tempList.push(temp);
					
					
					after.push(temp);
				}
			}
			
			
			slide -= atTime;
			
			
			for each( item in _activeMsgList ){
				if( item.mark ){
					if( item.timeline>=atTime ){
						
						
						temp = item.clone();
						temp.timeline += slide;
						
						
						temp.mark = true;
						
						
						item.mark = false;
						
						
						tempList.push(temp);
						
						
						after.push(temp);
						
						
						after.push(item);
						
					}
				}
			}
			
			
			for each( item in tempList){
				_activeMsgList.push(item);
			}
			
			execute(after);
		}
		
		
		public function paste(atTime:Int , list:MessageList):Void{
			
			var after:Array<Dynamic> = new Array<Dynamic>();
			var max:Int=0;
			var temp:MessageItem;
			var tempList:MessageList = new MessageList();
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					
					temp = item.clone();
					
					
					temp.timeline += atTime ;
					
					if( item.kind == MidiEnum.NOTE ){
						
						
						max = ( max > (temp.timeline+(cast(temp,NoteItem)).duration)) ? max : (temp.timeline+(cast(temp,NoteItem)).duration) ;
					}else{
						max = max > temp.timeline ? max : temp.timeline;
					}
					
					
					temp.mark = true;
					
					
					tempList.push(temp);
					
					
					after.push(temp);
				}
			}
			
			
			for each( item in _activeMsgList ){
				if( item.mark ){
					if( item.kind==MidiEnum.NOTE && item.timeline>=atTime && item.timeline<max ){
						
						
						item.mark = false;
						
						
						after.push(item);
					}
				}
			}
			
			for each( item in tempList){
				_activeMsgList.push(item);
			}
			
			execute(after);
		}
		
		
		public function merge(atTime:Int , list:MessageList):Void{
			var max:Int = 0;
			var after:Array<Dynamic> = new Array<Dynamic>();
			var temp:MessageItem;
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					
					temp = item.clone();
					
					
					temp.timeline += atTime ;
					
					if( item.kind == MidiEnum.NOTE ){
						
						
						max = ( max > (temp.timeline+(cast(temp,NoteItem)).duration)) ? max : (temp.timeline+(cast(temp,NoteItem)).duration) ;
					}else{
						max = max > temp.timeline ? max : temp.timeline;
					}
					
					
					item.mark = true;
					
					
					_activeMsgList.push(temp);
					
					
					after.push(temp);
				}
			}
			
			execute(after);
		}
		
		
		public function erase( list:MessageList ):Void{
			var after:Array<Dynamic> = new Array<Dynamic>();
			for each( var item:MessageItem in list ){
				if( item.mark ){
					
					
					item.mark = false;
					after.push(item);
				}
			}
			execute(after);
		}
		
	
		
		private function execute( after:Array<Dynamic> ):Void{
			
			
			update( after );
			
			
			_stack.insertAfter( _itr , after );
			_itr.forth();
			
			
			_stack.tail = _itr.node;
			_stack.tail.next = null;
			
			
			_itr.end();
		
			
			if( _stack.size >_history+1 ){
				_stack.head.next.unlink();
			}
		}

		
		public function undo():Void{
			if( _itr.node != _stack.head ){
				
				for each( var item:MessageItem in _itr.data ){
					item.mark = !item.mark;
				}
				
				update( _itr.data );
				
				_itr.back();
			}
		}
		
		
		public function redo():Void{
			if( _itr.node!= _stack.tail ){
				
				_itr.forth();
				
				for each( var item:MessageItem in _itr.data ){
					item.mark = !item.mark;
				}
				
				update(_itr.data );
			}
		}
		
		
		private function update( arr:Array<Dynamic> ):Void{
			pending = arr;
			dispatchEvent( new MvcEvent( MvcEvent.UPDATE_VIEW ) );
			
			
			
		}

	}
	

