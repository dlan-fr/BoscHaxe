package ;
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	class Barclass  {
		public function new():Void {
		var i:Int = 0;
	while( i < 8){
				channel.push( -1);
			 i++;
}
			clear();
		}
		
		public function clear():Void {
		var i:Int = 0;
	while( i < 8){
				channel[i] = -1;
			 i++;
}
		}
		
		public var channel: Array<Int> = new Array<Int>;
	}

