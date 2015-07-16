
package de.polygonal.ds
;
	import de.polygonal.ds.DListNode;
	import de.polygonal.ds.DLinkedList;
	
	
	class DListIterator implements Iterator
	{
		
		public var node:DListNode;
		
		
		public var list:DLinkedList;
		
		
		public function new(list:DLinkedList, node:DListNode = null)
		{
			this.list = list;
			this.node = node;
		}
		
		
		public function start():Void
		{
			node = list.head;
		}
		
		
		public function next():Dynamic
		{
			if (hasNext())
			{
				var obj:Dynamic = node.data;
				node = node.next;
				return obj;
			}
			return null;
		}
		
		
		public function hasNext():Bool
		{
			return Boolean(node);
		}
		
		
		public function data():Dynamic
		{
			if (node) return node.data;
			return null;
		}
		
		public function data(obj:Dynamic):Void
		{
			node.data = obj;
		}
		
		
		public function end():Void
		{
			node = list.tail;
		}
		
		
		public function forth():Void
		{
			if (node) node = node.next;
		}
		
		
		public function back():Void
		{
			if (node) node = node.prev;
		}
		
		
		public function valid():Bool
		{
			return Boolean(node);
		}
		
		
		public function remove():Void
		{
			list.remove(this);
		}
		
		
		public function toString():String
		{
			return "{DListIterator, data=" + (node ? node.data : "null") + "}";
		}
	}
