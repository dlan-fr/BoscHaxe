
package de.polygonal.ds
;
	
	class SListNode
	{
		
		public var data:Dynamic;
		
		
		public var next:SListNode;
		
		
		public function SListNode(obj:Dynamic)
		{
			data = obj;
			next = null;
		}
		
		
		public function insertAfter(node:SListNode):Void
		{
			node.next = next;
			next = node;		
		}
		
		
		public function toString():String
		{
			return "[SListNode, data=" + data + "]";
		}
	}
