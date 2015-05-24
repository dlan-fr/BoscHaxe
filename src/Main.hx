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

#if cpp
import cpp.vm.Debugger;
#end
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

#if cpp
import debugger.Local;
#end
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
	public var gfx:Graphicsclass;
		public var control:Controlclass;
		public var key:KeyPoll;
		
		// Timer information (a shout out to ChevyRay for the implementation)
		inline public static var TARGET_FPS:Float = 60; // the fixed-FPS we want the control to run at
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
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (inited) return;
		inited = true;
		
		_skip = _rate * 10;
		
		gfx = new Graphicsclass();
		
		key = new KeyPoll(Lib.current.stage);
		control = new Controlclass();
		
		gfx.init();
		var tempbmp:Bitmap;
		tempbmp = new Bitmap(Assets.getBitmapData("graphics/icons.png"));
		gfx.buffer = tempbmp.bitmapData;	
		gfx.makeiconarray();
		gfx.buffer = new BitmapData(gfx.screenwidth, gfx.screenheight, false, 0x000000);
		control.voicelist.fixlengths(gfx);
		
		//Lib.current.stage.fullScreenSourceRect = new Rectangle(0, 0, 768, 480);
		addChild(gfx);
		
		control.loadscreensettings(gfx);
		updategraphicsmode(control);
		
		_timer.addEventListener(TimerEvent.TIMER, mainloop);
		_timer.start();

		
	}
	
	public function _input():Void {
			control.mx = Std.int(mouseX / gfx.screenscale);
			control.my = Std.int(mouseY / gfx.screenscale);
			Input.input(key, gfx, control,updategraphicsmode);
			
		}
		
    public function _logic():Void {
			Logic.logic(key, gfx, control);
			Help.updateglow();
		}
		
		public function _render():Void {
			gfx.backbuffer.lock();
			Render.render(key, gfx, control);
			
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
				e.updateAfterEvent();
			}
		}
		
		public function updategraphicsmode(control:Controlclass):Void{
		 	if (control.fullscreen) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}else {
				stage.displayState = StageDisplayState.NORMAL;
			}
			
			control.savescreensettings(gfx);
		}
		
		/*public function onInvokeEvent(event:InvokeEvent):Void{
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
		//new Local(true);
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
