package co.sparemind.trackermodule ;
	class XMSampleFake extends XMSample {
		import flash.utils.ByteArray;
		import flash.utils.Endian;
		public function new() {
			this.bitsPerSample = 8;
			this.name = 'fake sample           ';
			this.data = new ByteArray();
			var sinewave:Array<Dynamic> = [
				0x0a,0x64,0x08,0x9c,0x06,0x05,0x04,0x03,0x64,0x00,0x00,
				0x00,0x9c,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
				0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
				0xd8,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,
				0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,
				0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe,0xfe
					];
			this.data.endian = Endian.LITTLE_ENDIAN;
		var i:Int = 0;
	while( i < sinewave.length){
				this.data.writeByte(sinewave[i]);
			 i++;
}
			loopLength = sinewave.length;
			loopsForward = true;
			volume = 40;
		}
	}


