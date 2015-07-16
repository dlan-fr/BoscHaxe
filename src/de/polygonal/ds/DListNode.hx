
package de.polygonal.ds
;
	
	class DListNode
	{
		
		public var data:Dynamic;
		
		
		public var next:DListNode;
		
		
		public var prev:DListNode;
		
		
		public function DListNode(obj:Dynamic)
		{
			next = prev = null;
			data = obj;
		}
		
		
		public function insertAfter(node:DListNode):Void
		{
			node.next = next;
			node.prev = this;
			if (next) next.prev = node;
			next = node;
		}
		
		
		public function insertBefore(node:DListNode):Void
		{
			node.next = this;
			node.prev = prev;
			if (prev) prev.next = node;
			prev = node;
		}
		
		
		public function unlink():Void
		{
			if (prev) prev.next = next;
			if (next) next.prev = prev;
			next = prev = null;
		}
		
		
		public function toString():String
		{
			return "[DListNode, data=" + data + "]"
		}
	}
