package includes;


import bigroom.input.KeyPoll;
import haxe.io.BytesBuffer;
#if emscripten
import lime.utils.ByteArray;
import openfl.events.SampleDataEvent;
import lime.audio.AudioManager;
import lime.audio.openal.*;
#end

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
		
		public static function doOpenal(control:Control):Void
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
			Control._driver._streaming(e);
			
			
			AL.bufferData(c_buffer, AL.FORMAT_STEREO8, e.data, e.data.length, Std.int(Control._driver.sampleRate));
			
			var openal_error = AL.getError();
			
			if (openal_error != AL.NO_ERROR)
			{
				trace("OPEN AL bufferData error !"+openal_error);
				trace(AL.getErrorString());
			}
			
			//trace("enqueue buffer of " + e.data.length +" length, rate : " + Control._driver.sampleRate);
			
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
	

	
	public static function logic(key:KeyPoll):Void {
		var i:Int, j:Int, k:Int;
		
		if (Control.arrangescrolldelay > 0) {
			Control.arrangescrolldelay--;
		}
		
		if (Control.messagedelay > 0) {
			Control.messagedelay -= 2;
			if (Control.messagedelay < 0) Control.messagedelay = 0;
		}
	  if (Control.doubleclickcheck > 0) {
			Control.doubleclickcheck -= 2;
			if (Control.doubleclickcheck < 0) Control.doubleclickcheck = 0;
		}
		if (Gfx.buttonpress > 0) {
			Gfx.buttonpress -= 2;
			if (Gfx.buttonpress < 0) Gfx.buttonpress = 0;
		}
		
		if (Control.minresizecountdown > 0) {
			Control.minresizecountdown -= 2;
			if (Control.minresizecountdown <= 0) {
				Control.minresizecountdown = 0;
				Gfx.forceminimumsize();
			}
		}
		
		if (Control.savescreencountdown > 0) {
			Control.savescreencountdown -= 2;
			if (Control.savescreencountdown <= 0) {
				Control.savescreencountdown = 0;
				Control.savescreensettings();
			}
		}
		
		if (Control.dragaction == 2) {
			Control.trashbutton+=2;
			if (Control.trashbutton > 10) Control.trashbutton = 10;
		}else {
			if (Control.trashbutton > 0) Control.trashbutton--;
		}
		
		if (Control.followmode) {
			if (Control.arrange.currentbar < Control.arrange.viewstart) {
				Control.arrange.viewstart = Control.arrange.currentbar;
			}
			if (Control.arrange.currentbar > Control.arrange.viewstart+5) {
				Control.arrange.viewstart = Control.arrange.currentbar;
			}
		}
	}
}
