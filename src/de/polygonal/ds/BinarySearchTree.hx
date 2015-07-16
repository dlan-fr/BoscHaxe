
package de.polygonal.ds
;
	import de.polygonal.ds.Collection;
	import de.polygonal.ds.NullIterator;
	import de.polygonal.ds.BinaryTreeNode;
	
	
	class BinarySearchTree implements Collection
	{
		
		public var root:BinaryTreeNode;
		
		private var _compare:Dynamic;
		
		
		public function new(compare:Dynamic = null)
		{
			root = null;
			
			if (compare == null)
			{
				_compare = function(a:Int, b:Int):Int
				{
					return a - b;
				}
			}
			else
				_compare = compare;
		}
		
		
		public function insert(obj:Dynamic):Void
		{
			var cur:BinaryTreeNode = root;
			
			if (!root) root = new BinaryTreeNode(obj);
			else
			{
				while (cur)
				{
					if (_compare(obj, cur.data) < 0)
					{
						if (cur.left)
							cur = cur.left
						else
						{
							cur.setLeft(obj);
							return;
						}
					}
					else
					{
						if (cur.right)
							cur = cur.right;
						else
						{
							cur.setRight(obj);
							return;
						}
					}
				}
			}
		}
		
		
		public function find(obj:Dynamic):BinaryTreeNode
		{
			var cur:BinaryTreeNode = root, i:Int;
			while (cur)
			{
				i = _compare(obj, cur.data);
				if (i == 0) return cur;
				cur = i < 0 ? cur.left : cur.right;
			}
			return null;
		}
		
		
		public function remove(node:BinaryTreeNode):Void
		{
			if (node.left && node.right)
			{
				var t:BinaryTreeNode = node;
				while (t.right) t = t.right;
				
				if (node.left == t)
				{
					t.right = node.right;
					t.right.parent = t;
				}
				else
				{
					t.parent.right = t.left;
					if (t.left) t.left.parent = t.parent;
					
					t.left = node.left;
					t.left.parent = t;
					t.right = node.right;
					t.right.parent = t;
				}
				
				if (node == root)
					root = t;
				else
				{
					if (node.isLeft())
						node.parent.left = t;
					else
						node.parent.right = t;
				}
				
				t.parent = node.parent;
				node.left = null;
				node.right = null;
				node = null;
			}
			else
			{
				var child:BinaryTreeNode = null;
				
				if (node.left)
					child = node.left;
				else
				if (node.right)
					child = node.right;
					
				if (node == root)
					root = child;
				else
				{
					if (node.isLeft())
						node.parent.left = child;
					else
						node.parent.right = child;
				}
				
				if (child) child.parent = node.parent;
				node.left = node.right = null;
				node = null;
			}
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
			if (find(obj)) return true;
			return false;
		}
		
		
		public function clear():Void
		{
			if (root)
			{
				root.destroy();
				root = null;
			}
		}
		
		
		public function getIterator():Iterator
		{
			return new NullIterator();
		}
		
		
		public function size():Int
		{
			if (!root) return 0;
			return root.count();
		}
		
		
		public function isEmpty():Bool
		{
			if (root)
				return root.count() == 0;
			else
				return true;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			var a:Array<Dynamic> = [];
			var copy:Dynamic = function(node:BinaryTreeNode):Void
			{
				a.push(node.data);
			}
			BinaryTreeNode.inorder(root, copy);
			return a;
		}
		
		
		public function toString():String
		{
			return "[BST, size=" + size + "]";
		}
		
		
		public function dump():String
		{
			var s:String = "";
			var dumpNode:Dynamic = function (node:BinaryTreeNode):Void
			{
				s += node + "\n";
			}
			BinaryTreeNode.inorder(root, dumpNode);
			return s;
		}
	}
