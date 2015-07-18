/*
 * 
BOSCA CEOIL - Terry Cavanagh 2013 / http://www.distractionware.com

Haxe port by @dlan_fr 
 
Available under FreeBSD licence. Have fun!
	
This problem uses the SiON Library by Kei Mesuda.
	
The SiON Library is 

Copyright 2008-2010 Kei Mesuda (keim) All rights reserved.
Redistribution and use in source and binary forms,

with or without modification, are permitted provided that
the following conditions are met: 
1. Redistributions of source code must retain the above copyright notice,
   this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/



package ;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import openfl.Assets;

//import flash.ui.ContextMenu;
//import flash.ui.ContextMenuItem;
//import flash.ui.Keyboard;
import bigroom.input.KeyPoll;
import flash.ui.Mouse;
import flash.utils.Timer;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.TimerEvent;
import flash.display.StageDisplayState;


import includes.Input;
import includes.Logic;
import includes.Render;

#if emscripten
import lime.audio.AudioManager;
import lime.audio.openal.AL;
#end

import ocean.midi.MidiEnum;
/*
import Input;
import Logic;
import Render;*/

/**
 * ...
 * @author dlan
 */

class Main extends Sprite 
{
	var inited:Bool;

	/* ENTRY POINT */
		public var key:KeyPoll;
		
		
		
		// Timer information (a shout out to ChevyRay for the implementation)
		inline public static var TARGET_FPS:Float = 30; // the fixed-FPS we want the control to run at
		private var	_rate:Float = 1000 / TARGET_FPS; // how long (in seconds) each frame is
		private var	_skip:Float; // this tells us to allow a maximum of 10 frame skips
		private var	_last:Float = -1;
		private var	_current:Float = 0;
		private var	_delta:Float = 0;
		private var	_timer:Timer = new Timer(4);
		
