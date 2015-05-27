package includes;


import bigroom.input.KeyPoll;
import haxe.io.BytesBuffer;
import lime.utils.ByteArray;
import openfl.events.SampleDataEvent;
import lime.audio.AudioManager;
import lime.audio.openal.*;

class Logic
{
	#if emscripten
		private static var dyn_buffer:Array<UInt>;
		private static var dyn_source:UInt = 0;
		private static var al_context:ALContext;
		private static var al_device:ALDevice;
		
		
		public static function initopenal():Void
		{
			trace("OpenAL : Default device " + ALC.getString(null, ALC.DEFAULT_DEVICE_SPECIFIER));
			al_device = ALC.openDevice();
			
			var openalerror = ALC.getError(al_device);
			
			if (openalerror != ALC.NO_ERROR)
			{
				trace("OpenAL : error opening device ! " + ALC.getErrorString(al_device));
			}
			
			al_context = ALC.createContext(al_device);
			
			openalerror = ALC.getError(al_device);
			
			
			
			if (openalerror != ALC.NO_ERROR)
			{
				trace("OpenAL : error creating context ! " + ALC.getErrorString(al_device));
			}
			
			ALC.makeContextCurrent(al_context);
			
			openalerror = ALC.getError(al_device);
			
			if (openalerror != ALC.NO_ERROR)
			{
				trace("OpenAL : error making context current ! " + ALC.getErrorString(al_device));
			}
			
			
			
			trace("OpenAL version : " + AL.getString(AL.VERSION));
			trace("OpenAL vendor : " + AL.getString(AL.VENDOR));
			trace("OpenAL renderer : " + AL.getString(AL.RENDERER));
			
			dyn_buffer = AL.genBuffers(4);
			
			for (ibuff in dyn_buffer)
			{
				if (!AL.isBuffer(ibuff))
				{
					trace("OPEN AL genBuffer error ! value"+ibuff);
				}
			}
			
			dyn_source = AL.genSource();
		
			if (!AL.isSource(dyn_source))
			{
				trace("OPEN AL genSource error !");
				trace(AL.getErrorString());
			}
			
			//enqueue empty buffer
			var emptybuffer:ByteArray = new ByteArray(); 
			var i:Int = 0;
			for (i in 0...2048){
				emptybuffer.writeFloat(0);
				emptybuffer.writeFloat(0);
			}
			
			AL.bufferData(dyn_buffer[0], AL.FORMAT_STEREO8,emptybuffer, emptybuffer.length, 44100);
			
			var openal_error = AL.getError();
			
			if (openal_error != AL.NO_ERROR)
			{
				trace("OPEN AL bufferData error !"+openal_error);
				trace(AL.getErrorString());
			}
			
			AL.sourceQueueBuffer(dyn_source, dyn_buffer[0]);
			
			var openal_error = AL.getError();
			
			if (openal_error != AL.NO_ERROR)
			{
				trace("OPEN AL sourceQueueBuffer error !"+openal_error);
				trace(AL.getErrorString());
			}
			
			var source_state:Int =  AL.getSourcei(dyn_source, AL.SOURCE_STATE);
			
			if (source_state != AL.PLAYING)
			{
				//play buffer
				AL.sourcePlay(dyn_source);
			}
		}
		
		public static function doOpenal(control:Controlclass):Void
		{
			//custom emscripten sound handling, hopefully it will go away with future version of Openfl
			var bufferProcessed:Int =  AL.getSourcei(dyn_source, AL.BUFFERS_PROCESSED);
			
			var c_buffer:UInt = 0;
			
			if (bufferProcessed == 1) //our buffer has been processed, unqueue it
			{
				c_buffer = AL.sourceUnqueueBuffer(dyn_source);
				
				var openal_error = AL.getError();
		
				if (openal_error != AL.NO_ERROR)
				{
					trace("OPEN AL sourceUnqueueBuffer error !"+openal_error);
					trace(AL.getErrorString());
				}
			}
			else //our buffer is still not processed, don't queue another buffer for now
			{
				return;
			}
				
			
			//just call directly the streaming function
			var e:SampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
			control._driver._streaming(e);
			
			
			AL.bufferData(c_buffer, AL.FORMAT_STEREO8, e.data, e.data.length, Std.int(control._driver.sampleRate));
			
			var openal_error = AL.getError();
			
			if (openal_error != AL.NO_ERROR)
			{
				trace("OPEN AL bufferData error !"+openal_error);
				trace(AL.getErrorString());
			}
			
			//trace("enqueue buffer of " + e.data.length +" length, rate : " + control._driver.sampleRate);
			
			AL.sourceQueueBuffer(dyn_source, c_buffer);
			
			var openal_error = AL.getError();
			
			if (openal_error != AL.NO_ERROR)
			{
				trace("OPEN AL sourceQueueBuffer error !"+openal_error);
				trace(AL.getErrorString());
			}
			
			var source_state:Int =  AL.getSourcei(dyn_source, AL.SOURCE_STATE);
			
			if (source_state != AL.PLAYING)
			{
				//play buffer
				AL.sourcePlay(dyn_source);
			}
		}
		
	#end
	

	
	public static function logic(key:KeyPoll, gfx:Graphicsclass, control:Controlclass):Void {
		var i:Int, j:Int, k:Int;
		
		if (control.messagedelay > 0) control.messagedelay--;
	  if (control.doubleclickcheck > 0) control.doubleclickcheck--;
		if (gfx.buttonpress > 0) gfx.buttonpress--;
		
		if (control.dragaction == 2) {
			control.trashbutton++;
			if (control.trashbutton > 10) control.trashbutton = 10;
		}else {
			if (control.trashbutton > 0) control.trashbutton--;
		}
		
		if (control.followmode) {
			if (control.arrange.currentbar < control.arrange.viewstart) {
				control.arrange.viewstart = control.arrange.currentbar;
			}
			if (control.arrange.currentbar > control.arrange.viewstart+5) {
				control.arrange.viewstart = control.arrange.currentbar;
			}
		}
	}
}
