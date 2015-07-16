
package de.polygonal.ds
;
	import de.polygonal.ds.GraphArc;
	
	
	class GraphNode
	{
		
		public var data:Dynamic;
		
		
		public var arcs:Array<Dynamic>;
		
		
		public var marked:Bool;
		
		private var _arcCount:Int = 0;
		
		
		public function GraphNode(obj:Dynamic)
		{
			this.data = obj;
			arcs = [];
			_arcCount = 0;
			marked = false;
		}
		
		
		public function addArc(target:GraphNode, weight:Float):Void
		{
			arcs.push(new GraphArc(target, weight));
			_arcCount++;
		}

		
		public function removeArc(target:GraphNode):Bool
		{
		var i:Int = 0;
	while( i < _arcCount){
				if (arcs[i].node == target)
				{
					arcs.splice(i, 1);
					_arcCount--;
					return true;
				}
			 i++;
}
			return false;
		}
		
		
		public function getArc(target:GraphNode):GraphArc
		{
		var i:Int = 0 ;
	while( i < _arcCount){
				var arc:GraphArc = arcs[i];
				if (arc.node == target) return arc;
			 i++;
}
			return null;
		}
		
		
		public function numArcs():Int
		{
			return _arcCount;
		}
	}
