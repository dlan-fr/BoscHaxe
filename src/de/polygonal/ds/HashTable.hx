
package de.polygonal.ds
;
	import de.polygonal.ds.Iterator;
	
	
	class HashTable
	{
		
		public static function hashString(s:String):Int
		{
			var hash:Int = 0, i:Int, k:Int = s.length;
		i = 0;
	while( i < k)nt
		{
			return hashString(i.toString());
		}
		
		private var _table:Array<Dynamic>;
		private var _hash:Dynamic;
		
		private var _size:Int;
		private var _divisor:Int;
		private var _count:Int;
		
		
		public function HashTable(size:Int, hash:Dynamic = null)
		{
			_count = 0;
			
			_hash = (hash == null) ? function(key:Int):Int { return key } : hash;
			_table = new Array<Dynamic>(_size = size);
			
		var i:Int = 0;
	while( i < size)id
		{
			_table[int(_hash(key) & _divisor)].push(new HashEntry(key, obj));
			_count++;
		}
		
		
		public function find(key:Dynamic):Dynamic
		{
			var list:Array<Dynamic> = _table[int(_hash(key) & _divisor)];
			var k:Int = list.length, entry:HashEntry;
		var i:Int = 0;
	while( i < k){
				entry = list[i];
				if (entry.key === key)
					return entry.data;
			 i++;
}
			return null;
		}
		
		
		public function remove(key:Dynamic):Dynamic
		{
			var list:Array<Dynamic> = _table[int(_hash(key) & _divisor)];
			var k:Int = list.length;
		var i:Int = 0;
	while( i < k){
				var entry:HashEntry = list[i];
				if (entry.key === key)
				{
					list.splice(i, 1);
					return entry.data;
				}
			 i++;
}
			return null;
		}
		
		
		public function contains(obj:Dynamic):Bool
		{
			var list:Array<Dynamic>, k:Int = size;
		var i:Int = 0;
	while( i < k){
				list = _table[i];
				var l:Int = list.length; 
				
			var j:Int = 0;
	while( j < l)or
		{
			return new NullIterator();
		}
		
		
		public function clear():Void
		{
			_table = new Array<Dynamic>(_size);
			_count = 0;
		}
		
		
		public function size():Int
		{
			return _count;
		}
		
		
		public function maxSize():Int
		{
			return _size;
		}
		
		
		public function toArray():Array<Dynamic>
		{
			var a:Array<Dynamic> = [], list:Array<Dynamic>, k:Int = size;
		var i:Int = 0;
	while( i < k){
				list = _table[i];
				var l:Int = list.length; 
				
			var j:Int = 0;
	while( j < l)ng
		{
			return "[HashTable, size=" + size + "]";
		}
		
		public function print():String
		{
			var s:String = "HashTable:\n";
		var i:Int = 0;
	while( i < _size){
				if (_table[i])
					s += "[" + i + "]" + "\n" + _table[i];
			 i++;
}
			return s;
		}
	}
}


class HashEntry
{
	public var key:Int;
	
	public var data:Dynamic;
	
	public function HashEntry(key:Int, data:Dynamic)
	{
		this.key = key;
		this.data = data;
	}



