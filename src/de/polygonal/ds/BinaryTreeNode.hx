
package de.polygonal.ds
;
	
	class BinaryTreeNode
	{
		
		public static function preorder(node:BinaryTreeNode, process:Dynamic):Void
		{
			if (node)
			{
				process(node);
				
				if (node.left)
					BinaryTreeNode.preorder(node.left, process);
				
				if (node.right)
					BinaryTreeNode.preorder(node.right, process);
			}
		}
		
		
		public static function inorder(node:BinaryTreeNode, process:Dynamic):Void
		{
			if (node)
			{
				if (node.left)
					BinaryTreeNode.inorder(node.left, process);
				
				process(node);
				
				if (node.right)
					BinaryTreeNode.inorder(node.right, process);
			}
		}
		
		
		public static function postorder(node:BinaryTreeNode, process:Dynamic):Void
		{
			if (node)
			{
				if (node.left)
					BinaryTreeNode.postorder(node.left, process);
				
				if (node.right)
					BinaryTreeNode.postorder(node.right, process);
				
				process(node);
			}
		}
		
		
		public var left:BinaryTreeNode;
		
		
		public var right:BinaryTreeNode;
		
		
		public var parent:BinaryTreeNode;
		
		
		public var data:Dynamic;
		
		
		public function BinaryTreeNode(obj:Dynamic)
		{
			this.data = data;
			parent = left = right = null;
		}
		
		
		public function setLeft(obj:Dynamic):Void
		{
			if (!left)
			{
				left = new BinaryTreeNode(obj);
				left.parent = this;
			}
			else
				left.data = data;
		}
		
		
		public function setRight(obj:Dynamic):Void
		{
			if (!right)
			{
				right = new BinaryTreeNode(obj);
				right.parent = this;
			}
			else
				right.data = data;
		}
		
		
		public function isLeft():Bool
		{
			return this == parent.left;
		}
		
		
		
		public function isRight():Bool
		{
			return this == parent.right;
		}
		
		
		public function getDepth(node:BinaryTreeNode = null):Int
		{
			var left:Int = -1, right:Int = -1;
			
			if (node == null) node = this;
			
			if (node.left)
				left = getDepth(node.left);
			
			if (node.right)
				right = getDepth(node.right);
			
			return (Math.max(left, right) + 1);
		}
		
		
		public function count():Int
		{
			var c:Int = 1;
			
			if (left)
				c += left.count();
			
			if (right)
				c += right.count();
			
			return c;
		}
		
		
		public function destroy():Void
		{
			if (left)
				left.destroy();
			
			left = null;
			
			if (right)
				right.destroy();
			
			right = null;
		}
		
		
		public function toString():String
		{
			return "[BinaryTreeNode, data= " + data + "]";
		}
	}
