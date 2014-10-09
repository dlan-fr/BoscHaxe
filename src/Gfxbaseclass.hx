package;

	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.display.Stage;
	import flash.text.Font;
	
	@:font("graphics/FFF.ttf") class DefaultFont extends Font {}
	
	class Gfxbaseclass extends Sprite {
		
		public function new()
		{
		  super();
		  
		  Font.registerFont (DefaultFont);
		}
		
		public function initgfx():Void {
			
			screenscale = 2;
			
			screenwidth = 384; screenheight = 240;
			screenwidthmid = Std.int(screenwidth / 2); screenheightmid = Std.int(screenheight / 2);
			screenviewwidth = screenwidth; screenviewheight = screenheight;
			linesize = 10; patternheight = 12; patterncount = 54;
			setzoomlevel(4);
			pianorollposition = linesize * 10;
			
			fontsize.push(0); fontsize.push(0); fontsize.push(0); fontsize.push(0);		
			fontsize.push(0); fontsize.push(0); fontsize.push(0); fontsize.push(0);		
		
			fontsize[0] = 8;
			fontsize[1] = 16;
			fontsize[2] = 24;
			fontsize[3] = 32;
			fontsize[4] = 48;
			
			icons_rect = new Rectangle(0, 0, 16, 16);
			trect = new Rectangle(); 
			tpoint = new Point();
			tbuffer = new BitmapData(1, 1, true);
			ct = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 1); 
			tempicon = new BitmapData(16, 16, false, 0x000000);
			
			backbuffer = new BitmapData(384, 240, false, 0x000000);
			screenbuffer = new BitmapData(384, 240, false, 0x000000);
			
		i = 0;
	while( i < 400){
				pal.push(new Paletteclass());
			 i++;
}
			
			buttonpress = 0;
			
			screen = new Bitmap(screenbuffer);
			screen.width = screenwidth * 2;
			screen.height = screenheight * 2; 
			screen.x = 0;
			screen.y = 0; 
			addChild(screen);
		}
		
		public function setzoomlevel(t:Int):Void {
			zoom = t;
			patternwidth = 22 + (zoom * 8);
		}
		
		public function changewindowsize(t:Int):Void {
			screenscale = t;
		
			
			if (stage != null) {
				stage.resize((screenwidth * t) + 18, (screenheight * t) + 45);
				 /*stage.width = 
				 stage.height =
				 stage.res
				//stage.nativeWindow.width = 
				//stage.nativeWindow.height = */
			}
		}

		public function settrect(x:Int, y:Int, w:Int, h:Int):Void {
			trect.x = x;
			trect.y = y;
			trect.width = w;
			trect.height = h;
		}

		public function settpoint(x:Int, y:Int):Void {
			tpoint.x = x;
			tpoint.y = y;
		}
		
		public function makeiconarray():Void {
		var i:Int = 0;
			while( i < 6){
				var t:BitmapData = new BitmapData(16, 16, true, 0x000000);
				var temprect:Rectangle = new Rectangle(i * 16, 0, 16, 16);	
				t.copyPixels(buffer, temprect, tl);
				icons.push(t);
			 i++;
		}
		}	
		
		
		public function drawline(x1:Int, y1:Int, x2:Int, y2:Int, col:Int):Void {
			if (x1 > x2) {
				drawline(x2, y1, x1, y2, col);
			}else if (y1 > y2) {
				drawline(x1, y2, x2, y1, col);
			}else {
				tempshape.graphics.clear();
				tempshape.graphics.lineStyle(1, RGB(pal[col].r, pal[col].g, pal[col].b));
				tempshape.graphics.lineTo(x2 - x1, y2 - y1);
				
				shapematrix.translate(x1, y1);
				backbuffer.draw(tempshape, shapematrix);
				shapematrix.translate(-x1, -y1);
			}
		}

		public function drawbox(x1:Int, y1:Int, w1:Int, h1:Int, col:Int):Void {
			settrect(x1, y1, w1, 1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1, y1 + h1 - 1, w1, 1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1, y1, 1, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
			settrect(x1 + w1 - 1, y1, 1, h1); backbuffer.fillRect(trect, RGB(pal[col].r, pal[col].g, pal[col].b));
		}

		public function cls():Void {
			fillrect(0, 0, 384, 240, 1);
		}

		public function fillrect(x1:Int, y1:Int, w1:Int, h1:Int, t:Int):Void {
			settrect(x1, y1, w1, h1);
			backbuffer.fillRect(trect, Std.int(RGB(pal[t].r, pal[t].g, pal[t].b)));
		}
		
		public function drawbuffericon(x:Int, y:Int, t:Int):Void {
			buffer.copyPixels(icons[t], icons_rect, new Point(x, y));
		}

		public function drawicon(x:Int, y:Int, t:Int):Void {
			backbuffer.copyPixels(icons[t], icons_rect, new Point(x, y),icons[t], new Point(x, y),true);
		}
		
		
		public function initfont():Void {			
			tf_1.embedFonts = true;
			tf_1.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[0],0,false);
			tf_1.width = screenwidth; tf_1.height = 48;
			tf_1.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_2.embedFonts = true;
			tf_2.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[1],0,false);
			tf_2.width = screenwidth; tf_2.height = 100;
			tf_2.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_3.embedFonts = true;
			tf_3.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[2],0,false);
			tf_3.width = screenwidth; tf_3.height = 100;
			tf_3.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_4.embedFonts = true;
			tf_4.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[3],0,false);
			tf_4.width = screenwidth; tf_4.height = 100;
			tf_4.antiAliasType = AntiAliasType.NORMAL;
			
		  tf_5.embedFonts = true;
			tf_5.defaultTextFormat = new TextFormat("FFF Aquarius Bold Condensed",fontsize[4],0,false);
			tf_5.width = screenwidth; tf_5.height = 100;
			tf_5.antiAliasType = AntiAliasType.NORMAL;
		}

		public function rprint(x:Int, y:Int, t:String, col:Int, shadow:Bool = false):Void {
			x = x - len(t);
			print(x, y, t, col, false, shadow);
		}

		public function print(x:Int, y:Int, t:String, col:Int, cen:Bool = false, shadow:Bool=false):Void {
			y -= 3;
		
			if (cen) x = screenwidthmid - Std.int(tf_1.textWidth / 2) + x;
			
			if (shadow) {
				tf_1.textColor = RGB(0, 0, 0);
				tf_1.text = t;
				shapematrix.translate(x + 1, y + 1);
				backbuffer.draw(tf_1, shapematrix);
				
				shapematrix.identity();
			}
			
			tf_1.textColor = RGB(pal[col].r, pal[col].g, pal[col].b);
			tf_1.text = t;
			
			shapematrix.translate(x, y);
			backbuffer.draw(tf_1, shapematrix);
			
			shapematrix.identity();
		}
		
		public function len(t:String, sz:Int = 1):Int {
			if(sz==1){
				tf_1.text = t;
				return Std.int(tf_1.textWidth);
			}else if (sz == 2) {
				tf_2.text = t;
				return Std.int(tf_2.textWidth);
			}else if (sz == 3) {
				tf_3.text = t;
				return Std.int(tf_3.textWidth);
			}else if (sz == 4) {
				tf_4.text = t;
				return Std.int(tf_4.textWidth);
			}else if (sz == 5) {
				tf_5.text = t;
				return Std.int(tf_5.textWidth);
			}
			
			tf_1.text = t;
			return Std.int(tf_1.textWidth);
		}
		public function hig(t:String, sz:Int = 1):Int {
			if(sz==1){
				tf_1.text = t;
				return Std.int(tf_1.textHeight);
			}else if (sz == 2) {
				tf_2.text = t;
				return Std.int(tf_2.textHeight);
			}else if (sz == 3) {
				tf_3.text = t;
				return Std.int(tf_3.textHeight);
			}else if (sz == 4) {
				tf_4.text = t;
				return Std.int(tf_4.textHeight);
			}else if (sz == 5) {
				tf_5.text = t;
				return Std.int(tf_5.textHeight);
			}
			
			tf_1.text = t;
			return Std.int(tf_1.textHeight);
		}

		public function rbigprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false, sc:Float = 2):Void {
			x = x - len(t, Std.int(sc));
			bigprint(x, y, t, r, g, b, cen, sc);
		}

		public function bigprint(x:Int, y:Int, t:String, r:Int, g:Int, b:Int, cen:Bool = false, sc:Float = 2):Void {
			if (r < 0) r = 0; if (g < 0) g = 0; if (b < 0) b = 0;
			if (r > 255) r = 255; if (g > 255) g = 255; if (b > 255) b = 255;
			
			y -= 3;
			
			if (sc == 2) {
				tf_2.text = t;
				if (cen) x = screenwidthmid - Std.int(tf_2.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_2.textColor = Std.int(RGB(r, g, b));
				backbuffer.draw(tf_2, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 3) {
				tf_3.text = t;
				if (cen) x = screenwidthmid - Std.int(tf_3.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_3.textColor = Std.int(RGB(r, g, b));
				backbuffer.draw(tf_3, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 4) {
				tf_4.text = t;
				if (cen) x = screenwidthmid - Std.int(tf_4.textWidth / 2);
				
				shapematrix.translate(x, y);
				tf_4.textColor = Std.int(RGB(r, g, b));
				backbuffer.draw(tf_4, shapematrix);
				
				shapematrix.translate(-x, -y);
			}else if (sc == 5) {
				tf_5.textColor = Std.int(RGB(r, g, b));
				tf_5.text = t;
				if (cen) x = screenwidthmid - Std.int(tf_5.textWidth / 2);
				
				shapematrix.translate(x, y);
				backbuffer.draw(tf_5, shapematrix);
				shapematrix.translate(-x, -y);
			}
		}
		
		public function RGB(red:Float,green:Float,blue:Float):Int{
			return (Std.int(blue) | (Std.int(green) << 8) | (Std.int(red) << 16));
		}
		
		
		public function normalrender():Void {
			backbuffer.unlock();
			
			screenbuffer.lock();
			screenbuffer.copyPixels(backbuffer, backbuffer.rect, tl, null, null, false);
			screenbuffer.unlock();
			
			backbuffer.lock();
		}

		public function render(control:Controlclass):Void {
			if (control.test) {
				backbuffer.fillRect(new Rectangle(0, 0, screenwidth, 10), 0x000000);
				print(5, 0, control.teststring, 2, false);
			}
			
			normalrender();
		}
		  
		public var icons: Array<BitmapData> = new Array<BitmapData>();
		public var ct:ColorTransform;
		public var icons_rect:Rectangle;
		public var tl:Point = new Point(0, 0);
		public var trect:Rectangle;
		public var tpoint:Point;
		public var tbuffer:BitmapData;
		public var i:Int;
		public var j:Int;
		public var k:Int;
		public var l:Int;
		public var mbi:Int;
		public var mbj:Int;
		
		public var screenwidth:Int;
		public var screenheight:Int;
		public var screenwidthmid:Int;
		public var screenheightmid:Int;
		public var screenviewwidth:Int;
		public var screenviewheight:Int;
		public var screenscale:Int;
		public var linesize:Int;
		public var patternheight:Int;
		public var patternwidth:Int;
		public var patterncount:Int;
		public var pianorollposition:Int;
		
		public var temp:Int;
		public var temp2:Int;
		public var temp3:Int;
		public var alphamult:Int;
		public var stemp:String;
		public var buffer:BitmapData;
		public var temppal:Int;
		
		public var zoom:Int;
		public var zoomoffset:Float;
		
		public var tempicon:BitmapData;
		
		public var backbuffer:BitmapData;
		public var screenbuffer:BitmapData;
		public var screen:Bitmap;
		
		public var tempshape:Shape = new Shape();
		public var shapematrix:Matrix = new Matrix();
		
		//[Embed(source = "graphics/font.swf", symbol = "FFF Aquarius Bold Condensed")]
		//public var ttffont:Class;
		

		
		
		public var tf_1:TextField = new TextField();
		public var tf_2:TextField = new TextField();
		public var tf_3:TextField = new TextField();
		public var tf_4:TextField = new TextField();
		public var tf_5:TextField = new TextField();
		public var fontsize: Array<Int> = new Array<Int>();
		
		public var pal: Array<Paletteclass> = new Array<Paletteclass>();
		
		public var buttonpress:Int;
	}