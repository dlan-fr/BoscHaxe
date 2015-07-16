
package de.polygonal.ds;

	import de.polygonal.ds.Iterator;
	
	
	interface Collection
	{
		
		function contains(obj:Dynamic):Bool;
		
		
		function clear():Void;
		
		
		function getIterator():Iterator;
		
		
		function size():Int;
		
		
		function isEmpty():Bool;
		
		
		function toArray():Array<Dynamic>;
	}


