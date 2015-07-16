
package de.polygonal.ds
;
	
	class BitVector
	{
		private var _bits:Array<Dynamic>;
		private var _arrSize:Int;
		private var _bitSize:Int;
		
		
		public function BitVector(bits:Int)
		{
			_bits = [];
			_arrSize = 0;
			
			resize(bits);
		}
		
		
		public function bitCount():Int
		{
			return _arrSize * 31;
		}
		
		
		public function cellCount():Int
		{
			return _arrSize;
		}
		
		
		public function getBit(index:Int):Int
		{
			var bit:Int = index % 31;
			return (_bits[(index / 31) >> 0] & (1 << bit)) >> bit;
		}
		
		
		public function setBit(index:Int, b:Bool):Void
		{
			var cell:Int = index / 31;
			var mask:Int = 1 << index % 31;
			_bits[cell] = b ? (_bits[cell] | mask) : (_bits[cell] & (~mask));
		}
		
		
		public function resize(size:Int):Void
		{
			if (size == _bitSize) return;
			_bitSize = size;
			
			
			if (size % 31 == 0)
				size /= 31;
			else
				size = (size / 31) + 1;
			
			if (size < _arrSize)
			{
				_bits.splice(size);
				_arrSize = size;
			}
			else
			{
				_bits = _bits.concat(new Array<Dynamic>(size - _arrSize));
				_arrSize = _bits.length;
			}
		}
		
		
		public function clear():Void
		{
			var k:Int = _bits.length;
		var i:Int = 0;
	while( i < k)id
		{
			var k:Int = _bits.length;
		var i:Int = 0;
	while( i < k)ng
		{
			return "[BitVector, size=" + _bitSize + "]";
		}
	}


