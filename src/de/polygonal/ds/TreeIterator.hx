
package de.polygonal.ds
;
	import de.polygonal.ds.Iterator;
	import de.polygonal.ds.LinkedStack;
	import de.polygonal.ds.TreeNode;
	import de.polygonal.ds.DListIterator;
	
	
	class TreeIterator implements Iterator
	{
		
		public static function preorder(node:TreeNode, process:Dynamic):Void
		{
			process(node);
			
			var itr:DListIterator = node.children.getIterator(cast(),DListIterator);
		;
	while( itr.valid())mic):Void
		{
			var itr:DListIterator = node.children.getIterator(cast(),DListIterator);
		;
	while( itr.valid())e = null)
		{
			this.node = node;
			reset();
			
			_stack = new LinkedStack();
			_stack.push(_childItr);
		}
		
		
		public function hasNext():Bool
		{
			if (_stack.size == 0)
				return false;
			else
			{
				var itr:DListIterator = _stack.peek();
				
				if (!itr.hasNext())
				{
					_stack.pop();
					return hasNext();
				}
				else
					return true;
			}
		}
		
		
		public function next():Dynamic
		{
			if (hasNext())
			{
				var itr:DListIterator = _stack.peek();
				var node:TreeNode = itr.next();
				
				if (node.children.size > 0)
					_stack.push(node.children.getIterator());
				
				return node;
			}
			else
				return null;
		}
		
		
		public function start():Void
		{
			root();
			childStart();
			
			while (_stack.size > 0) _stack.pop();
			_stack.push(_childItr);
		}
		
		
		public function data():Dynamic
		{
			return node.data;
		}
		
		public function data(obj:Dynamic):Void
		{
			node.data = obj;
		}
		
		
		public function childNode():TreeNode
		{
			return _childItr.data;
		}
		
		
		public function childData():Dynamic
		{
			return _childItr.data.data;
		}
		
		
		public function valid():Bool
		{
			return Boolean(node);
		}
		
		
		public function root():Void
		{
			if (node)
			{
				while (node.parent)
					node = node.parent;
			}
			reset();
		}
		
		
		public function up():Void
		{
			if (node) node = node.parent;
			reset();
		}
		
		
		public function down():Void
		{
			if (_childItr.valid())
			{
				node = _childItr.data;
				reset();
			}
		}
		
		
		public function nextChild():Void
		{
			_childItr.forth();
		}
		
		
		public function prevChild():Void
		{
			_childItr.back();
		}
		
		
		public function childStart():Void
		{
			_childItr.start();
		}
		
		
		public function childEnd():Void
		{
			_childItr.end();
		}
		
		
		public function childValid():Bool
		{
			return _childItr.valid();
		}
		
		
		public function appendChild(obj:Dynamic):Void
		{
			new TreeNode(obj, node);
			
			if (node.children.size == 1)
				childStart();
		}
		
		
		public function prependChild(obj:Dynamic):Void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.prepend(childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		
		public function insertBeforeChild(obj:Dynamic):Void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.insertBefore(_childItr, childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		
		public function insertAfterChild(obj:Dynamic):Void
		{
			var childNode:TreeNode = new TreeNode(obj, null);
			childNode.parent = node;
			node.children.insertAfter(_childItr, childNode);
			
			if (node.children.size == 1)
				childStart();
		}
		
		
		public function removeChild():Void
		{
			if (node && _childItr.valid())
			{
				_childItr.data.parent = null;
				node.children.remove(_childItr);
			}
		}
		
		private function reset():Void
		{
			if (node)
				_childItr = node.children.getListIterator();
			else
			{
				_childItr.node = null;
				_childItr.list = null;
			}
		}
		
		
		public function toString():String
		{
			var s:String = "[TreeIterator > pointing to: [V] " + node + " [H] " + (_childItr.data || "(leaf node)");
			return s;
		}
	}

