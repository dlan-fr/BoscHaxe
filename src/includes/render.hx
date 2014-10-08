package includes;

import bigroom.input.KeyPoll;

class Render
{

	public static function render(key:KeyPoll, gfx:Graphicsclass, control:Controlclass):Void {
		var i:Int, j:Int, k:Int;
		
		
		gfx.fillrect(0, 0, gfx.screenwidth, gfx.screenheight, 1);
		
		
		j = Std.int((gfx.screenwidth-40) / 4);
		gfx.fillrect(control.currenttab * j, 0, j, gfx.linesize, 5);
		gfx.print(12, 0, "FILE", control.currenttab==0?0:2, false, true);
		gfx.print(j+ 2, 0, "ARRANGEMENT", control.currenttab==1?0:2, false, true);
		gfx.print((j * 2) + 2, 0, "INSTRUMENT", control.currenttab == 2?0:2, false, true);
		gfx.print((j * 3) + 2, 0, "ADVANCED", control.currenttab == 3?0:2, false, true);
		gfx.fillrect((j * 4), 0, 21, 10, 4);
		if (control.fullscreen) {
			gfx.print((j * 4) + 6, 0, "F", 2, false, true);
		}else{
		  gfx.print((j * 4) + 2, 0, "x" + Std.string(gfx.screenscale), 2, false, true);
		}
		gfx.fillrect((j * 4) + 20, 0, 21, 10, 3);
		gfx.drawicon((j * 4) + 26, 1, control.fullscreen?5:4);
		
		gfx.fillrect(0, gfx.linesize, gfx.screenwidth, gfx.linesize * 10, 5);
		
		switch(control.currenttab) {
			case 0:
				gfx.drawmenu(control);
		
			case 1:
				gfx.drawarrangementeditor(control);
				gfx.drawtimeline(control);
				gfx.drawpatternmanager(control);
			
		  case 2:
			  gfx.drawinstrumentlist(control);
				gfx.drawinstrument(control);
		
			case 3:
				gfx.drawadvancedmenu(control);
			
		}
		
		if (control.nowexporting) {
			gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.linesize * 13, 14);
			if (control.arrange.currentbar % 2 == 0) {
			i = -1;
		while( i < 10){
					gfx.fillrect((i * 64) + Help.slowsine, gfx.pianorollposition + gfx.linesize, 32, gfx.linesize * 13, 1);
				 i++;
	}
			}else {
			i = 0;
		while( i < 10){
					gfx.fillrect(0, gfx.pianorollposition + gfx.linesize + (i * 64) + Help.slowsine, gfx.screenwidth, 32, 1);
				 i++;
	}
				if (Help.slowsine >= 32) {
					gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, Help.slowsine-32, 1);
				}
			}
			if (Help.slowsine < 32) {
			  gfx.print(0, 170, "NOW EXPORTING AS WAV, PLEASE WAIT", 0, true, true);
			}
		}else if(control.currentbox>-1){
		  gfx.drawpatterneditor(control);
		}else {
			gfx.fillrect(0, gfx.pianorollposition + gfx.linesize, gfx.screenwidth, gfx.linesize * 13, 14);
		}
		
		if (control.messagedelay > 0) {
			i = control.messagedelay > 10?10:control.messagedelay;
			gfx.fillrect(0, gfx.screenheight - i, gfx.screenwidth, 10, 16);
			gfx.print(0, gfx.screenheight - i, control.message, 0, true, true);
		}
		
		
		gfx.drawlist(control);
		
		
		if (control.dragaction == 1 || control.dragaction == 2) {
			if (Math.abs(control.mx - control.dragx) > 4 || Math.abs(control.my - control.dragy) > 4) {
				gfx.drawmusicbox(control, control.mx, control.my, control.dragpattern);
			}
		}
		
		gfx.render(control);
	}
}