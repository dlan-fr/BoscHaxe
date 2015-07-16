
package de.polygonal.ds
;
	import de.polygonal.ds.DLinkedList;
	
	
	class LinkedStack
	{
		private var _list:DLinkedList;
		
		
		public function LinkedStack(list:DLinkedList = null)
		{
			if (list == null)
				_list = new DLinkedList();
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
				return _list.tail.data;
			else
				return null;
		}

		
		public function push(obj:Dynamic):Void
		{
			_list.append(obj);
		}

		
		public function pop():Void
		{
			_list.removeTail();
		}

		
		public function toString():String
		{
			return "[LinkedStack > " + _list + "]";
		}
		
		
		public function dump():String
		{
			return "LinkedStack:\n" + _list.dump();
		}
	}
