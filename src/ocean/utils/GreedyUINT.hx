

package ocean.utils ;
	import flash.utils.ByteArray;
	import flash.errors.Error;
	import flash.errors.EOFError;
	class GreedyUINT {
	
	
		private static inline var INT_MAX_VALUE = 2147483647;
		
		private var _rawBytes:ByteArray;
	
		
		@:isVar public var value(get, set):Int;
		@isVar public var rawBytes(get, set):ByteArray;
		
		
		public function get_value():Int{
			_rawBytes.position = 0;
			if(0==_rawBytes.length){
				throw new Error("value is not defined");
			}
			
			var n:Int;
			
		 var e:Int = _rawBytes.length-1;
	while( e>=0){
				n += ( _rawBytes.readByte()&0x7F )<<(7*e);
			 e-- ;
}
			/*if( n==INT_MAX_VALUE || n==-INT_MAX_VALUE ){
				throw new Error("value is beyond uint infinity");
			}*/
			return n;
		}
		
		
		public function set_value(n:Int):Int{
			_rawBytes.position = 0;
			var e:Int ;
			var t:Int ;
			var temp:Array<Dynamic>=new Array<Dynamic>();
			
			if( 0!=n ){
			 e=0 ; t = n>>(7*e) ;
	while( t>=1 && e<5){
					
					
					
					temp[e] = (e != 0)?( t&(128-1) | 0x80 ): n&(128-1);
					
					
					t = n>>(7*(++e));
				}
			}else{
				temp[0]=0;
			}
		 //_rawBytes.length = e = temp.length ;
	while( e>0 ){
				_rawBytes.writeByte(temp[e-1]);
			 e-- ;
}
			
			return 0;

		}
		
		
		public function get_rawBytes():ByteArray{
			_rawBytes.position = 0;
			return _rawBytes;
		}
		
		public function set_rawBytes(raw:ByteArray):ByteArray{
			_rawBytes.position = 0;
			//_rawBytes.length = 0;
			if( check(raw) ){
				_rawBytes.writeBytes(raw);
				_rawBytes.position = 0;
			}else{
				throw new Error("input byteArrary is not a valid GreedyUINT");
			}
			
			return _rawBytes;
		}
	
	
		
		public function new(raw:ByteArray=null):Void{
			_rawBytes = new ByteArray();
			if( null==raw ){
				_rawBytes[0]=0;
			}
			else if( check(raw) ){
				_rawBytes.writeBytes(raw);
			}
			else{
				throw new Error("input byteArrary is not a valid GreedyUINT");
			}
		}
		
		
		public function check(raw:ByteArray):Bool{
			if( null==raw ){return false;}
			var len:Int = raw.length;
			
			if( len>5 || len<=0){return false;}
			
			if( (raw[len-1] & 0x80) != 0x00 ){
				return false;
			}
			
			else{
			 var i:Int=0;
	while( i<len-1 ){
					if( (raw[i]&0x80)!=0x80 ){
						return false ;
					}
				 i++ ;
}
			}
			return true;
		}
		
		
		public function stream(raw:ByteArray):Void{
			
			_rawBytes = new ByteArray();
			_rawBytes.position = 0;
			
			var temp:Int;
			
			do{
				
				try{
					temp = raw.readByte();
				}catch(e:EOFError){
					throw new Error("End of File Error! Not enough bytes to read.");
				}
				
				_rawBytes.writeByte(temp);
				
			}while( (temp&0x80)!=0x00 && _rawBytes.length<=5);
			if( _rawBytes.length == 6 ){
				throw new Error("can't deal with uint value beyond 4294967295. This stream is not countable .");
			}

		}

		
		public function length():Int{
			return rawBytes.length;
		}

		
	}
	

