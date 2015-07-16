
package de.polygonal.ds
;
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.Collection;
	
	import de.polygonal.ds.DListNode;
	import de.polygonal.ds.DListIterator;
	
	
	class DLinkedList implements Collection
	{
		private var _count:Int;
		
		
		public var head:DListNode;
		
		
		public var tail:DListNode;
		
		
		public function new()
		{
			head = tail = null;
			_count = 0;
		}
		
		
		public function append(obj:Dynamic):DListNode
		{
			var node:DListNode = new DListNode(obj);
			if (head)
			{
				tail.insertAfter(node);
				tail = tail.next;
			}
			else
				head = tail = node;
			
			_count++;
			return node;
		}
		
		
		public function prepend(obj:Dynamic):DListNode
		{
			var node:DListNode = new DListNode(obj);
			
			if (head)
			{
				head.insertBefore(node);
				head = head.prev;
			}
			else
				head = tail = node;
			
			_count++;
			return node;
		}
		
		
		public function insertAfter(itr:DListIterator, obj:Dynamic):DListNode
		{
			if (itr.list != this) return null;
			if (itr.node)
			{
				var node:DListNode = new DListNode(obj);
				itr.node.insertAfter(node);
				
				if (itr.node == tail)
					tail = itr.node.next;
				
				_count++;
				return node;
			}
			else
				return append(obj);
		}
		
		
		public function insertBefore(itr:DListIterator, obj:Dynamic):DListNode
		{
			if (itr.list != this) return null;
			if (itr.node)
			{
				var node:DListNode = new DListNode(obj);
				itr.node.insertBefore(node);
				if (itr.node == head)
					head = head.prev;
				
				_count++;
				return node;
			}
			else
				return prepend(obj);
		}
		
		
		public function remove(itr:DListIterator):Bool
		{
			if (itr.list != this || !itr.node) return false;
			
			var node:DListNode = itr.node;
			
			if (node == head) 
				head = head.next;
			else
			if (node == tail)
				tail = tail.prev;
			
			itr.forth();
			node.unlink();
			
			if (head == null) tail = null;
			
			_count--;
			return true;
		}
		
		
		public function removeHead():Void
		{
			if (head)
			{
				head = head.next;
				
				if (head)
					head.prev = null;
				else
					tail = null
				
				_count--;
			}
		}
		
		
		public function removeTail():Void
		{
			if (tail)
			{
				tail = tail.prev;
				
				if (tail)
					tail.next = null;
				else
					head = null;
				
				_count--;
			}
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
			var node:DListNode = head;
			while (node)
			{
				if (node.data == obj) return true;
				node = node.next;
			}
			return false;
		}
		
		
		public function clear():Void
		{
			var node:DListNode = head;
			head = null;
			
			var next:DListNode;
			while (node)
			{
				next = node.next;
				node.next = node.prev = null;
				node = next;
			}
			_count = 0;
		}
		
		
		public function getIterator():Iterator
		{
			return new DListIterator(this, head);
		}
		
		
		public function getListIterator():DListIterator
		{
			return new DListIterator(this, head);
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
			var node:DListNode = head;
			while (node)
			{
				a.push(node.data);
				node = node.next;
			}
			return a;
		}
		
		
		public function toString():String
		{
			return "[DLinkedList > has " + size + " nodes]";
		}
		
		
		public function dump():String
		{
			if (head == null) return "DLinkedList, empty";
			
			var s:String = "DLinkedList, has " + _count + " node" + (_count == 1 ? "" : "s") + "\n|< Head\n";
			
			var itr:DListIterator = getListIterator();
			for (; itr.valid(); itr.forth())
				s += "\t" + itr.data + "\n";
			
			s += "Tail >|";
			
			return s;
		}
	}
