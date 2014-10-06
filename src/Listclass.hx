package ;
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	class Listclass  {
		public function new():Void {
		var i:Int = 0;
	while( i < 30){
				item.push("");
			 i++;
}
			clear();
		}
		
		public function clear():Void {
			numitems = 0;
			active = false;
			x = 0; y = 0;
			selection = -1;
		}
		
		public function init(gfx:Graphicsclass, xp:Int, yp:Int):Void {
			x = xp; y = yp; active = true;
			getwidth(gfx);
			h = numitems * gfx.linesize;
		}
		
		public function close():Void {
			active = false;
		}
		
		public function getwidth(gfx:Graphicsclass):Void {
			w = 0;
			var temp:Int;
		var i:Int = 0;
	while( i < numitems){
				temp = gfx.len(item[i]);
				if (w < temp) w = temp;
			 i++;
}
			w += 10;
		}
		
		public var item: Array<String> = new Array<String>();
		public var numitems:Int;
		public var active:Bool;
		public var x:Int;
		public var y:Int;
		public var w:Int;
		public var h:Int;
		public var type:Int;
		public var selection:Int;
	}

