

package ocean.midi ;

	import flash.utils.ByteArray;
	import ocean.midi.model.ChannelItem;
	import ocean.midi.model.MessageItem;
	import ocean.midi.model.MessageList;
	import ocean.midi.model.MetaItem;
	import ocean.midi.model.NoteItem;
	import ocean.midi.model.RawItem;
	import ocean.utils.GreedyUINT;
	import ocean.midi.MidiEnum;
	import ocean.midi.model.SysxItem;
	import flash.errors.Error;

	
	class MidiTrack {
		
		private static var MTrk:Int = 0x4D54726B; 
		
		private var _size:Int;
		private var _trackChannel:Int;
		private var _trackPatch:Int;
		
		
		private var _msgList:MessageList;
		
		@:isVar public var msgList(get, set):MessageList;
		
		
		public function get_msgList():MessageList{
			return _msgList;
		}
		
		
		public function set_msgList(ml:MessageList):MessageList{
			_msgList = ml;
			for(item in _msgList ){
				if( (Std.is(item,ChannelItem)) && (item.command == MidiEnum.PROGRAM_CHANGE) ){
					_trackChannel = item.channel;
					_trackPatch = item.data1;
					break;
				}
			}
			
			return _msgList;
		}
		
		
		public function new( stream:ByteArray=null ):Void{
			if(stream==null){
				_msgList = new MessageList();
				_size = 0;
			}
			else if( stream.bytesAvailable != 0 ){
				_msgList = createList( stream );
			}
		}
		
		
		private function sortCase(a:RawItem,b:RawItem):Int{
			if( a.timeline < b.timeline ){
				return -1;
			}
			else if( a.timeline > b.timeline ){
				return 1;
			}
			else if( a.timeline==b.timeline ){
				if( a.index < b.index ){
					return -1;
				}
				else{
					return 1;
				}
			}
			return 0;
		}
		
		
		public function serialize( stream:ByteArray ):Void{
			stream.writeInt( MTrk );
			stream.writeInt( _size );
			var start:Int = stream.position;	
			var rawArray:Array<RawItem> = new Array<RawItem>();	
			var rawItem:RawItem;				
			var guint:GreedyUINT = new GreedyUINT(); 
			var kind:Int;
			var index:Int=0;

			
			for( tmpitem in _msgList ){
				
				var item:MessageItem = cast(tmpitem, MessageItem);
				
				if( !item.mark ){
					continue;
				}

				
				if ( item.kind == MidiEnum.META ) {
					var item_2:MetaItem = cast tmpitem;
					rawItem = new RawItem();
					rawItem.timeline = item_2.timeline;		
					rawItem.raw.writeByte( MidiEnum.META );	
					rawItem.raw.writeByte( item_2.type );		
					guint.value = item_2.size;				
					rawItem.raw.writeBytes(guint.rawBytes);	
					rawItem.raw.writeBytes(item_2.text);		
					if( item_2.type==MidiEnum.END_OF_TRK )
						rawItem.index = 0xFFFFFF;		
					else
						rawItem.index = index++;		
					rawArray.push(rawItem);
				}
				else if( item.kind == MidiEnum.NOTE ){
					
					var item_3:NoteItem = cast tmpitem;
					rawItem = new RawItem();
					rawItem.timeline = item_3.timeline;
					rawItem.noteOn = (item_3.channel | MidiEnum.NOTE_ON);	
					rawItem.raw.writeByte( item_3.pitch );
					rawItem.raw.writeByte( item_3.velocity );
					rawItem.index = index++;
					rawArray.push(rawItem);

						
					
					rawItem = new RawItem();
					rawItem.timeline = item_3.timeline + item_3.duration;	
					rawItem.noteOn = (item_3.channel | MidiEnum.NOTE_ON);
					rawItem.raw.writeByte( item_3.pitch );
					rawItem.raw.writeByte( 0x00 );						
					rawItem.index = index++;
					rawArray.push(rawItem);
				}
				else if ( item.kind == MidiEnum.SYSTEM_EXCLUSIVE ) {
					var item_4:SysxItem = cast tmpitem;
					rawItem = new RawItem();
					rawItem.timeline = item_4.timeline;
					rawItem.raw.writeByte( MidiEnum.SYSTEM_EXCLUSIVE );
					rawItem.raw.writeByte( item_4.size() );
					rawItem.raw.writeBytes( item_4.data );
					rawItem.index = index++;
					rawArray.push(rawItem);
					
				}
				else{
					
					var item_5:ChannelItem = cast tmpitem;
					
					if( item_5.data2==null ){
						rawItem = new RawItem();
						rawItem.timeline = item_5.timeline;
						rawItem.raw.writeByte( item_5.command | item_5.channel );
						rawItem.raw.writeByte( item_5.data1 );	
						rawItem.index = index++;
						rawArray.push(rawItem);
					}
					else{
						rawItem = new RawItem();
						rawItem.timeline = item_5.timeline;
						rawItem.noteOn = (item_5.channel | item_5.command);
						rawItem.raw.writeByte( item_5.data1 );
						rawItem.raw.writeByte( item_5.data2 );
						rawItem.index = index++;
						rawArray.push(rawItem);
						kind = item.kind;
					}
				}
			}
			
			rawArray.sort( sortCase );
			
			
			guint.value = 0;
			var note_on:Int = 0;

			 var i:Int=0 ;
			 while( i< rawArray.length ){
					guint.value = Std.int(rawArray[i].timeline - guint.value);
					
					
					stream.writeBytes(guint.rawBytes);
					
					
					if( note_on != rawArray[i].noteOn && rawArray[i].noteOn!=0 ){
						stream.writeByte( rawArray[i].noteOn );
					}
					
					
					stream.writeBytes(rawArray[i].raw);
					
					
					guint.value = rawArray[i].timeline;
					note_on = rawArray[i].noteOn;
				 i++ ;
			}
			
			
			stream.writeUnsignedInt(0x00FF2F00);
			
			
			_size = stream.position - start;
			
			
			stream[start-4]=(_size&0xFF000000)>>24;
			stream[start-3]=(_size&0xFF0000)>>16;
			stream[start-2]=(_size&0xFF00)>>8;
			stream[start-1]= (_size&0xFF);
		}
		
		
		public function getRawData():ByteArray{
			var rawData:ByteArray = new ByteArray();
			serialize(rawData);
			rawData.position = 0;
			return rawData;
		}
		
		
		public function createList(stream:ByteArray ):MessageList{
			
			if( stream.readInt() != MTrk ){
				throw new InvalidMidiError("MTrk header tag is incorrect, loads file error!");
			}
			
			
			_size = stream.readInt();
			
			
			var end:Int = stream.position + _size;
			
			
			var list:MessageList = new MessageList();
			var metaItem:MetaItem;
			var noteItem:NoteItem;
			var chItem:ChannelItem;
			var queue:Array<Dynamic> = new Array<Dynamic>();				
			var guint:GreedyUINT = new GreedyUINT();
			var timeline:Int = 0;
			var byte:Int;								
			var char:Int;								
			var channel:Int = 0;
			var command:Int = 0;
			
			while( stream.position < end ){
				
				
				guint.stream(stream);
				
				
				timeline += guint.value;
				
				
				byte = stream.readByte()&0xff;
				char = byte&0xF0;
				
				
				if( byte == MidiEnum.META ){
					metaItem = new MetaItem();	
					metaItem.timeline = timeline;	
					metaItem.kind = byte;
					byte = stream.readByte()&0xff;
					metaItem.type = byte;	
					guint.stream(stream);	
					
					
					
					if( guint.value>0 )
						stream.readBytes(metaItem.text,0,guint.value);	
					
					
					if( metaItem.type != MidiEnum.END_OF_TRK )
						list.push(metaItem);
				}
				
				else if( char == MidiEnum.PROGRAM_CHANGE || char == MidiEnum.CHANNEL_PRESSURE ){
					command = char;
					channel = byte&0x0F;
					chItem = new ChannelItem();
					chItem.timeline = timeline;
					chItem.kind = byte;
					chItem.channel = channel;
					chItem.command = command;
					chItem.data1 = stream.readByte()&0xff;
					list.push(chItem);
					
					
					if( char == MidiEnum.PROGRAM_CHANGE ){
						_trackPatch = chItem.data1;
					}
				}
				
				else if( char == MidiEnum.NOTE_ON ){
					command = char;
					channel = byte&0x0F;
					noteItem = new NoteItem();
					noteItem.timeline = timeline;
					noteItem.channel = channel;
					noteItem.kind = MidiEnum.NOTE;
					noteItem.pitch = stream.readByte()&0xff;
					noteItem.velocity = stream.readByte()&0xff;
					if( noteItem.velocity == 0){	
					 var i:Int=0 ;
	while( i<queue.length ){
							if( queue[i].pitch == noteItem.pitch && queue[i].channel == noteItem.channel ){
								
								queue[i].duration = noteItem.timeline - queue[i].timeline ;
								queue.splice(i,1);
								break;
							}
						 i++ ;
}
					}
					else{
						noteItem.duration = 0;
						list.push(noteItem);
						queue.push(noteItem);
					}
				}
				
				else if( byte < 0x80 ){

					noteItem = new NoteItem();
					noteItem.timeline = timeline;
					noteItem.channel = channel;
					noteItem.kind = MidiEnum.NOTE;
					noteItem.pitch = byte;	
					noteItem.velocity = stream.readByte()&0xff;
					if( command == MidiEnum.NOTE_ON ){
						if( noteItem.velocity == 0){
						 var i:Int=0 ;
	while( i<queue.length ){
								if( queue[i].pitch == noteItem.pitch && queue[i].channel == noteItem.channel ){
									queue[i].duration = noteItem.timeline - queue[i].timeline ;
									queue.splice(i,1);
									break;
								}
							 i++ ;
}
						}
						else{
							noteItem.duration = 0;
							list.push(noteItem);
							queue.push(noteItem);
						}
					}
					
					else{
						chItem = new ChannelItem();
						chItem.timeline = timeline;
						chItem.channel = channel;
						chItem.command = command;
						chItem.data1 = noteItem.pitch;
						chItem.data2 = noteItem.velocity;
						chItem.kind = command|channel;
						list.push(chItem);
					}
					
				}
				
				else if	( char == MidiEnum.NOTE_OFF ){
					command = char;
					channel = byte&0x0F;
					
					noteItem = new NoteItem();
					noteItem.timeline = timeline;
					noteItem.channel = channel;
					noteItem.kind = MidiEnum.NOTE;
					noteItem.pitch = stream.readByte()&0xff;	
					noteItem.velocity = stream.readByte()&0xff;
					
				 var i:Int=0 ;
	while( i<queue.length ){
						if( queue[i].pitch == noteItem.pitch && queue[i].channel == noteItem.channel ){
							queue[i].duration = noteItem.timeline - queue[i].timeline ;
							queue.splice(i,1);
							break;
						}
					 i++ ;
}
				}
				
				else if ( char == MidiEnum.CONTROL_CHANGE || char == MidiEnum.POLY_PRESSURE || char == MidiEnum.PITCH_BEND ){
					command = char;
					channel = byte&0x0F;
					chItem = new ChannelItem();
					chItem.timeline = timeline;
					chItem.channel = channel;
					chItem.command = command;
					chItem.data1 = stream.readByte()&0xff;
					chItem.data2 = stream.readByte()&0xff;
					
					list.push(chItem);
				}
				
				else if ( byte == MidiEnum.END_OF_SYS_EX || byte == MidiEnum.SYSTEM_EXCLUSIVE){
					
					
					
					var sysExSize:Int = stream.readByte()&0xff;
					var sysx:SysxItem = new SysxItem();
					sysx.timeline = timeline;
					if( sysExSize > 0 ){
						stream.readBytes(sysx.data,0,sysExSize);
					}
					list.push(sysx);
				}
				
				else{
					throw new Error("meet system message, strange");
				}
			}
			_msgList = list;
			_trackChannel = channel;
			return list;
		}
		
		
		public function dispose():Void{
			_size = 0;
			_msgList = new MessageList();
		}
		
		
		public function get_trackChannel():Int{
			return _trackChannel;
		}
		
		
		public function get_trackPatch():Int{
			return _trackPatch;
		}
		
		
		public function set_trackChannel(ch:Int):Void{
			for ( item in _msgList )
			{
				if (Std.is(item, ChannelItem))
				{
					cast(item, ChannelItem).channel = ch;
				}
				else if (Std.is(item, NoteItem))
				{
					cast(item,NoteItem).channel = ch;
				}
			}
		}
		
		public function set_trackPatch(ph:Int):Void{
			for ( item in _msgList )
			{
				if ( Std.is(item, ChannelItem))
				{
					var tmp:ChannelItem = cast item;
					
					if (tmp.command == MidiEnum.PROGRAM_CHANGE)
					{
						tmp.data1 = ph;
						break;
					}
					
				}
			}
		}
		
		
	}
	

