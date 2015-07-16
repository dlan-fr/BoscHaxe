
package de.polygonal.ds
;
	import de.polygonal.ds.Collection;
	
	
	class Array3 implements Collection
	{
		private var _a:Array<Dynamic>;
		private var _w:Int, _h:Int, _d:Int;
		
		
		public function new(w:Int, h:Int, d:Int)
		{
			_a = new Array<Dynamic>((_w = w) * (_h = h) * (_d = d));
		}
		
		
		public function width():Int
		{
			return _w;
		}
		
		public function width(w:Int):Void
		{
			resize(w, _h, _d);
		}
		
		
		public function height():Int
		{
			return _h;
		}
		
		public function height(h:Int):Void
		{
			resize(_w, h, _d);
		}
		
		
		public function depth():Int
		{
			return _d;
		}
		
		public function depth(d:Int):Void
		{
			resize(_w, _h, d);
		}
		
		
		public function fill(obj:Dynamic):Void
		{
			var k:Int = size;
		var i:Int = 0;
	while( i < k)ic
		{
			return _a[int((z * _w * _h) + (y * _w) + x)];
		}
		
		
		public function set(x:Int, y:Int, z:Int, obj:Dynamic):Void
		{
			_a[int((z * _w * _h) + (y * _w) + x)] = obj;
		}
		
		
		public function resize(w:Int, h:Int, d:Int):Void
		{
			var tmp:Array<Dynamic> = _a.concat();
			
			_a.length = 0;
			_a.length = w * h * d;
			
			if (_a.length == 0)
				return;
			
			var xMin:Int = w < _w ? w : _w;
			var yMin:Int = h < _h ? h : _h;
			var zMin:Int = d < _d ? d : _d;
			
			var x:Int, y:Int, z:Int;
			var t1:Int, t2:Int, t3:Int, t4:Int;
			
		z = 0;
	while( z < zMin){
				t1 = z *  w  * h;
				t2 = z * _w * _h;
				
			y = 0;
	while( y < yMin){
					t3 = y *  w;
					t4 = y * _w;
					
				x = 0;
	while( x < xMin)ol
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
			return new Array<Dynamic>3Iterator(this);
		}
		
		
		public function size():Int
		{
			return _w * _h * _d;
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
			return "[Array3, size=" + size + "]";
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Array3;

class Array3Iterator implements Iterator
{
	private var _values:Array<Dynamic>;
	private var _length:Int;
	private var _cursor:Int;
	
	public function Array3Iterator(a3:Array<Dynamic>3)
	{
		_values = a3.toArray();
		_length = _values.length;
		_cursor = 0;
	}
	
	public function data():Dynamic
	{
		return _values[_cursor];
	}
	
	public function data(obj:Dynamic):Void
	{
		_values[_cursor] = obj;
	}
	
	public function start():Void
	{
		_cursor = 0;
	}
	
	public function hasNext():Bool
	{
		return _cursor < _length;
	}
	
	public function next():Dynamic
	{
		return _values[_cursor++];
	}
