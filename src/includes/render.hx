package includes;

import bigroom.input.KeyPoll;

class Render
{

	public static function render(key:KeyPoll):Void {
		var i:Int, j:Int, k:Int;
		
			if (Gfx.updatebackground > 0) {
			Gfx.changeframerate(30);
			
			Gfx.fillrect(0, 0, Gfx.screenwidth, Gfx.screenheight, 1);
			
			
			#if desktop
				j = (Gfx.screenwidth - 40) / 4;
			#end
			
			#if web
				j = (Gfx.screenwidth) / 4;
			#end
			
			if (Control.currenttab == Control.MENUTAB_HELP) {
				Gfx.fillrect(0, 0, j, Gfx.linesize, 5);
				Gfx.print(14, 0, "HELP", Control.currenttab == Control.MENUTAB_HELP?0:2, false, true);
			}else if (Control.currenttab == Control.MENUTAB_CREDITS) {
				Gfx.fillrect(0, 0, j, Gfx.linesize, 5);
				Gfx.print(14, 0, "CREDITS", Control.currenttab == Control.MENUTAB_CREDITS?0:2, false, true);
			}else{
				Gfx.fillrect(Control.currenttab * j, 0, j, Gfx.linesize, 5);
				Gfx.print(14, 0, "FILE", Control.currenttab == Control.MENUTAB_FILE?0:2, false, true);
			}
			Gfx.print(j + 14, 0, "ARRANGEMENT", Control.currenttab==Control.MENUTAB_ARRANGEMENTS?0:2, false, true);
			Gfx.print((j * 2) + 14, 0, "INSTRUMENT", Control.currenttab == Control.MENUTAB_INSTRUMENTS?0:2, false, true);
			Gfx.print((j * 3) + 14, 0, "ADVANCED", Control.currenttab == Control.MENUTAB_ADVANCED?0:2, false, true);
			
			#if desktop
				Gfx.fillrect((j * 4), 0, 42, 20, 3);
				Gfx.drawicon((j * 4) + 12, 1, Control.fullscreen?5:4);
			#end
			
			if (Control.nowexporting) {
				Gfx.updatebackground = 5;
				Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize), 14);
				if (Control.arrange.currentbar % 2 == 0) {
					Guiclass.tx = Std.int(Gfx.screenwidth / 64) + 1;
				i = -1;
		while( i < Guiclass.tx){
						Gfx.fillrect((i * 64) + help.slowsine, Gfx.pianorollposition + Gfx.linesize, 32,  Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize), 1);
					 i++;
	}
				}else {
					Guiclass.tx = Std.int(Gfx.screenheight - (Gfx.pianorollposition + Gfx.linesize) / 64) + 1;
				i = 0;
		while( i < Guiclass.tx){
						Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize + (i * 64) + help.slowsine, Gfx.screenwidth, 32, 1);
					 i++;
	}
					if (help.slowsine >= 32) {
						Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, help.slowsine-32, 1);
					}
				}
				if (help.slowsine < 32) {
					Gfx.print(Gfx.screenwidthmid - (Gfx.len("NOW EXPORTING AS WAV, PLEASE WAIT") / 2), (Gfx.pianorollposition + Gfx.linesize)+ (Gfx.screenheight - Gfx.hig("WAV") - (Gfx.pianorollposition + Gfx.linesize))/2, "NOW EXPORTING AS WAV, PLEASE WAIT", 0, false, true);
				}
			}else if(Control.currentbox>-1){
				Gfx.drawpatterneditor();
			}else {
				Gfx.fillrect(0, Gfx.pianorollposition + Gfx.linesize, Gfx.screenwidth, Gfx.screenheight - Gfx.pianorollposition, 14);
			}
			
			
			Gfx.fillrect(0, Gfx.linesize, Gfx.screenwidth, Gfx.linesize * 10, 5);
		j = 0;
		while( j < Gfx.linesize * 10){
				if (j % 4 == 0) {
					Gfx.fillrect(0, Gfx.linesize + j, Gfx.screenwidth, 2, 1);
				}
			 j++;
	}
			
			switch(Control.currenttab) {
				case Control.MENUTAB_FILE:
					Guiclass.tx = (Gfx.screenwidth - 768) / 4;
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);
					Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408+24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
				break;
				case Control.MENUTAB_CREDITS:
					Guiclass.tx = (Gfx.screenwidth - 768) / 4;
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);
					Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408+24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
				break;
				case Control.MENUTAB_HELP:
					Guiclass.tx = (Gfx.screenwidth - 768) / 2;
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 768, Gfx.linesize * 10, 5);
				break;
				case Control.MENUTAB_ARRANGEMENTS:
					Gfx.drawarrangementeditor();
					Gfx.drawtimeline();
					Gfx.drawpatternmanager();
				break;
				case Control.MENUTAB_INSTRUMENTS:
					Gfx.drawinstrumentlist();
					Gfx.drawinstrument();
				break;
				case Control.MENUTAB_ADVANCED:
					Guiclass.tx = (Gfx.screenwidth - 768) / 4;
					Gfx.fillrect(Guiclass.tx, Gfx.linesize, 408, Gfx.linesize * 10, 5);
					Gfx.fillrect(Gfx.screenwidth - Guiclass.tx - 408+24, Gfx.linesize, 408, Gfx.linesize * 10, 5);
				break;
			}
			
			
			Gfx.updatebackground--;
			if (Gfx.updatebackground == 0) {
				Gfx.settrect(Gfx.backbuffer.rect.x, Gfx.backbuffer.rect.y, Gfx.backbuffer.rect.width, Gfx.backbuffer.rect.height);
				Gfx.backbuffercache.copyPixels(Gfx.backbuffer, Gfx.trect, Gfx.tl);
			}
		}else {
			if(!Control.musicplaying) Gfx.changeframerate(15); 
			
			Gfx.settrect(Gfx.backbuffercache.rect.x, Gfx.backbuffercache.rect.y, Gfx.backbuffercache.rect.width, Gfx.backbuffercache.rect.height);
			Gfx.backbuffer.copyPixels(Gfx.backbuffercache, Gfx.trect, Gfx.tl);
		}
		
		if (Control.currenttab == Control.MENUTAB_ARRANGEMENTS) {
			Gfx.drawarrangementcursor();
			if (Control.mx > Gfx.patternmanagerx - 108) {
				Gfx.drawpatternmanager();
			}
			Gfx.drawtimeline_cursor();
			Gfx.drawpatternmanager_cursor();
		}
		
		if (!Control.nowexporting) {
			if (Control.currentbox > -1) {
			  Gfx.drawpatterneditor_cursor();
			}
		}
		
		Guiclass.drawbuttons();
		
		if (Control.messagedelay > 0) {
			i = Control.messagedelay > 10?10:Control.messagedelay;
			Gfx.fillrect(0, Gfx.screenheight - (i * 2), Gfx.screenwidth, 20, 16);
			Gfx.print(Gfx.screenwidthmid - (Gfx.len(Control.message) / 2), Gfx.screenheight - (i * 2), Control.message, 0, false, true);
		}
		
		
		Gfx.drawlist();
		
		
		if (Control.dragaction == 1 || Control.dragaction == 2) {
			if (Math.abs(Control.mx - Control.dragx) > 4 || Math.abs(Control.my - Control.dragy) > 4) {
				Gfx.drawmusicbox(Control.mx, Control.my, Control.dragpattern);
			}
		}
		
		Gfx.render();
	}
}