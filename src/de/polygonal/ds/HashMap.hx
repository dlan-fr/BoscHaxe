package de.polygonal.ds;

	import de.polygonal.ds.Collection;
	import de.polygonal.ds.Iterator;
	
	class HashMap implements Collection
	{
		private var _keyMap:haxe.ds.HashMap<Dynamic,Dynamic>;
		private var _objMap:haxe.ds.HashMap<Dynamic,Dynamic>;
		private var _size:Int;
		
		
		public function new()
		{
			_keyMap = new haxe.ds.HashMap<Dynamic,Dynamic>();
			_objMap = new haxe.ds.HashMap<Dynamic,Dynamic>();
			_size = 0;
		}
		
		
		public function insert(key:Dynamic, obj:Dynamic):Bool
		{
			if (_keyMap.exists(key)) return false;
			++_size;
			_objMap.set(obj, key);
			_keyMap.set(key, obj);
			return true;
		}
		
		
		public function find(key:Dynamic):Dynamic
		{
			return _keyMap.get(key) || null;
		}
		
		
		public function findKey(val:Dynamic):Dynamic
		{
			return _objMap.get(val) || null;
		}
		
		
		public function remove(key:Dynamic):Dynamic
		{
			if (_keyMap.exists(key))
			{
				var obj:Dynamic = _keyMap.get(key);
				--_size;
				_keyMap.remove(key);
				_objMap.remove(obj);
				return obj;
			}
			return null;
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
			return _objMap.exists(obj);
		}
		
		
		public function containsKey(key:Dynamic):Bool
		{
			return _keyMap.exists(key);
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
			_keyMap = new haxe.ds.HashMap<Dynamic,Dynamic>();
			_objMap = new haxe.ds.HashMap<Dynamic,Dynamic>();
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
			var a:Array<Dynamic> = new Array<Dynamic>(), j:Int = 0;
			for (i in _keyMap)
			{
				a[j++] = i;
			}
			return a;
		}
		
		
		public function getKeySet():Array<Dynamic>
		{
			var a:Array<Dynamic> = new Array<Dynamic>(), j:Int = 0;
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
				s += "[key: " + i + " val:" + _keyMap.get(i) + "]\n";
			return s;
		}
	}



class HashMapValueIterator implements Iterator
{
	private var _h:HashMap;
	private var _values:Array<Dynamic>;
	private var _cursor:Int;
	private var _size:Int;
	
	public function new(h:HashMap)
	{
		_h = h;
		_values = h.toArray();
		_cursor = 0;
		_size = _h.size(); 
	}
	
	public function get_data():Dynamic
	{
		return _values[_cursor];
	}
	
	public function set_data(obj:Dynamic):Void
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
	
	public function new(h:HashMap)
	{
		_h = h;
		_keys = h.getKeySet();
		_cursor = 0;
		_size = _h.size(); 
	}
	
	public function get_data():Dynamic
	{
		return _keys[_cursor];
	}
	
	public function set_data(obj:Dynamic):Void
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
