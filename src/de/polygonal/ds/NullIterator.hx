
package de.polygonal.ds
;
	import de.polygonal.ds.Iterator;
	
	
	class NullIterator implements Iterator
	{
		public function start():Void
		{
		}
		
		public function next():Dynamic
		{
			return null;
		}
	
		public function hasNext():Bool
		{
			return false;
		}
		
		public function data():Dynamic
		{
			return null;
		}
		
		public function data(obj:Dynamic):Void
		{
		}
	}