		//Embedded resources:		
	//	[Embed(source = 'graphics/icons.png')]	private var im_icons:Class;
	
	
	function resize(e) 
	{
		if (!inited) 
		{
			init();
		}
		else
		{
			// adjust the gui to fit the new device resolution
			var tempwidth:Int, tempheight:Int;
			if (e != null) {
				tempwidth = Lib.current.stage.stageWidth;
				tempheight = Lib.current.stage.stageHeight;
			}else {
				tempwidth = Gfx.windowwidth;
				tempheight = Gfx.windowheight;
			}
			
			Control.savescreencountdown = 30; //Half a second after a resize, save the settings
			Control.minresizecountdown = 5; //Force a minimum screensize
			Gfx.changewindowsize(tempwidth, tempheight);
			
			Gfx.patternmanagerx = Gfx.screenwidth - 116;
			Gfx.patterneditorheight = Std.int((Gfx.windowheight - (Gfx.pianorollposition - (Gfx.linesize + 2))) / 12);
			Gfx.notesonscreen = Std.int(((Gfx.screenheight - Gfx.pianorollposition - Gfx.linesize) / Gfx.linesize) + 1);
			Gfx.tf_1.width = Gfx.windowwidth;
			Gfx.updateboxsize();
			
			Guiclass.changetab(Control.currenttab);
			
			var temp:BitmapData = new BitmapData(Gfx.windowwidth, Gfx.windowheight, false, 0x000000);
			Gfx.updatebackground = 5;
			Gfx.backbuffercache = new BitmapData(Gfx.windowwidth, Gfx.windowheight, false, 0x000000);
			temp.copyPixels(Gfx.backbuffer, Gfx.backbuffer.rect, Gfx.tl);
			Gfx.backbuffer = temp;
			//gfx.screen.bitmapData.dispose();
			Gfx.screen.bitmapData = Gfx.backbuffer;
			if (Gfx.scalemode == 1) {
				Gfx.screen.scaleX = 1.5;
				Gfx.screen.scaleY = 1.5;
			}else {
				Gfx.screen.scaleX = 1;
				Gfx.screen.scaleY = 1;
			}
		}
			
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		MidiEnum.init();
		
		Control.versionnumber = "v2.0";
		Control.version = 3;
		Control.ctrl = "Ctrl";//Set this to Cmd on Mac so that the tutorial is correct
		
		_skip = _rate * 10;
		
		
		key = new KeyPoll(Lib.current.stage);
		Control.init();
		
		//Working toward resolution independence
		Gfx.init(Lib.current.stage);
		
		var tempbmp:Bitmap;
		tempbmp = new Bitmap(Assets.getBitmapData("graphics/icons.png"));
		Gfx.buffer = tempbmp.bitmapData;	
		Gfx.makeiconarray();
		
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_blue.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_purple.png")); Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_red.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_orange.png")); Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_green.png")); Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_cyan.png")); Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_gray.png")); Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/logo_shadow.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/tutorial_longnote.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/tutorial_drag.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/tutorial_timelinedrag.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/tutorial_patterndrag.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		tempbmp =  new Bitmap(Assets.getBitmapData("graphics/tutorial_secret.png"));	Gfx.buffer = tempbmp.bitmapData;	Gfx.addimage();
		
		
		Gfx.buffer = new BitmapData(Gfx.screenwidth, Gfx.screenheight, false, 0x000000);
		
		Control.voicelist.fixlengths();
		
		//Lib.current.stage.fullScreenSourceRect = new Rectangle(0, 0, 768, 480);
		addChild(Gfx.screen);
		
		Control.loadscreensettings();
		updategraphicsmode();
		
		Gfx.changescalemode(2);
		
		if (Guiclass.firstrun) {
			Guiclass.changewindow("firstrun");
			Control.changetab(Control.currenttab); Control.clicklist = true;
		}
		
		#if emscripten
			Logic.initopenal();
		#end
		
		_timer.addEventListener(TimerEvent.TIMER, mainloop);
		_timer.start();
	}
	
	public function _input():Void {
			if (Gfx.scalemode == 1) {
				Control.mx = Std.int(mouseX / 1.5);
				Control.my = Std.int(mouseY / 1.5);
			}
			else
			{
				Control.mx = Std.int(mouseX);
				Control.my = Std.int(mouseY);
			}
			
			Input.input(key,updategraphicsmode);
		}
		
    public function _logic():Void {
			Logic.logic(key);
			Help.updateglow();
			
			if (Control.forceresize) {
				Control.forceresize = false;
				resize(null);
			}
		}
		
		public function _render():Void {
			Gfx.backbuffer.lock();
			Render.render(key);
			
		}
		
		public function mainloop(e:TimerEvent):Void {
			_current = Lib.getTimer();
			if (_last < 0) _last = _current;
			_delta += _current - _last;
			_last = _current;
			if (_delta >= _rate){
				_delta %= _skip;
				while (_delta >= _rate){
					_delta -= _rate;
					_input();
					_logic();
					if (key.hasclicked) key.click = false;
					if (key.hasrightclicked) key.rightclick = false;
					if (key.hasmiddleclicked) key.middleclick = false;
				}
				_render();
				
				#if emscripten
				Logic.doOpenal();
				#end
				
				e.updateAfterEvent();
			}
		}
		
		public function updategraphicsmode():Void{
		 	if (Control.fullscreen) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}else {
				stage.displayState = StageDisplayState.NORMAL;
			}
			
			Control.savescreensettings();
		}
		
		/*public function onInvokeEvent(event:InvokeEvent):void{
				if (event.arguments.length > 0) {
					if (control.startup == 0) {
						//Loading a song at startup, wait until the sound is initilised
						control.invokefile = event.arguments[0];
					}else {
						//Program is up and running, just load now
						control.invokeceol(event.arguments[0]);
					}
				}
			}*/

	/* SETUP */
	

	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, added);
		
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
