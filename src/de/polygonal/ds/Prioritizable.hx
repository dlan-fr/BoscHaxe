
package de.polygonal.ds
;
	
	class Prioritizable
	{
		public var priority:Int;
		
		public function Prioritizable()
		{
			priority = -1;
		}
		
		public function toString():String
		{
			return "[Prioritizable, priority=" + priority + "]";
		}
	}
