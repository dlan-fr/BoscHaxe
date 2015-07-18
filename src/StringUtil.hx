package ;

class StringUtil
{

	public static function repeat(str:String,n:Int):String
	  {
		   var outStr:String = "";

		   for(i in 0...n)
				outStr += str;

		   return outStr;   
	  }
	  
	  //ported from as3 commons https://code.google.com/p/as3-commons
	  public static function substitute(str:String,rest:Array<Dynamic>):String 
	  {
			if (str == null) {
					return '';
			}

			var len:Int = rest.length;
			var args:Array<Dynamic>;
			if (len == 1 && Std.is(rest[0],Array)) {
					args = cast rest[0];
					len = args.length;
			} else {
					args = rest;
			}

			for (i in 0...len) {
					var item:Dynamic = args[i];
					str = str.split('{' + Std.string(i) + '}').join((item != null) ? item.toString() : "[null]");
			}

			return str;
        }

	
	
}