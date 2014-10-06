package ;
	import flash.display.*;
	import flash.geom.*;
  import flash.events.*;
  import flash.net.*;
	
	class Musicphraseclass  {
		public function new():Void {
		var i:Int = 0;
	while( i < 129){
				notes.push(new Rectangle(-1, 0, 0, 0));
			 i++;
}
		i = 0;
	while( i < 16){
				cutoffgraph.push(128);
				resonancegraph.push(0);
				volumegraph.push(256);
			 i++;
}
			clear();
		}
		
		public function clear():Void {
		var i:Int = 0;
	while( i < 128){
				notes[i].setTo(-1, 0, 0, 0);
			 i++;
}
			
		i = 0;
	while( i < 16){
				cutoffgraph[i] = 128;
				resonancegraph[i] = 0;
				volumegraph[i] = 256;
			 i++;
}
			start = 48; 
			numnotes = 0;
			instr = 0;
			scale = 0; key = 0;
			
			palette = 0;
			isplayed = false;
			
			recordfilter = 0;
			topnote = -1; bottomnote = 250;
		}
		
		public function findtopnote():Void {
			topnote = -1;
		var i:Int = 0;
	while( i < numnotes){
				if (notes[i].x > topnote) {
					topnote = notes[i].x;
				}
			 i++;
}
		}
		
		public function findbottomnote():Void {
			bottomnote = 250;
		var i:Int = 0;
	while( i < numnotes){
				if (notes[i].x < bottomnote) {
					bottomnote = notes[i].x;
				}
			 i++;
}
		}
		
		
		public function addnote(noteindex:Int, note:Int, time:Int):Void {
			if (numnotes < 128) {
				notes[numnotes].setTo(note, time, noteindex, 0);
				numnotes++;
			}
			
			if (note > topnote) topnote = note;
			if (note < bottomnote) bottomnote = note;
			notespan = topnote-bottomnote;
		}
		
		public function noteat(noteindex:Int, note:Int):Bool {
			
		var i:Int = 0;
	while( i < numnotes){
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						return true;
					}
				}
			 i++;
}
			return false;
		}
		
		public function removenote(noteindex:Int, note:Int):Void {
			
		var i:Int = 0;
	while( i < numnotes){
				if (notes[i].x == note) {
					if (noteindex >= notes[i].width && noteindex < notes[i].width + notes[i].y) {
						deletenote(i);
						i--;
					}
				}
			 i++;
}
			
			findtopnote(); findbottomnote(); notespan = topnote-bottomnote;
		}
		
		public function setnotespan():Void {
			findtopnote(); findbottomnote(); notespan = topnote-bottomnote;
		}
		
		public function deletenote(t:Int):Void {
			
		var i:Int = t;
	while( i < numnotes){
				notes[i].x = notes[i + 1].x;
        notes[i].y = notes[i + 1].y;
        notes[i].width = notes[i + 1].width;
        notes[i].height = notes[i + 1].height;
			 i++;
}
			numnotes--;
		}
		
		public var notes: Array<Rectangle> = new Array<Rectangle>;
		public var start:Int;
		public var numnotes:Int;
		
		public var cutoffgraph: Array<Int> = new Array<Int>;
    public var resonancegraph: Array<Int> = new Array<Int>;
		public var volumegraph: Array<Int> = new Array<Int>;
		public var recordfilter:Int;
		
		public var topnote:Int, bottomnote:Int, notespan:Float;
		
		public var key:Int, scale:Int;
		
		public var instr:Int;
		
		public var palette:Int;
		
		public var isplayed:Bool;
	}

