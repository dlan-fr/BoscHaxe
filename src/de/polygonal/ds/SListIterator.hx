
package de.polygonal.ds
;
	import de.polygonal.ds.SListNode;
	import de.polygonal.ds.SLinkedList;
	
	
	class SListIterator implements Iterator
	{
		
		public var node:SListNode;
		
		 
		public var list:SLinkedList;
		
		
		public function new(list:SLinkedList = null, node:SListNode = null)
		{
			this.list = list;
			this.node = node;
		}
		
		
		public function next():Dynamic
		{
			if (hasNext())
			{
				var obj:Dynamic = node.data;
				node = node.next;
				return obj;
			}
			return null
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
		
		
		
		public function start():Void
		{
			if (list) node = list.head;
		}
		
		
		public function end():Void
		{
			if (list) node = list.tail;
		}
		
		
		public function forth():Void
		{
			if (node) node = node.next;
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
			return "{SListIterator: data=" + node.data + "}";
		}
	}
