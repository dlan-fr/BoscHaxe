
package de.polygonal.ds
;
	import de.polygonal.ds.Collection;
	import de.polygonal.ds.Iterator;
	
	
	class Heap implements Collection
	{
		public var _heap:Array<Dynamic>;
		
		private var _size:Int;
		private var _count:Int;
		private var _compare:Dynamic;
		
		
		public function new(size:Int, compare:Dynamic = null)
		{
			_heap = new Array<Dynamic>(_size = size + 1);
			_count = 0;
			
			if (compare == null)
			{
				_compare = function(a:Int, b:Int):Int
				{
					return a - b;
				}
			}
			else
				_compare = compare;
		}
		
		
		public function front():Dynamic
		{
			return _heap[1];
		}
		
		
		public function enqueue(obj:Dynamic):Void
		{
			_heap[++_count] = obj;
			walkUp(_count);
		}
		
		
		public function dequeue():Void
		{
			if (_count >= 1)
			{
				_heap[1] = _heap[_count];
				delete _heap[_count];
				
				walkDown(1);
				_count--;
			}
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
		var i:Int = 1;
	while( i <= _count){
				if (_heap[i] === obj)
					return true;
			 i++;
}
			return false;
		}
		
		
		public function clear():Void
		{
			_heap = new Array<Dynamic>(_size);
			_count = 0;
		}
		
		
		public function getIterator():Iterator
		{
			return new HeapIterator(this);
		}
		
		
		public function size():Int
		{
			return _count;
		}
		
		
		public function isEmpty():Bool
		{
			return false;
		}
		
		
		public function maxSize():Int
		{
			return _size;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			return _heap.slice(1, _count);
		}
		
		private function walkUp(index:Int):Void
		{
			var parent:Int = index >> 1;
			var tmp:Dynamic = _heap[index];
			while (parent > 0)
			{
				if (_compare(tmp, _heap[parent]) > 0)
				{
					_heap[index] = _heap[parent];
					index = parent;
					parent >>= 1;
				}
				else break;
			}
			_heap[index] = tmp;
		}
		
		private function walkDown(index:Int):Void
		{
			var child:Int = index << 1;
			
			var tmp:Dynamic = _heap[index], c:Dynamic;
			
			while (child < _count)
			{
				if (child < _count - 1)
				{
					if (_compare(_heap[child], _heap[int(child + 1)]) < 0)
						child++;
				}
				if (_compare(tmp, _heap[child]) < 0)
				{
					_heap[index] = _heap[child];
					index = child;
					child <<= 1;
				}
				else break;
			}
			_heap[index] = tmp;
		}
	}
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.Heap;

class HeapIterator implements Iterator
{
	private var _values:Array<Dynamic>;
	private var _length:Int;
	private var _cursor:Int;
	
	public function HeapIterator(heap:Heap)
	{
		_values = heap.toArray();
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
