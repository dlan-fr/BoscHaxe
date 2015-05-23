

package bigroom.input;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.events.MouseEvent;
	
	class KeyPoll
	{
		private var states:ByteArray;
		private var dispObj:DisplayObject;
		public var click:Bool = false;
		public var hasclicked:Bool = false;
		public var hasreleased:Bool = false;
		public var press:Bool = false;
		public var rightclick:Bool = false;
		public var hasrightclicked:Bool = false;
		public var rightpress:Bool = false;
		public var middleclick:Bool = false;
		public var hasmiddleclicked:Bool = false;
		public var hasmiddlereleased:Bool = false;
		public var middlepress:Bool = false;
		public var onscreen:Bool = true;
		public var mousewheel:Int = 0;
		
		public var shiftheld:Bool = false;
		public var ctrlheld:Bool = false;
		
		public function new( obj:DisplayObject )
		{
			states = new ByteArray();
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			dispObj = obj;
			dispObj.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
			dispObj.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
			dispObj.addEventListener( Event.ACTIVATE, activateListener, false, 0, true );
			dispObj.addEventListener( Event.DEACTIVATE, deactivateListener, false, 0, true );
			dispObj.addEventListener( MouseEvent.MOUSE_DOWN, mouseDownListener);
			dispObj.addEventListener( MouseEvent.MOUSE_UP, mouseUpListener );
			dispObj.addEventListener( MouseEvent.RIGHT_MOUSE_DOWN, mouserightDownListener);
			dispObj.addEventListener( MouseEvent.RIGHT_MOUSE_UP, mouserightUpListener );
			dispObj.addEventListener( MouseEvent.MIDDLE_MOUSE_DOWN, mousemiddleDownListener );
			dispObj.addEventListener( MouseEvent.MIDDLE_MOUSE_UP, mousemiddleUpListener );
			dispObj.addEventListener( MouseEvent.MOUSE_OUT, mouseOutHandler);       
			dispObj.addEventListener( MouseEvent.MOUSE_OVER, mouseOverHandler);
			dispObj.addEventListener( MouseEvent.MOUSE_WHEEL, mousewheelHandler);
		}
		
		public function mousewheelHandler( e:MouseEvent ):Void {
			mousewheel = e.delta;
		}
		
		public function mouseOverHandler( e:MouseEvent ):Void{
			onscreen = true;
		}
		
		public function mouseOutHandler( e:MouseEvent ):Void{
			onscreen = false;
		}
		
		public function releaseall():Void {
			press = false;
			click = false;
			hasclicked = false;
			hasreleased = true;
			middlepress = false;
			middleclick = false;
			hasmiddleclicked = false;
			hasmiddlereleased = true;
			rightpress = false;
			rightclick = false;
			hasrightclicked = false;
		}
		
		public function mouseUpListener( e:MouseEvent ):Void{
			press = false;
			
			click = false;
			hasclicked = false;
			hasreleased = true;
			
			if (shiftheld || middlepress) {
				
				middlepress = false;
				
				middleclick = false;
				hasmiddleclicked = false;
				hasmiddlereleased = true;
			}
			
			if (ctrlheld || rightpress) {
				
				rightpress = false;
				
				rightclick = false;
				hasrightclicked = false;
			}
		}
		
		public function mouseDownListener( e:MouseEvent ):Void {
			press = true;
			
			click = true;
			hasclicked = true;
			hasreleased = false;
			
			if (shiftheld) {
				
				middlepress = true;
				
				middleclick = true;
				hasmiddleclicked = true;
				hasmiddlereleased = false;
			}
			
			if (ctrlheld) {
				
				rightpress = true;
				
				rightclick = true;
				hasrightclicked = true;
			}
		}
		
		public function mouserightUpListener( e:MouseEvent ):Void{
			rightpress = false;
			
			rightclick = false;
			hasrightclicked = false;
		}
		
		public function mouserightDownListener( e:MouseEvent ):Void {
			rightpress = true;
			
			rightclick = true;
			hasrightclicked = true;
		}
		
		public function mousemiddleUpListener( e:MouseEvent ):Void{
			middlepress = false;
			
			middleclick = false;
			hasmiddleclicked = false;
			hasmiddlereleased = true;
		}
		
		public function mousemiddleDownListener( e:MouseEvent ):Void {
			middlepress = true;
			
			middleclick = true;
			hasmiddleclicked = true;
			hasmiddlereleased = false;
		}
		
		private function keyDownListener( ev:KeyboardEvent ):Void
		{
			#if html5
				var val:Int = states.__get(ev.keyCode >>> 3);
				states.__set(ev.keyCode >>> 3, val | 1 << (ev.keyCode & 7));
			#else
				var val:Int = states.get(ev.keyCode >>> 3);
				states.set(ev.keyCode >>> 3, val | 1 << (ev.keyCode & 7));
			#end
			
			

			if (ev.keyCode == 16) shiftheld = true;
			if (ev.keyCode == 17) ctrlheld = true;
			if (ev.keyCode == 27) {
				ev.stopImmediatePropagation();
				//ev.preventDefault();
			}
		}
		
		private function keyUpListener( ev:KeyboardEvent ):Void
		{
			#if html5
			
			var val:Int = states.__get(ev.keyCode >>> 3);
			
			states.__set(ev.keyCode >>> 3, val & ~(1 << (ev.keyCode & 7)));
			#else
			
			var val:Int = states.get(ev.keyCode >>> 3);
			
			states.set(ev.keyCode >>> 3, val & ~(1 << (ev.keyCode & 7)));

			#end
			//states[ ev.keyCode >>> 3 ] &= ~(1 << (ev.keyCode & 7));
			
			if (ev.keyCode == 16) shiftheld = false;
			if (ev.keyCode == 17) ctrlheld = false;
		}
		
		private function activateListener( ev:Event ):Void
		{
			 var i:Int = 0;
			while ( i < 8) {
						#if html5
							states.__set(i, 0);
						#else
							states[i] = 0;
						#end
					 ++i ;
			}
		}

		private function deactivateListener( ev:Event ):Void
		{
		 var i:Int = 0;
			while ( i < 8) {
						#if html5
							states.__set(i, 0);
						#else
							states[ i ] = 0;
						#end
					 ++i ;
			}
		}

		public function isDown( keyCode:Int ):Bool
		{
			#if html5
			return (states.__get(keyCode >>> 3) & (1 << (keyCode & 7))) != 0;
			#else
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) != 0;
			#end
		}
		
		public function isUp( keyCode:Int ):Bool
		{
			#if html5
			return ( states.__get(keyCode >>> 3 ) & (1 << (keyCode & 7)) ) == 0;
			#else
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) == 0;
			#end
		}
	}
