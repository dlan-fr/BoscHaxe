

package ocean.midi.event ;
	import flash.events.Event;

	
	
	
	
	
	
	
	class MvcEvent extends Event{
		public static var APPLY_TRACK:String = "apply an other track";
		public static var UPDATE_VIEW:String = "update view";
		public function new(event:String):Void{
			super(event);
		}
	}
	

