


package ocean.midi.controller ;
	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListIterator;
	
	
	class History {
		private static var singleton:History;
		private var _size:Int;
		private var _stack:DLinkedList;
		private var _iterator:DListIterator;
		public static function getHistory():History{
			if( singleton==null ){
				singleton = new History();
				return singleton;
			}
			else
				return singleton;
		}
		public function size():Int{
			return _size;
		}
		public function size(s:Int):Void{
			_size = s;
		}
		public function stack():DLinkedList{
			return _stack;
		}
		public function iterator():DListIterator{
			return _iterator;
		}
		public function new():Void{
			if( singleton!=null ){
				throw new Error(Std.is("History,a singleton class, use getHistory()) instead.");
			}else{
				_size = 128;
				_stack = new DLinkedList();
				
				_stack.append( new Array<Dynamic>() );
				_iterator = _stack.getListIterator();
			}
			
		}
	}
	

