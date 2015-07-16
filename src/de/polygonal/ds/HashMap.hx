package de.polygonal.ds;

	import flash.utils.Dictionary;
	import de.polygonal.ds.Collection;
	import de.polygonal.ds.Iterator;
	
	class HashMap implements Collection
	{
		private var _keyMap:Dictionary;
		private var _objMap:Dictionary;
		private var _size:Int;
		
		
		public function new()
		{
			_keyMap = new Dictionary(true);
			_objMap = new Dictionary(true);
			_size = 0;
		}
		
		
		public function insert(key:Dynamic, obj:Dynamic):Bool
		{
			if (_keyMap[key]) return false;
			++_size;
			_objMap[obj] = key;
			_keyMap[key] = obj;
			return true;
		}
		
		
		public function find(key:Dynamic):Dynamic
		{
			return _keyMap[key] || null;
		}
		
		
		public function findKey(val:Dynamic):Dynamic
		{
			return _objMap[val] || null;
		}
		
		
		public function remove(key:Dynamic):Dynamic
		{
			var obj:Dynamic = _keyMap[key];
			
			if (obj)
			{
				--_size;
				_keyMap[key] = null;
				_objMap[obj] = null;
				return obj;
			}
			return null;
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
			return _objMap[obj] ? true : false;
		}
		
		
		public function containsKey(key:Dynamic):Bool
		{
			return _keyMap[key] ? true : false;
		}
		
		
		public function getIterator():Iterator
		{
			return new HashMapValueIterator(this);
		}
		
		
		public function getKeyIterator():Iterator
		{
			return new HashMapKeyIterator(this);
		}
		
		
		public function clear():Void
		{
			_keyMap = new Dictionary(true);
			_objMap = new Dictionary(true);
			_size = 0;
		}
		
		
		public function size():Int
		{
			return _size;
		}
		
		
		public function isEmpty():Bool
		{
			return _size == 0;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			var a:Array<Dynamic> = new Array<Dynamic>(_size), j:Int = 0;
			for (i in _keyMap)
			{
				a[j++] = i;
			}
			return a;
		}
		
		
		public function getKeySet():Array<Dynamic>
		{
			var a:Array<Dynamic> = new Array<Dynamic>(_size), j:Int = 0;
			for (i in _objMap)
			{
				a[j++] = i;
			}
			return a;
		}
		
		
		public function toString():String
		{
			return "[HashMap, size=" + size + "]";
		}
		
		
		public function dump():String
		{
			var s:String = "HashMap:\n";
			for (i in _objMap)
				s += "[key: " + i + " val:" + _keyMap[i] + "]\n";
			return s;
		}
	}



class HashMapValueIterator implements Iterator
{
	private var _h:HashMap;
	private var _values:Array<Dynamic>;
	private var _cursor:Int;
	private var _size:Int;
	
	public function HashMapValueIterator(h:HashMap)
	{
		_h = h;
		_values = h.toArray();
		_cursor = 0;
		_size = _h.size; 
	}
	
	public function data():Dynamic
	{
		return _values[_cursor];
	}
	
	public function data(obj:Dynamic):Void
	{
		var key:Dynamic = _h.findKey(_values[_cursor]);
		_h.remove(key);
		_h.insert(key, obj);
	}
	
	public function start():Void
	{
		_cursor = 0;
	}
	
	public function hasNext():Bool
	{
		return _cursor < _size;
	}
	
	public function next():Dynamic
	{
		return _values[_cursor++];
	}
}

class HashMapKeyIterator implements Iterator
{
	private var _h:HashMap;
	private var _keys:Array<Dynamic>;
	private var _cursor:Int;
	private var _size:Int;
	
	public function HashMapKeyIterator(h:HashMap)
	{
		_h = h;
		_keys = h.getKeySet();
		_cursor = 0;
		_size = _h.size; 
	}
	
	public function data():Dynamic
	{
		return _keys[_cursor];
	}
	
	public function data(obj:Dynamic):Void
	{
		var key:Dynamic = _keys[_cursor];
		var val:Dynamic = _h.find(key);
		_h.remove(key);
		_h.insert(obj, val);
	}
	
	public function start():Void
	{
		_cursor = 0;
	}
	
	public function hasNext():Bool
	{
		return _cursor < _size;
	}
	
	public function next():Dynamic
	{
		return _keys[_cursor++];
	}
}
