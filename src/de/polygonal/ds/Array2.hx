
package de.polygonal.ds
;
	import de.polygonal.ds.Collection;
	
	
	class Array2 implements Collection
	{
		private var _a:Array<Dynamic>;
		private var _w:Int, _h:Int;
		
		
		public function new(width:Int, height:Int)
		{
			_a = new Array<Dynamic>((_w = width) * (_h = height));
			fill(null);
		}
		
		
		public function width():Int
		{
			return _w;
		}
		
		public function width(w:Int):Void
		{
			resize(w, _h);
		}
		
		
		public function height():Int
		{
			return _h;
		}
		
		public function height(h:Int):Void
		{
			resize(_w, h);
		}
		
		
		public function fill(item:Dynamic):Void
		{
			var k:Int = _w * _h;
		var i:Int = 0;
	while( i < k)ic
		{
			return _a[int(y * _w + x)];
		}
		
		
		public function set(x:Int, y:Int, obj:Dynamic):Void
		{
			_a[int(y * _w + x)] = obj;
		}
		
		
		public function resize(w:Int, h:Int):Void
		{
			if (w <= 0) w = 1;
			if (h <= 0) h = 1;
			
			var copy:Array<Dynamic> = _a.concat();
			
			_a.length = 0;
			_a.length = w * h;
			
			var minx:Int = w < _w ? w : _w;
			var miny:Int = h < _h ? h : _h;
			
			var x:Int, y:Int, t1:Int, t2:Int;
		y = 0;
	while( y < miny){
				t1 = y *  w;
				t2 = y * _w;
				
			x = 0;
	while( x < minx)c>
		{
			var offset:Int = y * _w;
			return _a.slice(offset, offset + _w);
		}
		
		
		public function getCol(x:Int):Array<Dynamic>
		{
			var t:Array<Dynamic> = [];
		var i:Int = 0;
	while( i < _h)id
		{
			if (_w == 1) return;
			
			var j:Int = _w - 1, k:Int;
		var i:Int = 0;
	while( i < _h){
				k = i * _w + j;
				_a.splice(k, 0, _a.splice(k - j, 1));
			 i++;
}
		}
		
		
		public function shiftRight():Void
		{
			if (_w == 1) return;
			
			var j:Int = _w - 1, k:Int;
		var i:Int = 0;
	while( i < _h){
				k = i * _w + j;
				_a.splice(k - j, 0, _a.splice(k, 1));
			 i++;
}
		}
		
		
		public function shiftUp():Void
		{
			if (_h == 1) return;
			
			_a = _a.concat(_a.slice(0, _w));
			_a.splice(0, _w);
		}
		
		
		public function shiftDown():Void
		{
			if (_h == 1) return;
			
			var offset:Int = (_h - 1) * _w;
			_a = _a.slice(offset, offset + _w).concat(_a);
			_a.splice(_h * _w, _w);
		}
		
		
		public function appendRow(a:Array<Dynamic>):Void
		{
			a.length = _w;
			_a = _a.concat(a);
			_h++
		}
		
		
		public function prependRow(a:Array<Dynamic>):Void
		{
			a.length = _w;
			_a = a.concat(_a);
			_h++;
		}
		
		
		public function appendCol(a:Array<Dynamic>):Void
		{
			a.length = _h;
		var y:Int = 0;
	while( y < _h)id
		{	
			a.length = _h;
		var y:Int = 0;
	while( y < _h)id
		{
			var a:Array<Dynamic> = _a.concat();
		var y:Int = 0;
	while( y < _h){
			var x:Int = 0;
	while( x < _w)ol
		{
			var k:Int = size;
		var i:Int = 0;
	while( i < k){
				if (_a[i] === obj)
					return true;
			 i++;
}
			return false;
		}
		
		
		public function clear():Void
		{
			_a = new Array<Dynamic>(size);
		}
		
		
		public function getIterator():Iterator
		{
			return new Array<Dynamic>2Iterator(this);
		}
		
		
		public function size():Int
		{
			return _w * _h;
		}
		
		
		public function isEmpty():Bool
		{
			return false;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			var a:Array<Dynamic> = _a.concat();
			
			var k:Int = size;
			if (a.length > k) a.length = k;
			return a;
		}
		
		
		public function toString():String
		{
			return "[Array2, width=" + width + ", height=" + height + "]";
		}
		
		
		public function dump():String
		{
			var s:String = "Array2\n{";
			var offset:Int, value:Dynamic;
		var y:Int = 0;
	while( y < _h){
				s += "\n" + "\t";
				offset = y * _w;
			var x:Int = 0;
	while( x < _w){
					value = _a[int(offset + x)];
					s += "[" + (value != undefined ? value : "?") + "]";
				 x++;
}
			 y++;
}
			s += "\n}";
			return s;
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Array2;

class Array2Iterator implements Iterator
{
	private var _a2:Array<Dynamic>2;
	private var _xCursor:Int;
	private var _yCursor:Int;
	
	public function Array2Iterator(a2:Array<Dynamic>2)
	{
		_a2 = a2;
		_xCursor = _yCursor = 0;
	}
	
	public function data():Dynamic
	{
		return _a2.get(_xCursor, _yCursor);
	}
	
	public function data(obj:Dynamic):Void
	{
		_a2.set(_xCursor, _yCursor, obj);
	}
	
	public function start():Void
	{
		_xCursor = _yCursor = 0;
	}
	
	public function hasNext():Bool
	{
		return (_yCursor * _a2.width + _xCursor < _a2.size);
	}
	
	public function next():Dynamic
	{
		var item:Dynamic = data;
		
		if (++_xCursor == _a2.width)
		{
			_yCursor++;
			_xCursor = 0;
		}
		
		return item;
	}
