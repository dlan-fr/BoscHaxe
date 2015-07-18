package co.sparemind.trackermodule ;
	class XMPatternLine {
		public var cellOnTrack: Array<XMPatternCell>;

		public function new(numtracks:Int) {
			cellOnTrack = new Array<XMPatternCell>();
		var i:Int = 0;
	while( i < numtracks){
				cellOnTrack[i] = new XMPatternCell();
			 i++;
}
		}
	}

