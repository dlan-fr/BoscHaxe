
package de.polygonal.ds
;
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.Collection;
	
	import de.polygonal.ds.TreeNode;
	import de.polygonal.ds.TreeIterator;
	
	import de.polygonal.ds.DListNode;
	import de.polygonal.ds.DLinkedList;
	
	
	class TreeNode implements Collection
	{	
		
		public var parent:TreeNode;
		
		
		public var children:DLinkedList;
		
		
		public var data:Dynamic;
		
		
		public function new(obj:Dynamic = null, parent:new = null)
		{
			data = obj;
			children = new DLinkedList();
			
			if (parent)
			{
				this.parent = parent;
				parent.children.append(this);
			}
		}
		
		
		public function size():Int
		{
			var c:Int = 1;
			var node:DListNode = children.head;
			while (node)
			{
				c += node.data.size;
				node = node.next;
			}
			return c;
		}
		
		
		public function isEmpty():Bool
		{
			return children.size == 0;
		}
		
		
		public function depth():Int
		{
			if (!parent) return 0;
			
			var node:TreeNode = this, c:Int = 0;
			while (node.parent)
			{
				c++;
				node = node.parent;
			}
			return c;
		}
		
		
		public function numChildrens():Int
		{
			return children.size;
		}
		
		
		public function numSiblings():Int
		{
			if (parent)
				return parent.children.size;
			return 0;
		}
		
		
		public function destroy():Void
		{
			while (children.head)
			{
				var node:TreeNode = children.head.data;
				children.removeHead();
				node.destroy();
			}
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
			var found:Bool = false;
			TreeIterator.preorder(this, function(node:TreeNode):Void
			{
				if (obj == node.data)
					found = true;
			});
			return found;
		}
		
		
		public function clear():Void
		{
			destroy();
		}
		
		
		public function getIterator():Iterator
		{
			return new TreeIterator(this);
		}
		
		
		public function getTreeIterator():TreeIterator
		{
			return new TreeIterator(this);
		}
		
		
		public function toArray():Array<Dynamic>
		{
			var a:Array<Dynamic> = [];
			TreeIterator.preorder(this, function(node:TreeNode):Void
			{
				a.push(node.data);
			});
			return a;
		}
		
		
		
		
		public function toString():String
		{
			var s:String = "[TreeNode > " + (parent == null ? "(root)" : "");
			
			if (children.size == 0)
				s += "(leaf)";
			else
				s += " has " + children.size + " child node" + (size > 1 || size == 0 ? "s" : "");
			
			s += ", data=" + data + "]";	
			
			return s;
		}
		
		
		public function dump():String
		{
			var s:String = "";
			TreeIterator.preorder(this, function(node:TreeNode):Void
			{
				var d:Int = node.depth;
				
			var i:Int = 0;
	while( i < d){
					if (i == d - 1)
						s += "+---";
					else
						s += "|    ";
				 i++;
}
				s += node + "\n";
			});
			return s;
		}
	}
