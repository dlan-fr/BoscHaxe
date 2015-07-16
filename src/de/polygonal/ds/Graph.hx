
package de.polygonal.ds
;
	import de.polygonal.ds.GraphNode;
	
	
	class Graph
	{
		
		public var nodes:Array<Dynamic>;
		
		private var _nodeCount:Int;
		private var _maxSize:Int;
		
		
		public function Graph(size:Int)
		{
			nodes = new Array<Dynamic>(_maxSize = size);
			_nodeCount = 0;
		}
		
		
		public function depthFirst(node:GraphNode, process:Dynamic):Void
		{
			if (!node) return;
			
			process(node);
			node.marked = true;
			
			var k:Int = node.numArcs, t:GraphNode;
		var i:Int = 0;
	while( i < k){
				t = node.arcs[i].node;
				if (!t.marked) depthFirst(t, process);
			 i++;
}
		}
		
		
		public function breadthFirst(node:GraphNode, process:Dynamic):Void
		{
			if (!node) return;
			
			var que:Array<Dynamic> = [];
			que.push(node);
			node.marked = true;
			
			var c:Int = 1;
			
			var t:GraphNode, u:GraphNode;
			while (c > 0)
			{
				process(t = que[0]);
				
				var arcs:Array<Dynamic> = t.arcs, k:Int = t.numArcs;
			var i:Int = 0;
	while( i < k){
					u = arcs[i].node;
					if (!u.marked)
					{
						u.marked = true;
						que.push(u);
						c++;
					}
				 i++;
}
				que.shift();
				c--;
			}
		}
		
		
		public function addNode(obj:Dynamic, i:Int):Bool
		{
			if (nodes[i]) return false;
			
			nodes[i] = new GraphNode(obj);
			_nodeCount++;
			return true;
		}
		
		
		public function removeNode(i:Int):Bool
		{
			var node:GraphNode = nodes[i];
			if(!node) return false;
			
			var arc:GraphArc;
		var j:Int = 0;
	while( j < _maxSize){
				var t:GraphNode = nodes[j];
				if (t && t.getArc(node)) removeArc(j, i);
			 j++;
}
			
			nodes[i] = null;
			_nodeCount--;
			return true;
		}
		
		
		public function getArc(from:Int, to:Int):GraphArc
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			if (node0 && node1) return node0.getArc(node1);
			return null;
		}
		
		
		public function addArc(from:Int, to:Int, weight:Int = 1):Bool
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			
			if (node0 && node1)
			{
				if (node0.getArc(node1)) return false;
			
				node0.addArc(node1, weight);
				return true;
			}
			return false;
		}
		
		
		public function removeArc(from:Int, to:Int):Bool
		{
			var node0:GraphNode = nodes[from];
			var node1:GraphNode = nodes[to];
			
			if (node0 && node1)
			{
				node0.removeArc(node1);
				return true;
			}
			return false;
		}
		
		
		public function clearMarks():Void
		{
		var i:Int = 0;
	while( i < _maxSize){
				var node:GraphNode = nodes[i];
				if (node) node.marked = false;
			 i++;
}
		}
		
		
		public function size():Int
		{
			return _nodeCount;
		}
		
		
		public function maxSize():Int
		{
			return _maxSize;
		}
		
		
		public function clear():Void
		{
			nodes = new Array<Dynamic>(_maxSize);
			_nodeCount = 0;
		}
	}
