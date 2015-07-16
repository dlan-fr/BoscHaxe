
package de.polygonal.ds
;
	import de.polygonal.ds.Collection;
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.SListNode;
	import de.polygonal.ds.SListIterator;
	
	
	class SLinkedList implements Collection
	{
		private var _count:Int;
		
		
		public var head:SListNode;
		
		
		public var tail:SListNode;
		
		
		public function new()
		{
			head = tail = null;
			_count = 0;
		}
		
		
		public function append(obj:Dynamic):SListNode
		{
			var node:SListNode = new SListNode(obj);
			if (head)
			{
				tail.next = node;
				tail = node;
			}
			else
				head = tail = node;
			
			_count++;
			return node;
		}
		
		
		public function prepend(obj:Dynamic):SListNode
		{
			var node:SListNode = new SListNode(obj);
			
			if (head)
			{
				node.next = head;
				head = node;
			}
			else
				head = tail = node;
			
			_count++;
			return node;
		}
		
		
		public function insertAfter(itr:SListIterator, obj:Dynamic):SListNode
		{
			if (itr.list != this) return null;
			if (itr.node)
			{
				var node:SListNode = new SListNode(obj);
				itr.node.insertAfter(node);
				if (itr.node == tail)
					tail = itr.node.next;
				
				_count++;
				return node;
			}
			else
				return append(obj);
		}
		
		
		public function remove(itr:SListIterator):Bool
		{
			if (itr.list != this || !itr.node) return false;
			
			var node:SListNode = head;
			if (itr.node == head)
			{
				itr.forth();
				removeHead();
			}
			else
			{
				while (node.next != itr.node) node = node.next;
				itr.forth();
				if (node.next == tail) tail = node;
				node.next = itr.node;
			}
			_count--;
			return true;
		}
		
		
		public function removeHead():Void
		{
			if (!head) return;
			
			if (head == tail)
				head = tail = null;
			else
			{
				var node:SListNode = head;
				
				head = head.next;
				node.next = null;
				if (head == null) tail = null;
			}
			_count--;
		}
		
		
		public function removeTail():Void
		{
			if (!tail) return;
			
			if (head == tail)
				head = tail = null;
			else
			{
				var node:SListNode = head;
				while (node.next != tail)
					node = node.next;
				
				tail = node;
				node.next = null;
			}
			_count--;
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
			var node:SListNode = head;
			while (node)
			{
				if (node.data == obj) return true;
				node = node.next;
			}
			return false;
		}
		
		
		public function clear():Void
		{
			var node:SListNode = head;
			head = null;
			
			var next:SListNode;
			while (node)
			{
				next = node.next;
				node.next = null;
				node = next;
			}
			_count = 0;
		}
		
		
		public function getIterator():Iterator
		{
			return new SListIterator(this, head);
		}
		
		
		public function getListIterator():SListIterator
		{
			return new SListIterator(this, head);
		}
		
		
		public function size():Int
		{
			return _count;
		}
		
		
		public function isEmpty():Bool
		{
			return _count == 0;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			var a:Array<Dynamic> = [];
			var node:SListNode = head;
			while (node)
			{
				a.push(node.data);
				node = node.next;
			}
			return a;
		}
		
		
		public function toString():String
		{
			return "[SlinkedList, size=" + size + "]";
		}
		
		
		public function dump():String
		{
			if (!head)
				return "SLinkedList: (empty)";
			
			var s:String = "SLinkedList: (has " + _count + " node" + (_count == 1 ? ")" : "s") + "\n|< Head\n";
			
			var itr:SListIterator = getListIterator();
			for (; itr.valid(); itr.forth())
				s += "\t" + itr.data + "\n";
			
			s += "Tail >|";
			
			return s;
		}
	}
