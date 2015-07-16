
package de.polygonal.ds
;
	import de.polygonal.ds.Collection;
	
	
	class ArrayedQueue implements Collection
	{
		private var _que:Array<Dynamic>;
		private var _size:Int;
		private var _divisor:Int;
		
		private var _count:Int;
		private var _front:Int;
		
		
		public function new(sizeShift:Int)
		{
			if (sizeShift < 3) sizeShift = 3;
			_size = 1 << sizeShift;
			_divisor = _size - 1;
			clear();
		}
		
		
		public function peek():Dynamic
		{
			return _que[_front];
		}
		
		
		public function enqueue(obj:Dynamic):Bool
		{
			if (_size != _count)
			{
				_que[int((_count++ + _front) & _divisor)] = obj;
				return true;
			}
			return false;
		}
		
		
		public function dequeue():Dynamic
		{
			if (_count > 0)
			{
				var data:Dynamic = _que[_front++];
				if (_front == _size) _front = 0;
				_count--;
				return data;
			}
			return null;
		}
		
		
		public function dispose():Void
		{
			if (!_front) _que[int(_size  - 1)] = null;
			else 		 _que[int(_front - 1)] = null;
		}
		
		
		public function getAt(i:Int):Dynamic
		{
			if (i >= _count) return null;
			return _que[int((i + _front) & _divisor)];
		}
		
		
		public function setAt(i:Int, obj:Dynamic):Void
		{
			if (i >= _count) return;
			_que[int((i + _front) & _divisor)] = obj;
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
		var i:Int = 0;
	while( i < _count){
				if (_que[int((i + _front) & _divisor)] === obj)
					return true;
			 i++;
}
			return false;
		}
		
		
		public function clear():Void
		{
			_que = new Array<Dynamic>(_size);
			_front = _count = 0;
		}
		
		
		public function getIterator():Iterator
		{
			return new Array<Dynamic>edQueueIterator(this);
		}
		
		
		public function size():Int
		{
			return _count;
		}
		
		
		public function isEmpty():Bool
		{
			return _count == 0;
		}
		
		
		public function maxSize():Int
		{
			return _size;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			var a:Array<Dynamic> = new Array<Dynamic>(_count);
		var i:Int = 0;
	while( i < _count)ng
		{
			return "[ArrayedQueue, size=" + size + "]";
		}
		
		
		public function dump():String
		{
			var s:String = "[ArrayedQueue]\n";
			
			s += "\t" + getAt(i) + " -> front\n";
		var i:Int = 1;
	while( i < _count)ator
{
	private var _que:Array<Dynamic>edQueue;
	private var _cursor:Int;
	
	public function ArrayedQueueIterator(que:Array<Dynamic>edQueue)
	{
		_que = que;
		_cursor = 0;
	}
	
	public function data():Dynamic
	{
		return _que.getAt(_cursor);
	}
	
	public function data(obj:Dynamic):Void
	{
		_que.setAt(_cursor, obj);
	}
	
	public function start():Void
	{
		_cursor = 0;
	}
	
	public function hasNext():Bool
	{
		return _cursor < _que.size;
	}
	
	public function next():Dynamic
	{
		if (_cursor < _que.size)
			return _que.getAt(_cursor++);
		return null;
	}
