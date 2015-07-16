
package de.polygonal.ds
;
	
	class GraphArc
	{
		
		public var node:GraphNode;
		
		
		public var weight:Float
		
		
		public function GraphArc(node:GraphNode, weight:Float = 1)
		{
			this.node = node;
			this.weight = weight;
		}
	}
