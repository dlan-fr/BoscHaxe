
package de.polygonal.ds
;
	import de.polygonal.ds.SLinkedList;
	
	
	class LinkedQueue
	{
		private var _list:SLinkedList;
		
		
		public function LinkedQueue(list:SLinkedList = null)
		{
			if (list == null)
				_list = new SLinkedList();
			else
				_list = list;
		}
		
		
		public function size():Int
		{
			return _list.size;
		}
		
		
		public function peek():Dynamic
		{
			if (_list.size > 0)
				return _list.head.data;
			return null;
		}
		
		
		public function clear():Void
		{
			_list.clear();
		}
		
		
		public function enqueue(obj:Dynamic):Void
		{
			_list.append(obj);
		}
		
		
		
		public function dequeue():Dynamic
		{
			if (_list.size > 0)
			{
				var front:Dynamic = _list.head.data;
				_list.removeHead();
				return front;
			}
			return null;
		}
		
		
		public function toString():String
		{
			return "[LinkedQueue > " + _list + "]";
		}
		
		
		public function dump():String
		{
			return "LinkedQueue:\n" + _list.dump();
		}
	}
