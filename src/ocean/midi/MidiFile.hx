
package ocean.midi ;
	import de.polygonal.ds.Iterator;
	import ocean.midi.model.MetaItem;
	import ocean.midi.model.ChannelItem;
	import ocean.midi.model.MessageItem;
	import ocean.midi.model.MessageList;
	
	
	import flash.utils.ByteArray;
	import ocean.midi.model.NoteItem;

	
	class MidiFile {

		public static var DIV_120:Int = 120;
		
		private static var MThd:Int = 0x4D546864;
		private static var HDRSIZE:Int = 0x00000006;
		
		
		private var _format:Int;
		
		
		private var _tracks:Int;
		
		
		private var _division:Int;
		
		
		private var _mainTrack:MidiTrack;
		
		
		public var _trackArray:Array<Dynamic>;
		
		
		public function format():Int{
			return _format&0xFFFF;
		}
		
		
		public function format(f:Int):Void{
			if( 0==f || 1==f || 2==f ){
				_format = f ;
			}
			else{
				throw new InvalidMidiError("Midi track format only accept 0,1,2!");
			}
		}
		
		
		public function tracks():Int{
			return _tracks&0xFFFF;
		}
		
		
		public function division():Int{
			return _division&0xFFFF;
		}
		
		
		public function division(d:Int):Void{
			_division = d&0xFFFF;
		}
		
		
		public function new(file:ByteArray=null):Void{
			_trackArray = new Array<Dynamic>();
			if( file ){
				input(file);
			}
			else{
				_format = 1;
				_tracks = 0;
				_division = DIV_120;
			}
		}

		
		public function input( fileStream:ByteArray , separate:Bool=true ):Void{
			
			if( fileStream.readInt() != MThd ){
				throw new InvalidMidiError("Midi header Std.is(tag,incorrect, loads file error!"));
			}
			
			
			if( fileStream.readInt() != HDRSIZE ){
				throw new InvalidMidiError("Midi header Std.is(size,incorrect, loads file error!"));
			}
			
			
			_format = fileStream.readShort();
			_tracks = fileStream.readShort();
			_division = fileStream.readShort();
			var track:MidiTrack;
			
			
		 var i:Int = 0 ;
	while( i<_tracks ){
				
				track = new MidiTrack( fileStream );
				_trackArray[i] = track;
			 i++ ;
}
			
			
			if( separate && _format==0 ){
				_format = 1;
				
				_mainTrack = new MidiTrack();
				var tempArray:Array<Dynamic> = new Array<Dynamic>();
				var channels:Array<Dynamic> = new Array<Dynamic>();
				
				for each( var item:MessageItem in _trackArray[0].msgList ){
					if( Std.is(item,NoteItem )){
						if( channels.indexOf((cast(item,NoteItem)).channel)<0 ){
							_tracks++;
							
							channels.push((cast(item,NoteItem)).channel);
							tempArray[(cast(item,NoteItem)).channel] = new MessageList();
						}
						tempArray[(cast(item,NoteItem)).channel].push(item);
					}
					else if( Std.is(item,ChannelItem )){
						if( channels.indexOf((cast(item,ChannelItem)).channel)<0 ){
							_tracks++;
							
							channels.push((cast(item,ChannelItem)).channel);
							tempArray[(cast(item,ChannelItem)).channel] = new MessageList();
						}
						tempArray[(cast(item,ChannelItem)).channel].push(item);
					}else{
						_mainTrack.msgList.push(item);
					}
				}
				
				_trackArray[0] = _mainTrack;

			 i=0 ;
	while( i<tempArray.length ){
					if( tempArray[i] ){
						track = new MidiTrack();
						track.msgList = tempArray[i];
						_trackArray.push(track);
					}
				 i++ ;
}
			}else{
				_mainTrack = _trackArray[0];
			}

		}
		
		
		public function output():ByteArray{
			var file:ByteArray = new ByteArray();
			
			
			file.writeInt( MThd );
			
			
			file.writeInt( HDRSIZE );
			
			
			file.writeShort( _format );
			file.writeShort( _tracks );
			file.writeShort( _division );
			
			
		 var i:Int=0 ;
	while( i< _tracks ){
				_trackArray[i].serialize(file);
			 i++;
}
			
			
			return file;
		}
		
		
		public function track(num:Int):MidiTrack{
			if( num >=_tracks )
				return null;
			else
				return _trackArray[num];
		}
		
		
		public function addTrack(track:MidiTrack=null):Int{
			
			if( null==track ){
				return addTrack(new MidiTrack());
			}
			else{
				_tracks++;
				return _trackArray.push(track);
			}
		}
		
		
		public function deleteTrack(t:Int):MidiTrack{
			if( t<=0 ){
				
				throw new InvalidMidiError("Invalid track number. Can't delete main track.");
			}else if(t>=_tracks){
				throw new InvalidMidiError("Invalid track number. There isn't this track");
			}else{
				
				_tracks--;
				return _trackArray.splice(t,1)[0];
			}
		}
		
		
		public function setTrack(t:Int,track:MidiTrack):Void{
			if(t>=_tracks || t<0 ){
				throw new InvalidMidiError("Invalid track number. There isn't this track");
			}else if(track==null){
				throw new InvalidMidiError("Should n't a null midiTrack");
			}else{
				
				_trackArray[t]=track;
			}
		}
		
		
		public function swapTrack(t1:Int , t2:Int ):Void{
			if( t1<=0 || t2<=0 ){
				
				throw new InvalidMidiError("Invalid track number. Can't swap main track.");
			}else if( t1>=_tracks || t2>=_tracks ){
				throw new InvalidMidiError("Invalid track number. There isn't this track");
			}else{
				var temp:MidiTrack = _trackArray[t1];
				_trackArray[t1] = _trackArray[t2];
				_trackArray[t2] = temp;
				temp = null;
			}
		}
		
		
		public function insertTrack( t:Int , track:MidiTrack=null ):Int{
			if( t>=_tracks || t<0 ){
				throw new InvalidMidiError("Invalid inserting position number.");
			}
			if( null==track ){
				return insertTrack( t, new MidiTrack() );
			}
			else{
				_tracks++;
				_trackArray.splice(t,0,track);
				return _tracks;
			}
		}
		
		
		public function dispose():Void{
		 var i:Int=0 ;
	while( i< _trackArray.length ){
				_trackArray[i].dispose();
				
			 i++ ;
}
			_tracks = 0;
			_division = 0;
			_trackArray = new Array<Dynamic>();
		}
		
	}
	

