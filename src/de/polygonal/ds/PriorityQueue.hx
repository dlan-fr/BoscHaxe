
package de.polygonal.ds
;
	import flash.utils.Dictionary;
	import de.polygonal.ds.Collection;
	
	
	class PriorityQueue implements Collection
	{
		private var _heap:Array<Dynamic>;
		private var _size:Int;
		private var _count:Int;
		private var _posLookup:Dictionary;
		
		
		public function new(size:Int)
		{
			_heap = new Array<Dynamic>(_size = size + 1);
			_posLookup = new Dictionary(true);
			_count = 0;
		}
		
		
		public function front():Prioritizable
		{
			return _heap[1];
		}
		
		
		public function enqueue(obj:Prioritizable):Void
		{
			_count++;
			_heap[_count] = obj;
			_posLookup[obj] = _count;
			walkUp(_count);
		}
		
		
		public function dequeue():Void
		{
			if (_count >= 1)
			{
				delete _posLookup[_heap[1]];
				
				_heap[1] = _heap[_count];
				walkDown(1);
				delete _heap[_count];
				_count--;
			}
		}
		
		
		public function reprioritize(obj:Prioritizable, newPriority:Int):Bool
		{
			if (!_posLookup[obj]) return false;
			
			var oldPriority:Int = obj.priority;
			
			
			
			obj.priority = newPriority;
			
			
			
			var pos:Int = _posLookup[obj];
			
			
			
			
			
			newPriority > oldPriority ? walkUp(pos) : walkDown(pos);
			
			return true;
		}
		
		
		public function remove(obj:Prioritizable):Bool
		{
			if (!_posLookup[obj]) return false;
			
			var pos:Int = _posLookup[obj];
			delete _posLookup[obj];
			
			_heap[pos] = _heap[_count];
			delete _heap[_count];
			
			walkDown(pos);
			_count--;
			
			return true;
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
			_posLookup = new Dictionary(true);
			_count = 0;
		}
		
		
		public function getIterator():Iterator
		{
			return new PriorityQueueIterator(this);
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
			var parentObj:Prioritizable;
			
			var tmp:Prioritizable = _heap[index];
			var p:Int = tmp.priority;
			
			while (parent > 0)
			{
				parentObj = _heap[parent];
				
				if (p - parentObj.priority > 0)
				{
					_heap[index] = parentObj;
					_posLookup[parentObj] = index;
					
					index = parent;
					parent >>= 1;
				}
				else break;
			}
			
			_heap[index] = tmp;
			_posLookup[tmp] = index;
		}
		
		private function walkDown(index:Int):Void
		{
			var child:Int = index << 1;
			var childObj:Prioritizable;
			
			var tmp:Prioritizable = _heap[index];
			var p:Int = tmp.priority;
			
			while (child < _count)
			{
				if (child < _count - 1)
				{
					if (_heap[child].priority - _heap[int(child + 1)].priority < 0)
						child++;
				}
				
				childObj = _heap[child];
				
				if (p - childObj.priority < 0)
				{
					_heap[index] = childObj;
					_posLookup[childObj] = child;
					
					index = child;
					child <<= 1;
				}
				else break;
			}
			_heap[index] = tmp;
			_posLookup[tmp] = index;
		}
    }
}

import de.polygonal.ds.Iterator;
import de.polygonal.ds.PriorityQueue;

class PriorityQueueIterator implements Iterator
{
	private var _values:Array<Dynamic>;
	private var _length:Int;
	private var _cursor:Int;
	
	public function PriorityQueueIterator(pq:PriorityQueue)
	{
		_values = pq.toArray();
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
