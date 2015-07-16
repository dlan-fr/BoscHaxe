
package de.polygonal.ds
;
	import de.polygonal.ds.Collection;
	
	
	class ArrayedStack implements Collection
	{
		private var _stack:Array<Dynamic>;
		private var _size:Int;
		private var _top:Int;
		
		
		public function new(size:Int)
		{
			_size = size;
			clear();
		}
		
		
		public function peek():Dynamic
		{
			return _stack[int(_top - 1)];
		}
		
		
		public function push(obj:Dynamic):Bool
		{
			if (_size != _top)
			{
				_stack[_top++] = obj;
				return true;
			}
			return false;
		}
		
		
		public function pop():Void
		{
			if (_top > 0) _top--
		}
		
		
		public function getAt(i:Int):Dynamic
		{
			if (i >= _top) return null;
			return _stack[i];
		}
		
		
		public function setAt(i:Int, obj:Dynamic):Void
		{
			if (i >= _top) return;
			_stack[i] = obj;
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
		var i:Int = 0;
	while( i < _top){
				if (_stack[i] === obj)
					return true;
			 i++;
}
			return false;
		}
		
		
		public function clear():Void
		{
			_stack = new Array<Dynamic>(_size);
			_top = 0;
		}
		
		
		public function getIterator():Iterator
		{
			return new Array<Dynamic>edStackIterator(this);
		}
		
		
		public function size():Int
		{
			return _top;
		}
		
		
		public function isEmpty():Bool
		{
			return _size == 0;
		}
		
		
		public function maxSize():Int
		{
			return _size;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			return _stack.concat();
		}
		
		
		public function toString():String
		{
			return "[ArrayedStack, size= " + _top + "]";
		}
		
		
		public function dump():String
		{
			var s:String = "[ArrayedStack]";
			if (_top == 0) return s;
			
			var k:Int = _top - 1;
			s += "\n\t" + _stack[k--] + " -> front\n";
		var i:Int = k;
	while( i >= 0)ator
{
	private var _stack:Array<Dynamic>edStack;
	private var _cursor:Int;
	
	public function ArrayedStackIterator(stack:Array<Dynamic>edStack)
	{
		_stack = stack;
		start();
	}
	
	public function data():Dynamic
	{
		return _stack.getAt(_cursor);
	}
	
	public function data(obj:Dynamic):Void
	{
		_stack.setAt(_cursor, obj);
	}
	
	public function start():Void
	{
		_cursor = _stack.size - 1;
	}
	
	public function hasNext():Bool
	{
		return _cursor >= 0;
	}
	
	public function next():Dynamic
	{
		if (_cursor >= 0)
			return _stack.getAt(_cursor--);
		return null;
	}
